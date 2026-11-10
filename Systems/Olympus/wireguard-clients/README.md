# Public mobile peers only

`wireguard-enroll NAME [HOST_NUMBER]` creates one public JSON file here.
HOST_NUMBER defaults to 3 and must be unique, from 3 through 254.
Each file contains only `address` and `publicKey`. Never put a private key,
client configuration, or QR code in this directory.

Remove a device's JSON file and rebuild Olympus to revoke it. Then remove its
private local enrollment directory separately if no longer needed.
