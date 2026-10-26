# What the plugin sends

Everything goes to one place: the memstore server you signed in to (`MEMSTORE_URL`). Nothing is sent to A79 or
anyone else unless A79 runs that server for your team. Secret-looking words are redacted first.

| When | What | Who can read it |
|---|---|---|
| A session starts | The repo's name, to recall what the memory holds about it | — |
| A session starts | The repo's `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` and agent rules, and your Claude Code memory files for it (only when they changed) | You alone |
| The first prompt | The prompt, to find advice and facts for it | — |
| As you work, and at the end | The session's trace: prompts, shortened answers, tool calls with shortened arguments and the first 200 characters of each result | You alone |
| Before compaction, every five prompts, at the end | A condensed note of the session: what was asked, what Claude said, files changed | You alone |
| `/memstore:remember`, or a preference you state | The note | You alone, and your team once three people have said the same |
| `/memstore:outcome` | Your rating and its reason | You alone |

Turn parts off with `MEMSTORE_CAPTURE=off` (no traces or notes) and `MEMSTORE_STARTER=off` (no instruction files).
`/memstore:forget` forgets a note you remembered. Your server's admins decide how long the rest is kept.
