"""Explicit full-tunnel client policy, ahead of other VPNs' default routes."""

import json
from pathlib import Path
import subprocess
import sys

MARKER = Path("/run/wg-client-policy/owned")


def rules(family):
    overlay = "100.64.0.0/10" if family == "-4" else "fd7a:115c:a1e0::/48"
    return [
        ["pref", "900", "fwmark", "51820", "lookup", "main"],
        ["pref", "901", "to", overlay, "lookup", "52"],
        ["pref", "902", "lookup", "main", "suppress_prefixlength", "0"],
        ["pref", "903", "lookup", "51820"],
    ]


def run(*args, optional=False):
    result = subprocess.run(args, capture_output=True, text=True)
    if result.returncode and not optional:
        raise RuntimeError("WireGuard client policy operation failed")
    return result


def down():
    if not MARKER.exists():
        return
    for family in ["-4", "-6"]:
        for rule in rules(family):
            run("ip", family, "rule", "del", *rule, optional=True)
    MARKER.unlink(missing_ok=True)


def up():
    if MARKER.exists():
        down()
    for family in ["-4", "-6"]:
        existing = json.loads(run("ip", family, "-j", "rule", "show").stdout)
        if any(rule.get("priority") in [900, 901, 902, 903] for rule in existing):
            raise RuntimeError("Client policy priorities 900–903 are already in use")
    MARKER.touch(mode=0o600, exist_ok=False)
    run("wg", "set", "wg0", "fwmark", "51820")
    for family in ["-4", "-6"]:
        for rule in rules(family):
            run("ip", family, "rule", "add", *rule)


if __name__ == "__main__":
    try:
        if sys.argv[1:] == ["up"]:
            up()
        elif sys.argv[1:] == ["down"]:
            down()
        else:
            raise RuntimeError("Expected up or down")
    except Exception as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
