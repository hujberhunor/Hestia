# 2026-09-09 — ste install

## Task
Install the asd-ste100 writing skill into Kiro CLI as a workspace agent, and link all skills into the Kiro skills directory.

## Decisions
- **Option 2a, not the Claude installer** — the skill's install.py writes to ~/.claude and arms Claude Code hooks. Kiro CLI ignores that path, so the installer does nothing here.
- **A plain-text card, not the four ste-* hook scripts** — the scripts read the Claude event format. In Kiro two hooks never fire, and two print raw JSON into context. An agentSpawn cat of card.txt gives the rule with no broken part.
- **Keep SYSTEM_PROMPT.md in resources, drop PLAN.md** — a file:// resource loads every session. The rules are small and always relevant. The plan is large and task-specific, so it loads on demand.
- **One directory symlink, not per-skill links** — .kiro/skills points at .agent/skills, so every skill shows up with no extra step.
- **Keep default resource inheritance on** — the user chose to let AGENTS.md and README.md load by default, so chat.disableInheritingDefaultResources stays false.
- **Root AGENTS.md points to the real files, no copy** — Kiro loads AGENTS.md at repo root by default. It references SYSTEM_PROMPT.md, PLAN.md, and sessions/ instead of duplicating them, so nothing drifts.
- **Fixed skill-loader Claude-to-Kiro drift** — the skill described asd-ste100 as Claude Code hooks and skills at root skills/. Both were wrong for Kiro. Corrected to the agentSpawn card and the .agent/skills/ path.

## State
- `.kiro/agents/ste.json` created. Loads SYSTEM_PROMPT.md and the skill, runs card.txt at agentSpawn. JSON valid, kiro-cli validate passed.
- `.agent/skills/asd-ste100/card.txt` created. The agentSpawn hook prints it.
- `.kiro/skills` -> `../.agent/skills` symlink created. All four skills resolve.
- All four skills have a SKILL.md: asd-ste100, session-memory, context-management, skill-loader.
- `AGENTS.md` created at repo root, points to SYSTEM_PROMPT.md, PLAN.md, sessions/.
- Doc fixes applied: skill-loader/SKILL.md (Kiro card note, .agent/skills/ path, skill:// discovery note, chat-reply lookup row) and PLAN.md (removed the resolved skill-loading open decision). context-management needed no path fix.
- The empty .agent/AGENT.md is dead. Kiro reads root AGENTS.md, not that file. Not deleted.
- Not yet done: switch to the ste agent and restart to load the card.

## Thesis note
The skill enforcement moved from Claude Code hooks to a Kiro agentSpawn card. The gate layer was dropped because the hook event schema differs between the two agent engines. This is an agent-portability limit worth recording.
