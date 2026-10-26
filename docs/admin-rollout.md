# Rolling memstore out to a Claude organization

Requires a Claude for Teams or Enterprise plan and the **Owner** or **Primary Owner** role.

## 1. Add the managed settings

Open [**Organization settings → Claude Code → Managed settings**](https://claude.ai/admin-settings/claude-code) and
merge these keys into the JSON already there (keep your existing keys):

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

- `extraKnownMarketplaces` and `enabledPlugins` install the plugin on every machine at its next session, and keep it
  enabled. This repository is public, so nobody needs GitHub access.
- `autoUpdate` keeps everyone on the latest plugin.
- `env` tells the plugin which server and org to use, so `/memstore:login` needs no arguments.

Claude Code fetches managed settings at startup and hourly.

## 2. Invite people to the org

On the memstore server, an org admin invites each person once:

```sh
memstore invite --org your-org --email person@company.com
```

## 3. What each person does

Restart Claude Code. The first session installs `memstore-client` in the background and asks them to run
`/memstore:login`, a one-time browser sign-in. Memory is on from the next session.

## Replacing an older memory connector

If people have another MCP connector to the same memory configured, block it so each session doesn't open twice:

```json
{
  "deniedMcpServers": [{ "serverName": "<the old connector's name>" }]
}
```

## Checking delivery

- `claude doctor` shows a `Managed settings (remote)` line.
- `/plugin` lists `memstore@memstore`.
- `/memstore:status` shows the server, who they're signed in as, and the last hook's result.
