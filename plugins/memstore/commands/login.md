---
description: Sign in to the team memory (memstore) on this machine, through the browser
argument-hint: "[<server>] [--org <org>]"
allowed-tools: Bash("${CLAUDE_PLUGIN_ROOT}/bin/memstore-client" login:*)
disable-model-invocation: true
---
!`"${CLAUDE_PLUGIN_ROOT}/bin/memstore-client" login $ARGUMENTS 2>&1 || true`

Report memstore's lines above in a line or two. If it signed in, say who as and in which org, and that the memory is on from the next session. If it says the person asked to join the org, say that an admin of the org has been emailed to approve them, and to run `/memstore:login` again once approved. With no server or org named, it joins the ampup org; another team's is `/memstore:login <server> --org <org>`, or an admin sets `MEMSTORE_URL` and `MEMSTORE_ORG` for everyone.
