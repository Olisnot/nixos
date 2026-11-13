"""Real CouchDB + pinned Caddy/Coraza integration fixture."""

import base64
import importlib.util
import ssl
import subprocess
import sys
import urllib.request
from pathlib import Path

spec = importlib.util.spec_from_file_location("manage", sys.argv[1])
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
value = m.read_secrets()
ssl._create_default_https_context = lambda: ssl.create_default_context(
    cafile="/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt"
)
client = m.Client("https://livesync.test", value)
admin = m.Client(m.LOCAL, value, admin=True)
db = "/obsidian-livesync"
if len(sys.argv) > 2:
    doc, _ = client.request("GET", db + "/persistent-fixture")
    assert doc["payload"] == "survives restart"
    assert (
        Path("/tmp/secrets-before").read_bytes()
        == (m.DIRECTORY / "credentials.json").read_bytes()
    )
    sys.exit(0)

Path("/tmp/secrets-before").write_bytes((m.DIRECTORY / "credentials.json").read_bytes())
client.request(
    "PUT", db + "/persistent-fixture", {"payload": "survives restart"}, expected=(201,)
)
for name in ("_users", "_replicator", "_global_changes"):
    admin.request("GET", "/" + name)
admin.request("PUT", "/other-vault", expected=(201,))
client.request("GET", "/other-vault", expected=(403,))
client.request("PUT", db + "/_design/probe", {"views": {}}, expected=(201,))
result, _ = client.request(
    "POST",
    db + "/_bulk_docs",
    {
        "docs": [
            {
                "_id": "replication-probe",
                "body": "<script>alert('note content')</script>",
            },
            {"_id": "large-probe", "body": "x" * 2000000},
            {
                "_id": "attachment-probe",
                "_attachments": {
                    "probe.bin": {
                        "content_type": "application/octet-stream",
                        "data": base64.b64encode(bytes(range(256)) * 8192).decode(),
                    }
                },
            },
        ]
    },
    expected=(201, 202),
)
assert all("rev" in item for item in result)
client.request("POST", db + "/_revs_diff", {"replication-probe": [result[0]["rev"]]})
client.request("POST", db + "/_bulk_get", {"docs": [{"id": "replication-probe"}]})
client.request(
    "PUT", db + "/_local/checkpoint", {"last_seq": "fixture"}, expected=(201,)
)
client.request("GET", db + "/_local/checkpoint")
client.request("GET", db + "/_all_docs")
session, _ = client.request(
    "POST",
    "/_session",
    {
        "name": value["sync_user"],
        "password": value["sync_password"],
    },
)
assert session["name"] == value["sync_user"]
for origin in m.ORIGINS:
    _, headers = client.request("GET", db, headers={"Origin": origin})
    assert headers.get("Access-Control-Allow-Origin") == origin
    assert headers.get("Access-Control-Allow-Credentials") == "true"
request = urllib.request.Request(
    client.url + db + "/_changes?feed=continuous&since=now&heartbeat=1000",
    headers={"Authorization": client.auth},
)
with client.opener.open(request, timeout=5) as feed:
    assert feed.readline() == b"\n"  # Heartbeat delivered without buffering.
assert admin.request("GET", "/_node/_local/_config/chttpd/enable_cors")[0] == "true"
assert (
    admin.request("GET", "/_node/_local/_config/chttpd/max_http_request_size")[0]
    == "4294967296"
)
assert (
    admin.request("GET", "/_node/_local/_config/couchdb/max_document_size")[0]
    == "50000000"
)
logs = subprocess.run(
    [
        "journalctl",
        "-u",
        "couchdb",
        "-u",
        "caddy",
        "-u",
        "livesync-provision",
        "--no-pager",
    ],
    capture_output=True,
    text=True,
    check=True,
).stdout
for secret in (
    value["admin_password"],
    value["sync_password"],
    client.auth,
    admin.auth,
):
    assert secret not in logs
print("Replication operations and persistent fixture verified.")
