# Changelog

## v1.4.1 (2026-06-18)

### Added
- X/Twitter thread support: auto-detects `/status/` URLs and injects an async JS collector that scrolls from top to bottom. Output is numbered `[1/N]`…`[N/N]`. Polls up to 90 seconds with progress updates every 10 seconds.
- Thread filter flags: default reads thread author only; `--user @handle` reads a specific user; `--all` reads everyone and prefixes each tweet with `@author`.

## v1.3.1 (2026-06-16)

### Fixed
- Markdown output no longer contains `:::` div artifacts. Added `clean_html.py` pre-processor that strips layout-only containers (div/span/section) before pandoc conversion, keeping only semantic elements.

## v1.3.0 (2026-06-16)

### Added
- `--html` export mode: outputs a clean, self-contained HTML file with images inline at correct positions. Suitable for macOS Quick Look / Safari preview (`open /tmp/browser-reader-article.html`).
- `--md` export mode: converts article to Markdown via pandoc, images rendered as `![](url)` syntax. Requires pandoc (`brew install pandoc`).
- URL and format flag can be combined in any order.
- Generic pages: smart container detection (`article` → `main` → `[role=main]` → `body`), removes nav/header/footer noise.

## v1.2.0 (2026-06-16)

### Added
- Image extraction: page images are now extracted and listed under `[IMAGES]` section alongside article text.
- Agent can view each image URL with vision capabilities to understand image content.
- WeChat articles: supports lazy-loaded images via `data-src` attribute.

## v1.1.0 (2026-06-16)

### Added
- URL argument support: agent can now open a URL in Chrome automatically before reading — no manual browser step needed.
- Polls `document.readyState` until page is fully loaded (max 30s).
- URL and format flags can be passed in any order.

### Changed
- Backward compatible: omitting the URL still reads the current active tab.

## v1.0.0 (2026-06-16)

### Initial release
- Read Chrome current tab content via AppleScript + JavaScript injection.
- Auto-detects page type and uses optimal selector: WeChat (`#js_content`), X/Twitter Articles (`[data-testid=articleContent]`), everything else (`document.body.innerText`).
- macOS + Chrome only.
- Outputs plain text to stdout.
