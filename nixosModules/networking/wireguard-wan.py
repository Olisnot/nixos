"""Explicit, root-only, reboot-scoped WAN override for the client lockdown."""

import fcntl
import ipaddress
import json
import os
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

DIRECTORY = Path("/run/wg-client-wan")
STATE = DIRECTORY / "enabled.json"
CHAIN = "wg-client-output"
COMMENT = "wg-manual-wan"
TOOLS = {"-4": "iptables", "-6": "ip6tables"}


def run(*args, optional=False):
    result = subprocess.run(args, capture_output=True, text=True, check=False)
    if result.returncode and not optional:
        raise RuntimeError(
            "WAN override operation failed; inspect the client firewall/policy rules"
        )
    return result


def configuration(values):
    networks = [ipaddress.ip_network(value) for value in values]
    if len(networks) != 2 or {value.version for value in networks} != {4, 6}:
        raise RuntimeError("Expected one private IPv4 and IPv6 VPS address")
    if any(value.prefixlen != value.max_prefixlen for value in networks):
        raise RuntimeError("Private VPS exceptions must be single-host addresses")
    return {str(value.version): str(value) for value in networks}


def definitions(cfg, family):
    version = "4" if family == "-4" else "6"
    overlay = "100.64.0.0/10" if family == "-4" else "fd7a:115c:a1e0::/48"
    return [
        ["pref", "890", "to", cfg[version], "lookup", "51820"],
        ["pref", "891", "to", overlay, "lookup", "52"],
        ["pref", "892", "lookup", "main"],
    ]


def read_state():
    try:
        info = STATE.lstat()
    except FileNotFoundError:
        return None
    if (
        not stat.S_ISREG(info.st_mode)
        or info.st_uid != 0
        or stat.S_IMODE(info.st_mode) != 0o600
    ):
        raise RuntimeError(
            "Unsafe WAN override state; do not edit its runtime files manually"
        )
    value = json.loads(STATE.read_text())
    if value.get("version") != 1:
        raise RuntimeError("Unsupported WAN override state")
    return configuration(value["privateAddresses"])


def write_state(cfg):
    fd, temporary = tempfile.mkstemp(dir=DIRECTORY)
    try:
        with os.fdopen(fd, "w") as output:
            json.dump({"version": 1, "privateAddresses": list(cfg.values())}, output)
            output.flush()
            os.fsync(output.fileno())
        os.replace(temporary, STATE)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def bypass(tool, operation):
    return run(
        tool,
        "-w",
        operation,
        CHAIN,
        "-m",
        "comment",
        "--comment",
        COMMENT,
        "-j",
        "RETURN",
        optional=True,
    )


def remove_bypass():
    for tool in TOOLS.values():
        while bypass(tool, "-D").returncode == 0:
            pass


def clear_rules(cfg):
    for family in TOOLS:
        for rule in definitions(cfg, family):
            run("ip", family, "rule", "del", *rule, optional=True)


def activate(cfg):
    for tool in TOOLS.values():
        run(tool, "-w", "-S", CHAIN)
    previous = read_state()
    remove_bypass()  # Stay locked while updating routes.
    if previous is not None:
        clear_rules(previous)
        STATE.unlink()
    for family in TOOLS:
        rules = json.loads(run("ip", family, "-j", "rule", "show").stdout)
        if any(rule.get("priority") in [890, 891, 892] for rule in rules):
            raise RuntimeError(
                "WAN override priorities 890–892 are already in use; nothing overwritten"
            )
    applied = []
    try:
        write_state(cfg)
        for family in TOOLS:
            for rule in definitions(cfg, family):
                run("ip", family, "rule", "add", *rule)
                applied.append((family, rule))
        for tool in TOOLS.values():
            # Bypass only our own egress chain, never disable the host firewall.
            run(
                tool,
                "-w",
                "-I",
                CHAIN,
                "1",
                "-m",
                "comment",
                "--comment",
                COMMENT,
                "-j",
                "RETURN",
            )
    except Exception:
        STATE.unlink(missing_ok=True)
        remove_bypass()
        for family, rule in reversed(applied):
            run("ip", family, "rule", "del", *rule, optional=True)
        raise


def deactivate():
    previous = read_state()
    # Record the privacy-protecting intent before modifying kernel state.
    STATE.unlink(missing_ok=True)
    remove_bypass()
    if previous is not None:
        clear_rules(previous)


def status():
    enabled = read_state() is not None
    installed = [bypass(tool, "-C").returncode == 0 for tool in TOOLS.values()]
    if enabled and all(installed):
        print(
            "WAN override ENABLED: public traffic and DNS may use your ISP, not Mullvad. Resets on reboot."
        )
    elif not enabled and not any(installed):
        print(
            "VPN-only mode: WAN override disabled. Internet requires WireGuard and Mullvad."
        )
    else:
        raise RuntimeError(
            "WAN override state is inconsistent; run disable to relock or enable to reapply"
        )


def main():
    if len(sys.argv) != 3 or sys.argv[2] not in {
        "enable",
        "disable",
        "status",
        "restore",
    }:
        print("Usage: sudo wg-wan enable|disable|status", file=sys.stderr)
        return 2
    if os.geteuid() != 0:
        raise RuntimeError("Use sudo: WAN override changes are restricted to root")
    cfg = configuration(json.loads(sys.argv[1]))
    DIRECTORY.mkdir(mode=0o700, exist_ok=True)
    info = DIRECTORY.lstat()
    if (
        not stat.S_ISDIR(info.st_mode)
        or info.st_uid != 0
        or stat.S_IMODE(info.st_mode) != 0o700
    ):
        raise RuntimeError("Unsafe WAN override directory")
    fd = os.open(DIRECTORY / "lock", os.O_CREAT | os.O_RDWR | os.O_NOFOLLOW, 0o600)
    with os.fdopen(fd, "w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        action = sys.argv[2]
        if action == "enable":
            activate(cfg)
        elif action == "disable":
            deactivate()
        elif action == "restore":
            if read_state() is not None:
                activate(cfg)
            else:
                remove_bypass()
            return 0
        status()
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, RuntimeError, KeyError, TypeError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
