---
description: Sign in to the team memory (memstore) on this machine, through the browser
argument-hint: "[<server>] [--org <org>]"
allowed-tools: Bash("${CLAUDE_PLUGIN_ROOT}/bin/memstore-client" login:*)
disable-model-invocation: true
---
!`"${CLAUDE_PLUGIN_ROOT}/bin/memstore-client" login $ARGUMENTS 2>&1 || true`

Report memstore's lines above in a line or two. If it signed in, say who as and in which org, and that the memory is on from the next session. If it asked which server, say to run `/memstore:login <server> --org <org>` with the team's server, or ask an admin to set `MEMSTORE_URL` and `MEMSTORE_ORG`.
