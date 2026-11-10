"""Root-only namespace setup. Credentials and command errors never enter logs."""

import base64
import configparser
import ipaddress
import os
from pathlib import Path
import subprocess
import sys

NS = "qbt-mullvad"
WG = "mullvad0"
HOST_WG = "qbt-mv-wg"
HOST_VETH = "qbt-mv-host"
PEER_VETH = "qbt-mv-peer"
HOST_IP = "169.254.77.1"
PEER_IP = "169.254.77.2"
MARKER = Path("/run/qbt-mullvad/owned")
DNS_DIR = Path("/etc/netns") / NS


def run(*args, inside=False, data=None, optional=False):
    command = (["ip", "netns", "exec", NS] if inside else []) + list(args)
    result = subprocess.run(
        command,
        input=data,
        text=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    if result.returncode and not optional:
        # wg can quote a bad key in its error output: deliberately suppress it.
        raise RuntimeError(
            "A namespace setup command failed; details suppressed to protect credentials."
        )


def key(value):
    if len(base64.b64decode(value, validate=True)) != 32:
        raise ValueError("Invalid WireGuard key")
    return value


def profile():
    path = Path(os.environ["CREDENTIALS_DIRECTORY"]) / "wireguard"
    cfg = configparser.ConfigParser(interpolation=None, strict=True, delimiters=("=",))
    cfg.optionxform = str
    cfg.read_string(path.read_text())
    if set(cfg.sections()) != {"Interface", "Peer"} or cfg.defaults():
        raise ValueError("Expected one Interface and one Peer")
    interface, peer = cfg["Interface"], cfg["Peer"]
    # wg-quick hooks, DNS mutations, routing tables and ListenPort from the
    # downloaded file are NOT executed/applied. Our own policy replaces them.
    interface_keys = {
        "PrivateKey",
        "Address",
        "DNS",
        "MTU",
        "ListenPort",
        "FwMark",
        "Table",
        "SaveConfig",
        "PreUp",
        "PostUp",
        "PreDown",
        "PostDown",
    }
    peer_keys = {
        "PublicKey",
        "PresharedKey",
        "AllowedIPs",
        "Endpoint",
        "PersistentKeepalive",
    }
    if set(interface) - interface_keys or set(peer) - peer_keys:
        raise ValueError("Unsupported WireGuard option")
    addresses = [
        ipaddress.ip_interface(v.strip()) for v in interface["Address"].split(",")
    ]
    dns = [ipaddress.ip_address(v.strip()) for v in interface["DNS"].split(",")]
    if not addresses or not dns or not any(a.version == 4 for a in addresses):
        raise ValueError("Expected IPv4 tunnel address and explicit DNS")
    networks = {
        str(ipaddress.ip_network(v.strip())) for v in peer["AllowedIPs"].split(",")
    }
    if "0.0.0.0/0" not in networks:
        raise ValueError("Expected a full-tunnel IPv4 peer")
    if any(a.version == 6 for a in addresses) and "::/0" not in networks:
        raise ValueError("IPv6 tunnel address requires full-tunnel IPv6 peer")
    endpoint_host, endpoint_port = peer["Endpoint"].rsplit(":", 1)
    endpoint_ip = ipaddress.ip_address(endpoint_host.strip("[]"))
    if not 1 <= int(endpoint_port) <= 65535:
        raise ValueError("Invalid endpoint port")
    endpoint = (
        f"[{endpoint_ip}]:{int(endpoint_port)}"
        if endpoint_ip.version == 6
        else f"{endpoint_ip}:{int(endpoint_port)}"
    )
    mtu = int(interface.get("MTU", "1280"))
    keepalive = int(peer.get("PersistentKeepalive", "25"))
    if not 1280 <= mtu <= 9000 or not 0 <= keepalive <= 65535:
        raise ValueError("Invalid MTU or keepalive")
    allowed = "0.0.0.0/0" + (", ::/0" if "::/0" in networks else "")
    secret_config = (
        f"[Interface]\nPrivateKey = {key(interface['PrivateKey'])}\n"
        f"[Peer]\nPublicKey = {key(peer['PublicKey'])}\n"
        f"Endpoint = {endpoint}\nAllowedIPs = {allowed}\nPersistentKeepalive = {keepalive}\n"
    )
    if "PresharedKey" in peer:
        secret_config += f"PresharedKey = {key(peer['PresharedKey'])}\n"
    return addresses, dns, mtu, networks, secret_config


def down():
    if not MARKER.exists():
        return
    # Only exact resources created by this unit, never unrelated namespaces.
    run("ip", "netns", "del", NS, optional=True)
    run("ip", "link", "del", HOST_VETH, optional=True)
    run("ip", "link", "del", HOST_WG, optional=True)
    try:
        (DNS_DIR / "resolv.conf").unlink(missing_ok=True)
        (DNS_DIR / "nsswitch.conf").unlink(missing_ok=True)
        DNS_DIR.rmdir()
    except FileNotFoundError:
        pass
    MARKER.unlink(missing_ok=True)


def up():
    # Validate the complete private profile before changing network state.
    try:
        addresses, dns, mtu, networks, secret_config = profile()
    except Exception:
        raise RuntimeError(
            "Invalid Mullvad profile: expected one peer, literal-IP endpoint, full-tunnel AllowedIPs, addresses and DNS; private details suppressed."
        ) from None
    port = int(os.environ["QBT_WEBUI_PORT"])
    if not 1 <= port <= 65535:
        raise RuntimeError("Invalid Web UI port")
    if MARKER.exists() or Path(f"/run/netns/{NS}").exists() or DNS_DIR.exists():
        raise RuntimeError(
            "Namespace resources already exist; refusing to overwrite them."
        )
    for name in [HOST_VETH, PEER_VETH, HOST_WG]:
        if Path(f"/sys/class/net/{name}").exists():
            raise RuntimeError("A reserved interface name is already in use.")
    MARKER.touch(mode=0o600, exist_ok=False)
    run("ip", "netns", "add", NS)
    # WireGuard's UDP socket stays in its birth (host) namespace after moving
    # the interface. Only encrypted provider traffic uses host internet routing.
    run("ip", "link", "add", HOST_WG, "type", "wireguard")
    run("ip", "link", "set", HOST_WG, "netns", NS)
    run("ip", "-n", NS, "link", "set", HOST_WG, "name", WG)
    run("ip", "link", "add", HOST_VETH, "type", "veth", "peer", "name", PEER_VETH)
    run("ip", "link", "set", PEER_VETH, "netns", NS)
    run("ip", "addr", "add", f"{HOST_IP}/30", "dev", HOST_VETH)
    run("ip", "-n", NS, "addr", "add", f"{PEER_IP}/30", "dev", PEER_VETH)

    # Fail closed for both address families, including direct/control-link DNS.
    # There is no default route through the management veth, even if the VPN
    # device is removed. A firewall also restricts it to Web UI replies only.
    for tool in ["iptables", "ip6tables"]:
        for chain in ["INPUT", "OUTPUT", "FORWARD"]:
            run(tool, "-w", "-P", chain, "DROP", inside=True)
        run(tool, "-w", "-A", "INPUT", "-i", "lo", "-j", "ACCEPT", inside=True)
        run(tool, "-w", "-A", "OUTPUT", "-o", "lo", "-j", "ACCEPT", inside=True)
        run(tool, "-w", "-A", "OUTPUT", "-o", WG, "-j", "ACCEPT", inside=True)
        run(
            tool,
            "-w",
            "-A",
            "INPUT",
            "-i",
            WG,
            "-m",
            "conntrack",
            "--ctstate",
            "ESTABLISHED,RELATED",
            "-j",
            "ACCEPT",
            inside=True,
        )
    run(
        "iptables",
        "-w",
        "-A",
        "INPUT",
        "-i",
        PEER_VETH,
        "-s",
        HOST_IP,
        "-p",
        "tcp",
        "--dport",
        str(port),
        "-m",
        "conntrack",
        "--ctstate",
        "NEW,ESTABLISHED",
        "-j",
        "ACCEPT",
        inside=True,
    )
    run(
        "iptables",
        "-w",
        "-A",
        "OUTPUT",
        "-o",
        PEER_VETH,
        "-d",
        HOST_IP,
        "-p",
        "tcp",
        "--sport",
        str(port),
        "-m",
        "conntrack",
        "--ctstate",
        "ESTABLISHED",
        "-j",
        "ACCEPT",
        inside=True,
    )
    run("wg", "setconf", WG, "/dev/stdin", inside=True, data=secret_config)
    for address in addresses:
        run("ip", "-n", NS, "addr", "add", str(address), "dev", WG)
    run("ip", "-n", NS, "link", "set", WG, "mtu", str(mtu))
    run("ip", "-n", NS, "link", "set", "lo", "up")
    run("ip", "-n", NS, "link", "set", WG, "up")
    run("ip", "-n", NS, "link", "set", PEER_VETH, "up")
    run("ip", "link", "set", HOST_VETH, "up")
    run("ip", "-n", NS, "route", "add", "default", "dev", WG)
    if "::/0" in networks:
        run("ip", "-n", NS, "-6", "route", "add", "default", "dev", WG)
    DNS_DIR.mkdir(mode=0o755, parents=True, exist_ok=False)
    DNS_DIR.chmod(0o755)
    (DNS_DIR / "resolv.conf").write_text(
        "".join(f"nameserver {server}\n" for server in dns)
        + "options timeout:2 attempts:2\n"
    )
    (DNS_DIR / "resolv.conf").chmod(0o644)
    (DNS_DIR / "nsswitch.conf").write_text(
        "passwd: files\ngroup: files\nshadow: files\ngshadow: files\n"
        "hosts: files dns\nnetworks: files\nprotocols: files\nservices: files\n"
    )
    (DNS_DIR / "nsswitch.conf").chmod(0o644)


if __name__ == "__main__":
    try:
        if sys.argv[1:] == ["up"]:
            up()
        elif sys.argv[1:] == ["down"]:
            down()
        else:
            raise RuntimeError("Expected up or down")
    except Exception:
        # Never expose configparser/key-validation exceptions or wg stderr.
        print(
            "qBittorrent Mullvad namespace setup failed; configuration contents and command errors suppressed. Check the profile, permissions and reserved namespace/interface names.",
            file=sys.stderr,
        )
        sys.exit(1)
