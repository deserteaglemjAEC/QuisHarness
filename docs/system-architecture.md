# System Architecture

## Overview

QuisHarness is a file-based framework — it installs files into `~/.claude/` that Claude Code reads at runtime. There is no server, no daemon, no build process.

## Component Relationship

```mermaid
graph TD
    A[install.sh] -->|copies| B[~/.claude/]
    B --> C[CLAUDE.md]
    B --> D[rules/common/]
    B --> E[hooks/]
    B --> F[scripts/]
    B --> G[skills/]
    B --> H[output-styles/]
    B --> I[agent-memory/]
    B --> J[warnings/]

    K[Claude Code CLI] -->|reads| C
    K -->|reads| D
    K -->|executes| E
    K -->|activates| G
    K -->|applies| H

    F -->|scores| B

    style A fill:#f96,stroke:#333
    style K fill:#69f,stroke:#333
    style F fill:#9f6,stroke:#333
```

## Data Flow: Installation

```mermaid
sequenceDiagram
    participant U as User
    participant I as install.sh
    participant FS as ~/.claude/
    participant E as eval scripts

    U->>I: bash install.sh
    I->>FS: Check existing files
    I->>FS: Backup existing files (.bak)
    I->>FS: Copy templates/ → CLAUDE.md, keybindings.json
    I->>FS: Copy rules/common/ → rules/common/
    I->>FS: Copy scripts/ → scripts/
    I->>FS: Copy skills/examples/ → skills/examples/
    I->>FS: Copy output-styles/ → output-styles/
    I->>FS: Create dirs (agent-memory/, warnings/)
    I->>E: Run eval-composite.sh
    E->>FS: Score directory structure
    E-->>U: Display score
```

## Data Flow: Claude Code Session

```mermaid
sequenceDiagram
    participant U as User
    participant CC as Claude Code
    participant CM as CLAUDE.md
    participant R as rules/
    participant H as hooks/
    participant S as skills/

    U->>CC: Start session
    CC->>CM: Read global CLAUDE.md
    CC->>R: Load matching rules (glob-based)
    CC->>H: Execute SessionStart hooks
    H-->>CC: Inject context (stdout)

    U->>CC: Send prompt
    CC->>H: Execute UserPromptSubmit hooks
    H-->>CC: Inject additionalContext (JSON)
    CC->>S: Match prompt against skill descriptions
    S-->>CC: Load matching SKILL.md content
    CC-->>U: Response (with loaded context)
```

## Component Dependencies

```mermaid
graph LR
    subgraph "QuisHarness Components"
        T[templates/] -->|provides| CM[CLAUDE.md]
        T -->|provides| SE[settings-example.json]
        T -->|provides| KB[keybindings.json]

        R[rules/common/] -->|9 rule files| CC[Claude Code Context]
        H[hooks/] -->|event scripts| CC
        SK[skills/examples/] -->|patterns| CC
        OS[output-styles/] -->|formatting| CC
    end

    subgraph "Eval System"
        E1[eval-claude-directory.sh] -->|scores| DIR[Directory structure]
        E2[eval-skill-activation.sh] -->|scores| SKQ[Skill quality]
        E3[eval-composite.sh] -->|aggregates| E1
        E3 -->|aggregates| E2
    end

    subgraph "External"
        CC -->|runtime| LLM[Claude LLM]
        CC -->|plugins| PL[Community Plugins]
    end
```

## Key Design Decisions

### Why file-based (not a plugin)?

Plugins add context at runtime. QuisHarness configures the **foundation** that plugins sit on — directory structure, rules, eval criteria. A plugin can't create your `rules/common/` directory or teach you to evaluate other plugins.

### Why eval scripts (not CI)?

Eval scripts run locally against `~/.claude/`. CI doesn't have access to the user's home directory. The eval system is designed for **personal measurement**, not automated enforcement.

### Why templates instead of auto-config?

`settings.json` and hooks are too personal to auto-configure. Wrong hook config breaks Claude Code entirely. Templates show the pattern; users adapt to their workflow.

### Why Bash + Python (not Node)?

Zero dependency principle. Every macOS/Linux system has Bash and Python 3. Node would require `npm install` — an unnecessary barrier for a tool that configures a CLI.
