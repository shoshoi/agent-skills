# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Cursor, Copilot, Antigravity, etc.) when working with code in this repository.

## Language / 言語

**Respond to the user in Japanese (日本語) by default.** All user-facing output (explanations, questions, summaries, status updates, confirmations) must be in Japanese, regardless of the language the user writes in. Skill content, code, identifiers, paths, and commit messages stay in their original language. If the user explicitly requests another language, follow that for the rest of the session.

ユーザー向けの出力は既定で日本語にします。スキル本文・コード・識別子・パス・コミットメッセージは元の言語のままで構いません。ユーザーが明示的に他言語を希望した場合はそれに従います。

## Repository Overview

A collection of skills for Claude.ai and Claude Code for senior software engineers. Skills are packaged instructions and scripts that extend Claude and your coding agents capabilities.

## OpenCode Integration

OpenCode uses a **skill-driven execution model** powered by the `skill` tool and this repository's `/skills` directory.

### Core Rules

- If a task matches a skill, invoke it
- Skills are located in `skills/<skill-name>/SKILL.md`
- Complete a matching skill's required steps before implementing, so the spec and plan exist when the code is written
- Follow the skill's workflow through its verification steps

### Intent → Skill Mapping

The agent should automatically map user intent to skills:

- Feature / new functionality → `spec-driven-development`, then `incremental-implementation`, `test-driven-development`
- Planning / breakdown → `planning-and-task-breakdown`
- Bug / failure / unexpected behavior → `debugging-and-error-recovery`
- Code review → `code-review-and-quality`
- Refactoring / simplification → `code-simplification`
- API or interface design → `api-and-interface-design`
- UI work → `frontend-ui-engineering`

### Lifecycle Mapping (Implicit Commands)

This OpenCode integration does not use slash commands like `/spec` or `/plan`.

Instead, the agent must internally follow this lifecycle:

- DEFINE → `spec-driven-development`
- PLAN → `planning-and-task-breakdown`
- BUILD → `incremental-implementation` + `test-driven-development`
- VERIFY → `debugging-and-error-recovery`
- REVIEW → `code-review-and-quality`
- SHIP → `shipping-and-launch`

### Execution Model

For every request:

1. Determine whether a skill applies
2. Invoke the appropriate skill using the `skill` tool
3. Follow the skill workflow strictly
4. Only proceed to implementation after required steps (spec, plan, etc.) are complete

This ensures OpenCode behaves similarly to Claude Code with full workflow enforcement.

## Orchestration: Personas, Skills, and Commands

This repo has three composable layers. They have different jobs and should not be confused:

- **Skills** (`skills/<name>/SKILL.md`) — workflows with steps and exit criteria. The *how*. Mandatory hops when an intent matches.
- **Personas** (`agents/<role>.md`) — roles with a perspective and an output format. The *who*.
- **Slash commands** (`.claude/commands/*.md`) — user-facing entry points. The *when*. The orchestration layer.

Composition rule: **the user (or a slash command) is the orchestrator. Personas do not invoke other personas.** A persona may invoke skills.

The only multi-persona orchestration pattern this repo endorses is **parallel fan-out with a merge step** — used by `/ship` to run `code-reviewer`, `security-auditor`, and `test-engineer` concurrently and synthesize their reports. Do not build a "router" persona that decides which other persona to call; that's the job of slash commands and intent mapping.

See [agents/README.md](agents/README.md) for the decision matrix and [references/orchestration-patterns.md](references/orchestration-patterns.md) for the full pattern catalog.

**Claude Code interop:** the personas in `agents/` work as Claude Code subagents (auto-discovered from this plugin's `agents/` directory) and as Agent Teams teammates (referenced by name when spawning). Two platform constraints align with our rules: subagents cannot spawn other subagents, and teams cannot nest. Plugin agents silently ignore the `hooks`, `mcpServers`, and `permissionMode` frontmatter fields.

## Creating a New Skill

### Directory Structure

```
skills/
  {skill-name}/           # kebab-case directory name
    SKILL.md              # Required: skill definition
    scripts/              # Optional: only when the skill ships runnable helpers
      {script-name}.sh    # Bash scripts (preferred)
```

### Naming Conventions

- **Skill directory**: `kebab-case` (e.g. `web-quality`)
- **SKILL.md**: Always uppercase, always this exact filename
- **Scripts**: `kebab-case.sh` (e.g., `deploy.sh`, `fetch-logs.sh`)

### SKILL.md Format

```markdown
---
name: {skill-name}
description: {One sentence describing what the skill does, followed by one or more "Use when" trigger conditions. Include trigger phrases like "Deploy my app" or "Check logs" when helpful.}
---

# {Skill Title}

## Overview

{Brief overview of what the skill does and why it matters.}

## When to Use

{Trigger conditions, and when not to use the skill.}

## Core Process

{The skill's workflow. Equivalent headings like `How It Works` or `Workflow` are fine.}

## Common Rationalizations

{Excuses for skipping the process, and why each is wrong.}

## Red Flags

{Signs the skill is being misapplied.}

## Verification

{How to confirm the work is done. `docs/skill-anatomy.md` describes each section, and `node scripts/validate-skills.js` checks them.}
```

### Best Practices for Context Efficiency

Skills are loaded on-demand — only the skill name and description are loaded at startup. The full `SKILL.md` loads into context only when the agent decides the skill is relevant. To minimize context usage:

- **Keep SKILL.md under 500 lines** — put detailed reference material in separate files
- **Write specific descriptions** — helps the agent know exactly when to activate the skill
- **Use progressive disclosure** — reference supporting files that get read only when needed
- **Prefer scripts over inline code** — script execution doesn't consume context (only output does)
- **File references work one level deep** — link directly from SKILL.md to supporting files

### Script Requirements

- Use `#!/bin/bash` shebang
- Use `set -e` for fail-fast behavior
- Write status messages to stderr: `echo "Message" >&2`
- Write machine-readable output (JSON) to stdout
- Include a cleanup trap for temp files
- Reference the script path as `/mnt/skills/user/{skill-name}/scripts/{script}.sh`

### End-User Installation

Document these two installation methods for users:

**Claude Code:**
```bash
cp -r skills/{skill-name} ~/.claude/skills/
```

**claude.ai:**
Add the skill to project knowledge or paste SKILL.md contents into the conversation.

If the skill requires network access, instruct users to add required domains at `claude.ai/settings/capabilities`.
