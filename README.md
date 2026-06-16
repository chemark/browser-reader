# browser-reader

> Agent Skill: Read Chrome browser tab content, bypassing login walls.

Lets Claude Code (and other AI agents) read the content of any page already open in your Chrome browser — including pages behind login walls like WeChat Official Accounts and X/Twitter Articles.

## Prerequisites

Enable JavaScript in Apple Events in Chrome (one-time setup):  
**View → Developer → Allow JavaScript from Apple Events**

## Installation

### Claude Code
```bash
claude install https://github.com/chemark/browser-reader
```

### Manual (for Codex or other agents)
```bash
git clone https://github.com/chemark/browser-reader ~/.claude/skills/browser-reader
```

## Usage

Tell your agent to read the current browser page:

> "Help me read this article"  
> "Read the content of this page"

The skill auto-detects the page type and uses the optimal selector:

| Page | Selector |
|------|----------|
| WeChat Official Account | `#js_content` |
| X/Twitter Articles | `[data-testid=articleContent]` |
| Everything else | `document.body.innerText` |

## Limitations

- macOS + Chrome only (v1)
- Text only — no image extraction
- X Threads not supported (virtual list)

## Contributing

PRs welcome for:
- Windows PowerShell support
- Firefox / Arc browser support
- Additional site-specific selectors
