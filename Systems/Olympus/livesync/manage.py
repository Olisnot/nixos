"""Local provisioning/checks. Never log HTTP bodies, headers or credentials."""

import base64
import grp
import json
import os
import secrets
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid
from pathlib import Path

DIRECTORY = Path("/etc/obsidian-livesync")
DB = "obsidian-livesync"
LOCAL = "http://127.0.0.1:5984"
ORIGINS = ["app://obsidian.md", "capacitor://localhost", "http://localhost"]


def credentials():
    DIRECTORY.mkdir(mode=0o750, exist_ok=True)
    os.chown(DIRECTORY, 0, grp.getgrnam("couchdb").gr_gid)
    os.chmod(DIRECTORY, 0o750)
    path = DIRECTORY / "credentials.json"
    if not path.exists():
        # Refuse to silently replace credentials for an existing database.
        if any(Path("/var/lib/couchdb").rglob("*.couch")):
            raise RuntimeError(
                "Existing CouchDB data but no credentials; restore the original secrets"
            )
        value = {
            "admin_user": "livesync-admin",
            "admin_password": secrets.token_hex(32),
            "sync_user": "obsidian-sync",
            "sync_password": secrets.token_hex(32),
        }
        with path.open("x") as output:
            os.chmod(path, 0o600)
            json.dump(value, output)
            output.flush()
            os.fsync(output.fileno())
    value = read_secrets(path)
    ini = DIRECTORY / "admin.ini"
    # Runtime-only file, never evaluated/read by Nix. Do not replace local.ini:
    # CouchDB can persist its hashed administrator entry there.
    if not ini.exists():
        with ini.open("x") as output:
            os.chmod(ini, 0o640)
            os.chown(ini, 0, grp.getgrnam("couchdb").gr_gid)
            output.write(
                f"[admins]\n{value['admin_user']} = {value['admin_password']}\n"
            )


def read_secrets(path=None):
    if path is None:
        path = (
            Path(os.environ.get("CREDENTIALS_DIRECTORY", str(DIRECTORY)))
            / "credentials.json"
        )
    value = json.loads(path.read_text())
    # Generated alphabet is intentionally safe for INI, Basic auth and usernames.
    for key in ("admin_password", "sync_password"):
        if not value[key] or any(char not in "0123456789abcdef" for char in value[key]):
            raise RuntimeError("Unexpected credential format")
    if value["admin_user"] != "livesync-admin" or value["sync_user"] != "obsidian-sync":
        raise RuntimeError("Unexpected account names")
    return value


class Client:
    def __init__(self, url, value=None, admin=False):
        self.url = url.rstrip("/")
        self.auth = None
        if value:
            prefix = "admin" if admin else "sync"
            token = f"{value[prefix + '_user']}:{value[prefix + '_password']}"
            self.auth = "Basic " + base64.b64encode(token.encode()).decode()
        self.opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))

    def request(self, method, path, body=None, expected=(200,), headers=None):
        request_headers = {"Content-Type": "application/json"}
        if self.auth:
            request_headers["Authorization"] = self.auth
        request_headers.update(headers or {})
        data = None if body is None else json.dumps(body).encode()
        request = urllib.request.Request(
            self.url + path, data=data, method=method, headers=request_headers
        )
        try:
            response = self.opener.open(request, timeout=20)
        except urllib.error.HTTPError as error:
            response = error
        with response:
            status = response.code
            raw = response.read()
            response_headers = response.headers
        if status not in expected:
            raise RuntimeError(
                f"HTTP check failed ({method}, status {status}); response suppressed"
            )
        return json.loads(raw) if raw else None, response_headers


def provision(value):
    admin = Client(LOCAL, value, admin=True)
    for attempt in range(60):
        try:
            admin.request("GET", "/_up")
            break
        except (OSError, RuntimeError):
            if attempt == 59:
                raise RuntimeError("CouchDB did not become ready") from None
            time.sleep(1)
    for database in ("_users", "_replicator", "_global_changes", DB):
        admin.request("PUT", "/" + database, expected=(201, 202, 412))
    admin.request(
        "PUT",
        f"/{DB}/_security",
        {
            # Database administrator, NOT a server administrator. Supports design
            # documents as well as ordinary PouchDB replication/checkpoints.
            "admins": {"names": [value["sync_user"]], "roles": []},
            "members": {"names": [value["sync_user"]], "roles": []},
        },
    )
    path = "/_users/org.couchdb.user:" + value["sync_user"]
    user, _ = admin.request("GET", path, expected=(200, 404))
    if user.get("error") == "not_found":
        admin.request(
            "PUT",
            path,
            {
                "_id": "org.couchdb.user:" + value["sync_user"],
                "name": value["sync_user"],
                "type": "user",
                "roles": [],
                "password": value["sync_password"],
            },
            expected=(201, 202),
        )
    # Existing user is not overwritten or rehashed on restart. Secret mismatch
    # must be repaired deliberately rather than silently rotating credentials.
    session, _ = Client(LOCAL, value).request("GET", "/_session")
    if (
        session["userCtx"]["name"] != value["sync_user"]
        or "_admin" in session["userCtx"]["roles"]
    ):
        raise RuntimeError("Expected a dedicated non-server-admin sync account")
    Client(LOCAL, value).request("GET", "/" + DB)
    print("LiveSync databases and scoped account ready; existing documents preserved.")


def check(value, url):
    parsed = urllib.parse.urlsplit(url)
    if (
        parsed.username
        or parsed.password
        or parsed.query
        or parsed.fragment
        or parsed.path not in ("", "/")
    ):
        raise RuntimeError(
            "Supply only the server base URL, without credentials or database path"
        )
    if parsed.scheme != "https" and url != LOCAL:
        raise RuntimeError("Remote checks require trusted HTTPS")
    client = Client(url, value)
    anonymous = Client(url)
    anonymous.request("GET", "/" + DB, expected=(401, 403))
    client.request("GET", "/" + DB)
    client.request("GET", "/_node/_local/_config", expected=(401, 403))
    client.request("PUT", "/livesync-forbidden-check", expected=(401, 403))
    for origin in ORIGINS:
        _, headers = anonymous.request(
            "OPTIONS",
            f"/{DB}/_bulk_docs",
            expected=(200, 204),
            headers={
                "Origin": origin,
                "Access-Control-Request-Method": "POST",
                "Access-Control-Request-Headers": "authorization,content-type",
            },
        )
        if (
            headers.get("Access-Control-Allow-Origin") != origin
            or headers.get("Access-Control-Allow-Credentials") != "true"
        ):
            raise RuntimeError("Credentialed CORS preflight failed")
        if "POST" not in headers.get("Access-Control-Allow-Methods", ""):
            raise RuntimeError("CORS methods failed")
    path = f"/{DB}/livesync-check-{uuid.uuid4().hex}"
    result, _ = client.request(
        "PUT", path, {"check": "disposable replication probe"}, expected=(201, 202)
    )
    try:
        client.request("GET", path)
        client.request("GET", f"/{DB}/_changes?feed=longpoll&since=0&timeout=1000")
    finally:
        client.request("DELETE", path + "?rev=" + result["rev"], expected=(200, 202))
    print(
        "HTTP(S)/auth/read/write/changes/CORS checks passed (probe deleted; tombstone retained)."
    )


def main():
    os.umask(0o077)
    if os.geteuid() != 0:
        raise RuntimeError("Run as root on Olympus")
    if sys.argv[1:] == ["credentials"]:
        credentials()
    elif sys.argv[1:] == ["provision"]:
        provision(read_secrets())
    elif len(sys.argv) in (2, 3) and sys.argv[1] == "check":
        check(read_secrets(), sys.argv[2] if len(sys.argv) == 3 else LOCAL)
    else:
        raise RuntimeError("Usage: livesync-check [https://hostname]")


if __name__ == "__main__":
    try:
        main()
    except Exception:  # noqa: BLE001 -- suppress secret-bearing library errors
        # urllib exceptions may include URLs or sensitive response content.
        print(
            "LiveSync operation failed; details suppressed to protect credentials. Check local service/configuration.",
            file=sys.stderr,
        )
        sys.exit(1)
