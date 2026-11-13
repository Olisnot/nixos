"""Manage only the access-VPN policy rule and reserved table 51821."""

import json
from pathlib import Path
import subprocess
import sys

TABLE = 51821
PRIORITY = 11000
MARKER = Path("/run/wg-mullvad-egress/owned")


def run(*args, optional=False):
    result = subprocess.run(["ip", "-4", *args], capture_output=True, text=True)
    if result.returncode and not optional:
        raise RuntimeError("Access-VPN policy route operation failed")
    return result


def up():
    rules = json.loads(run("-j", "rule", "show").stdout)
    matches = [rule for rule in rules if rule.get("priority") == PRIORITY]
    if any(
        str(rule.get("table")) != str(TABLE) or rule.get("iif") != "wg0"
        for rule in matches
    ):
        raise RuntimeError("Reserved policy priority is already in use")
    routes = run("-j", "route", "show", "table", str(TABLE), optional=True)
    existing_routes = json.loads(routes.stdout or "[]")
    if (matches or existing_routes) and not MARKER.exists():
        raise RuntimeError(
            "Reserved policy resources already exist; refusing to overwrite them"
        )
    for route in existing_routes:
        if not (
            (
                route.get("dst") == "default"
                and route.get("type") == "unreachable"
                and route.get("metric") == 32760
            )
            or (
                route.get("dst") == "default"
                and route.get("gateway") == "169.254.77.2"
                and route.get("dev") == "qbt-mv-host"
                and route.get("metric") == 10
            )
            or (
                route.get("dst") == "169.254.77.0/30"
                and route.get("dev") == "qbt-mv-host"
            )
        ):
            raise RuntimeError("Reserved policy table is already in use")
    MARKER.touch(mode=0o600, exist_ok=True)
    # The unreachable default prevents RPDB fall-through if the veth vanishes.
    run(
        "route",
        "replace",
        "unreachable",
        "default",
        "table",
        str(TABLE),
        "metric",
        "32760",
    )
    run(
        "route",
        "replace",
        "169.254.77.0/30",
        "dev",
        "qbt-mv-host",
        "scope",
        "link",
        "table",
        str(TABLE),
    )
    run(
        "route",
        "replace",
        "default",
        "via",
        "169.254.77.2",
        "dev",
        "qbt-mv-host",
        "table",
        str(TABLE),
        "metric",
        "10",
    )
    if not matches:
        run("rule", "add", "pref", str(PRIORITY), "iif", "wg0", "lookup", str(TABLE))


def down():
    if not MARKER.exists():
        return
    # Exact selectors only: never flush unrelated administrator routes/rules.
    run(
        "rule",
        "del",
        "pref",
        str(PRIORITY),
        "iif",
        "wg0",
        "lookup",
        str(TABLE),
        optional=True,
    )
    run(
        "route",
        "del",
        "default",
        "via",
        "169.254.77.2",
        "dev",
        "qbt-mv-host",
        "table",
        str(TABLE),
        "metric",
        "10",
        optional=True,
    )
    run(
        "route",
        "del",
        "169.254.77.0/30",
        "dev",
        "qbt-mv-host",
        "table",
        str(TABLE),
        optional=True,
    )
    run(
        "route",
        "del",
        "unreachable",
        "default",
        "table",
        str(TABLE),
        "metric",
        "32760",
        optional=True,
    )
    MARKER.unlink(missing_ok=True)
    # Root FORWARD policy still rejects the physical WAN while Mullvad mode is
    # configured, even when this unit/provider is stopped or unable to start.


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
