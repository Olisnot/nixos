"""Generate only fresh local secrets; never overwrite or print credentials."""

import os
from pathlib import Path
import secrets
import stat
import sys


def initialize(directory, database):
    directory = Path(directory)
    directory.mkdir(mode=0o700, exist_ok=True)
    info = directory.lstat()
    if (
        not stat.S_ISDIR(info.st_mode)
        or info.st_uid != 0
        or stat.S_IMODE(info.st_mode) != 0o700
    ):
        raise RuntimeError(
            "Credential directory must be a root-owned mode-700 directory"
        )
    files = [directory / "app.env", directory / "database.env"]
    present = [path.exists() or path.is_symlink() for path in files]
    if all(present):
        for path in files:
            info = path.lstat()
            if (
                not stat.S_ISREG(info.st_mode)
                or info.st_uid != 0
                or stat.S_IMODE(info.st_mode) != 0o600
            ):
                raise RuntimeError(
                    "Existing credential files must be regular, root-owned and mode 600"
                )
        return
    if any(present):
        raise RuntimeError(
            "Only one credential file exists; refusing to replace existing secrets"
        )
    database = Path(database)
    if database.exists() and any(database.iterdir()):
        raise RuntimeError(
            "Database state already exists; refusing to generate incompatible new credentials"
        )
    password = secrets.token_hex(32)
    contents = [
        f"DB_PASSWD={password}\nROMM_AUTH_SECRET_KEY={secrets.token_hex(32)}\n",
        f"MARIADB_PASSWORD={password}\nMARIADB_ROOT_PASSWORD={secrets.token_hex(32)}\n",
    ]
    created = []
    try:
        for path, content in zip(files, contents, strict=True):
            fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
            created.append(path)
            with os.fdopen(fd, "w") as output:
                output.write(content)
                output.flush()
                os.fsync(output.fileno())
    except Exception:
        for path in created:
            path.unlink(missing_ok=True)
        raise


if __name__ == "__main__":
    try:
        initialize(*sys.argv[1:])
    except Exception:
        print(
            "RomM secret initialization refused: check directory/file permissions, partial credentials or existing database state. Existing credentials are never overwritten.",
            file=sys.stderr,
        )
        sys.exit(1)
