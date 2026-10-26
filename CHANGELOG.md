# Changelog

Releases are listed on the [releases page](https://github.com/A79-ai/memstore-plugins/releases), each with its
`memstore-client` binaries and checksums.

## Plugin 0.4.0

- The plugin installs `memstore-client` itself on its first session, in the background. No separate install step.
- `/memstore:login` signs in through the browser; with no arguments it uses `MEMSTORE_URL` and `MEMSTORE_ORG`, so an
  admin can set them once for everyone.
- A session started with nobody signed in says so once, instead of the memory going quiet.
- Remembered preferences are handed back newest first and dated; where two disagree, the newer stands.
- A repo's starter files (`CLAUDE.md`, `AGENTS.md`, rules) go into your own memory, never the team's.
- Published here, publicly, so installing needs no access to the private source repository.
