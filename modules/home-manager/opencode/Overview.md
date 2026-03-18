## Agents

A sub-session with its own instructions, context, and specified tool permissions. Can be explicitly invoked by the user using `@agent`, or called on-demand by agents (if `mode: subagent`) using the `task` tool.

```base
filters:
  and:
    - file.inFolder("agents")
views:
  - type: table
    name: Table
    order:
      - file.name
      - mode
      - color
      - description
      - disable
      - hidden
      - model
      - temperature
      - steps
    sort:
      - property: mode
        direction: ASC
    columnSize:
      note.description: 800
      note.temperature: 90
      note.steps: 75
      note.disable: 80
      note.hidden: 80

```

## Tools

Deterministic code (including MCP calls and custom tools, which are the following TypeScript files) which may be called on-demand by agents. Each tool and its description contributes to context. Availability is defined by each agent's permissions.

```base
filters:
  and:
    - file.inFolder("tools")
    - file.ext == "ts"
views:
  - type: table
    name: Table
    order:
      - file.name

```

## Skills

Reusable prompts which may be loaded on-demand by agents. Skill information is only loaded in on-demand using the `skill` tool. Availability is defined by each agent's `skill` tool permissions.

## Commands

Reusable prompts which are explicitly invoked by the user using `/command`. Always available from any agent.

## Workflow ideas

### /understand

summarize user-provided corrections during this session and write them to AGENTS.md

### /bugfix

1. if a url was passed, fetch it and read the bug report
2. understand the bug by writing a test that reproduces the bug
	1. validate the test by ensuring it reproduces the bug when executed against the current code
3. plan a fix
4. implement the fix
	1. validate the fix by running the test against the fixed code

### /commit

summarize changes made in this session, then dispatch to a subagent with permission to run `git commit`

OR

`git commit` as an ask tool