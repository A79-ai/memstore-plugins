<div align="center">

# memstore

**Team memory for coding agents.** Every session starts with what your team already knows, and teaches the memory something when it ends.

[![Release](https://img.shields.io/github/v/release/A79-ai/memstore-plugins?label=release&color=2563eb)](https://github.com/A79-ai/memstore-plugins/releases/latest)
[![Validate](https://github.com/A79-ai/memstore-plugins/actions/workflows/validate.yml/badge.svg)](https://github.com/A79-ai/memstore-plugins/actions/workflows/validate.yml)
![Platforms](https://img.shields.io/badge/platforms-macOS%20(Apple%20Silicon)%20%7C%20Linux%20(arm64%2C%20x86__64)-555)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-d97757)](#claude-code)
[![Cursor](https://img.shields.io/badge/Cursor-plugin-111)](#cursor)
[![Codex](https://img.shields.io/badge/Codex-plugin-10a37f)](#codex)

</div>

This repository publishes the **memstore plugin** for Claude Code, Cursor and Codex, and **`memstore-client`**,
the small binary the plugin runs: the sign-in, the session hooks and the MCP bridge. You need a memstore server to
connect to (your team's), and an invite to its org.

## Quick start

### Claude Code

```text
/plugin marketplace add A79-ai/memstore-plugins
/plugin install memstore@memstore
/memstore:login https://your-memstore-server --org your-org
```

That's it. You don't install anything else: on its first session the plugin downloads `memstore-client` in the
background (about 6 MB, checksum-verified, to `~/.local/bin`), and memory is on from the next session.
`/memstore:login` signs you in through your browser once, and the sign-in renews itself.

Check it any time with `/memstore:status`.

> **Admins:** roll it out to everyone in your Claude organization with no steps for your team at all. See
> [Rolling out to a team](#rolling-out-to-a-team).

### Cursor

Install `memstore-client` and sign in, then add this repository in Cursor's plugin settings
(`.cursor-plugin/marketplace.json` lists the plugin):

```sh
curl -fsSL https://raw.githubusercontent.com/A79-ai/memstore-plugins/main/install.sh | sh
memstore-client join https://your-memstore-server --org your-org
```

### Codex

```sh
codex plugin marketplace add A79-ai/memstore-plugins
codex plugin add memstore@memstore
codex mcp login memstore
```

## What you get

| | |
|---|---|
| **Recall at the start** | Each session starts with what the memory holds about the repo you're in. |
| **Advice at the first prompt** | The skill your team's memory has for this kind of task, learned from past sessions, added before Claude starts. |
| **Your preferences, kept** | Corrections and preferences you state are remembered for you and handed back in later sessions, newest first and dated. |
| **Sessions that teach** | Each session ends with its trace, so the memory learns which advice helped. Rate one with `/memstore:outcome good\|bad [why]`. |
| **Search with sources** | `/memstore:search`, or let Claude call `search_memory`: every claim cites the moment it comes from. |
| **Never in your way** | Hooks never hold up a turn: writes happen in the background, and a slow memory adds nothing rather than making you wait. |

### Commands (Claude Code)

| Command | What it does |
|---|---|
| `/memstore:login [<server>] [--org <org>]` | Sign in through the browser. |
| `/memstore:status` | Where the memory is, who you are there, and how the last hook went. |
| `/memstore:search <words>` | Search the team memory. |
| `/memstore:remember <text>` | Remember a note (yours alone until three teammates say the same). |
| `/memstore:forget <id or words>` | Forget something you remembered. |
| `/memstore:brief <name>` | Where a customer, project or deal stands. |
| `/memstore:outcome good\|bad [why]` | Rate this session so the memory learns from it. |

## Rolling out to a team

A Claude for Teams or Enterprise **Owner** can install the plugin for everyone from
[**Organization settings → Claude Code → Managed settings**](https://claude.ai/admin-settings/claude-code). Merge
this into what's there:

```json
{
  "extraKnownMarketplaces": {
    "memstore": {
      "source": { "source": "github", "repo": "A79-ai/memstore-plugins" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": { "memstore@memstore": true },
  "env": {
    "MEMSTORE_URL": "https://your-memstore-server",
    "MEMSTORE_ORG": "your-org"
  }
}
```

Each person then restarts Claude Code, and the plugin asks them to run `/memstore:login` (no arguments needed). See
[docs/admin-rollout.md](docs/admin-rollout.md) for checking delivery and replacing an older memory connector.

## Install the client by hand

For a terminal, CI or another agent:

```sh
curl -fsSL https://raw.githubusercontent.com/A79-ai/memstore-plugins/main/install.sh | sh
```

| Variable | Default | |
|---|---|---|
| `MEMSTORE_VERSION` | latest release | A tag such as `v0.1.0-rc.6`. |
| `MEMSTORE_INSTALL_DIR` | `~/.local/bin` | Where it goes, and where the plugin looks. |

Then `memstore-client join <server> --org <org>` and `memstore-client doctor`.

## Configuration

| Variable | Default | What it does |
|---|---|---|
| `MEMSTORE_URL` | the sign-in's server | The memstore server, and where `/memstore:login` signs in. |
| `MEMSTORE_ORG` | the sign-in's org | The org on that server. |
| `MEMSTORE_SCOPE` | the team's | `mine` keeps sessions and notes in your own memory only. |
| `MEMSTORE_CAPTURE` | on | `off` stops sessions being remembered. Advice and recall still work. |
| `MEMSTORE_RECALL` | first prompt | `every` recalls on every prompt. |
| `MEMSTORE_STARTER` | on | `off` stops importing the repo's `CLAUDE.md`, `AGENTS.md` and rules into your own memory. |

## Privacy and security

- **What leaves your machine** goes only to the memstore server you signed in to: session traces, prompts, notes
  you remember, and the repo's agent instruction files. See [PRIVACY.md](PRIVACY.md).
- **Secrets are redacted** before anything is sent: known key prefixes, JWTs, long random strings, and values of
  `password=`, `token:` and the like.
- **You only see what you may read.** Your sessions and notes are yours alone. A note reaches teammates only once at
  least three people have said the same.
- **No tokens in config files.** The sign-in is kept in `~/.memstore` (owner-only) and renewed by the client.
- Report vulnerabilities privately: [SECURITY.md](SECURITY.md).

## Troubleshooting

| Symptom | Fix |
|---|---|
| Claude says memstore is off, nobody is signed in | `/memstore:login` |
| `/memstore:status` says the sign-in expired or was refused | `/memstore:login` again |
| The client didn't install | See `$TMPDIR/memstore-client-install.log`, or install by hand (above) |
| Intel Mac | Not supported yet: the client builds for Apple Silicon and Linux |
| Every session's tools appear twice | Another memstore MCP connector is configured: remove or disable it in `/mcp` |

## Uninstall

```text
/plugin uninstall memstore@memstore
```

```sh
rm ~/.local/bin/memstore-client && rm -rf ~/.memstore
```

## About this repository

memstore is developed in a private repository. This one is published from it on every release: the plugin files,
the marketplaces, `install.sh`, and the `memstore-client` binaries. Issues are welcome here; pull requests can't be
merged directly, because the next release overwrites the plugin files, but we'll carry good changes upstream.

See [CHANGELOG.md](CHANGELOG.md) for releases. Licensed under the [MIT License](LICENSE).
