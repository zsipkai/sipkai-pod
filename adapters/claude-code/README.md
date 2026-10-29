# Claude Code

How Claude Code supplies what `adapters/README.md` lists.

## Loading the pages

- **The plugin.** `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` sit at the pod's root, because Claude Code reads them there. The manifest declares the step pages (`./sdlc/skills/`) and the nine member pages explicitly, so the team page, the charter and the lenses are not loaded as agents.
- **In a project**, `.claude/settings.json` declares the included folder as a local marketplace and enables the plugin:

```json
{
  "extraKnownMarketplaces": { "sipkai-pod": { "source": { "source": "directory", "path": "./sipkai-pod" } } },
  "enabledPlugins": { "sipkai-pod@sipkai-pod": true }
}
```

- **The main file.** The project's `CLAUDE.md` imports its `AGENTS.md`; the project's `AGENTS.md` points at `sipkai-pod/CLAUDE.md` and the charter.
- **Commands** are namespaced: `/sipkai-pod:plan-task`; the short form `/plan-task` works while no other command uses the name.

## Fresh sessions and subagents

The desktop app and the command line can start a new session for a step; where Sipk.ai cannot start one, it runs the step in a fresh subagent with only the record. Member pages are agent definitions; Sipk.ai passes the tier for each brief (`model: inherit` in every page, so the page never fixes a vendor's model). A project's own lenses live in its `.claude/agents/`.

## Deny rules

`settings.json` in this folder is a starting set of deny rules for a project. `adopt.sh` copies it to the project's `.claude/settings.json` when the project has none; the project adds its own private folders and cloud commands. Settings load only for a session started in the project root, which is why every step starts with `stage-start.sh` (R-8.1). Each rule is tested once and the denial recorded.

## Usage report

Claude Code reports the tokens of each subagent it runs; that number makes a ledger line `measured`. A number read from the session's context counter is an `estimate`.
