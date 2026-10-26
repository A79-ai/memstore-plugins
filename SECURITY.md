# Security policy

## Reporting a vulnerability

Please don't open a public issue. Report it privately through
[GitHub's private vulnerability reporting](https://github.com/A79-ai/memstore-plugins/security/advisories/new).

Include what you found, how to reproduce it, and what it affects (the plugin, `memstore-client`, or `install.sh`).
We acknowledge reports within three business days and keep you posted until a fix ships.

## Supported versions

The latest release. The plugin auto-updates from this repository, and `install.sh` installs the latest
`memstore-client` unless `MEMSTORE_VERSION` pins one.

## How the client handles your data

- The sign-in is kept in `~/.memstore` with owner-only permissions and sent only to the server it was made for.
- Words that look like secrets are redacted before anything is sent.
- `install.sh` and the plugin verify each download against its published SHA-256 checksum before installing it.
- macOS builds aren't signed or notarized yet; `install.sh` clears the quarantine flag on the binary it installs.
