<div align="center">

**[English](#english) · [中文](#中文) · [日本語](#日本語) · [한국어](#한국어)**

[![skills.sh](https://skills.sh/b/chemark/browser-reader)](https://skills.sh/chemark/browser-reader)

</div>

---

## English

> Agent Skill: Read Chrome browser tab content, bypassing login walls.

Lets Claude Code (and other AI agents) read the content of any page already open in your Chrome browser — including pages behind login walls like WeChat Official Accounts and X/Twitter Articles.

### Prerequisites

Enable JavaScript in Apple Events in Chrome (one-time setup):  
**View → Developer → Allow JavaScript from Apple Events**

### Installation

**skills CLI** (recommended)
```bash
npx skills add chemark/browser-reader
```

**Claude Code**
```bash
claude install https://github.com/chemark/browser-reader
```

**Manual (Codex or other agents)**
```bash
git clone https://github.com/chemark/browser-reader ~/.claude/skills/browser-reader
```

### Usage

Send a URL to your agent — it opens Chrome, waits for the page to load, and extracts the content automatically:

> "Read this for me: https://mp.weixin.qq.com/s/xxx"  
> "Export this article as HTML: https://mp.weixin.qq.com/s/xxx"

Or read the page you already have open:

> "Read the current page"

Auto-detects the page type and uses the optimal selector:

| Page | Selector |
|------|----------|
| WeChat Official Account | `#js_content` |
| X/Twitter Articles | `[data-testid=articleContent]` |
| Everything else | `article` → `main` → `body` |

### Output modes

| Mode | Command | Output |
|------|---------|--------|
| Default | `read_browser.sh [URL]` | Plain text + `[IMAGES]` URL list |
| HTML export | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdown export | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

In `--html` and `--md` modes, images are embedded **inline at their correct positions** in the article. Open the HTML file with `open /tmp/browser-reader-article.html` for a clean preview on macOS.

### Limitations

- macOS + Chrome only
- `--md` requires pandoc (`brew install pandoc`)
- X Threads not supported (virtual list)

### Contributing

PRs welcome for Windows PowerShell support, Firefox / Arc browser support, and additional site-specific selectors.

---

## 中文

> Agent Skill：读取 Chrome 浏览器当前标签页正文，绕过登录墙。

让 Claude Code 等 AI Agent 能读取 Chrome 中已打开页面的内容——包括微信公众号、X/Twitter 等需要登录才能访问的页面。

### 前置条件

在 Chrome 中开启「允许 Apple 事件中的 JavaScript」（仅需设置一次）：  
**菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript**

### 安装

**skills CLI**（推荐）
```bash
npx skills add chemark/browser-reader
```

**Claude Code**
```bash
claude install https://github.com/chemark/browser-reader
```

**手动安装（Codex 或其他 Agent）**
```bash
git clone https://github.com/chemark/browser-reader ~/.claude/skills/browser-reader
```

### 使用方式

把链接发给 Agent，自动在 Chrome 打开、等待加载、提取内容，无需手动操作浏览器：

> "帮我读这篇文章：https://mp.weixin.qq.com/s/xxx"  
> "把这篇文章导出成 HTML：https://mp.weixin.qq.com/s/xxx"

也可以读取当前已打开的页面：

> "读一下当前页面的内容"

自动识别页面类型，选择最优选择器：

| 页面类型 | 选择器 |
|----------|--------|
| 微信公众号 | `#js_content` |
| X/Twitter 长文章 | `[data-testid=articleContent]` |
| 其他所有页面 | `article` → `main` → `body` |

### 输出模式

| 模式 | 命令 | 输出 |
|------|------|------|
| 默认 | `read_browser.sh [URL]` | 纯文字 + `[IMAGES]` 图片 URL 列表 |
| HTML 导出 | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdown 导出 | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

`--html` 和 `--md` 模式下，图片**内嵌在文章正确位置**，不是附在末尾。HTML 文件可用 `open /tmp/browser-reader-article.html` 在 macOS 直接预览。

### 局限性

- 仅支持 macOS + Chrome
- `--md` 模式需要 pandoc（`brew install pandoc`）
- 不支持 X Thread（虚拟列表，无法完整提取）

### 贡献

欢迎 PR：Windows PowerShell 支持、Firefox / Arc 浏览器支持、更多网站专属选择器。

---

## 日本語

> Agent Skill：Chromeのブラウザタブのコンテンツを読み取り、ログイン壁を回避します。

Claude Codeなどの AI AgentがChromeで開いているページのコンテンツを読み取れるようにします。WeChat公式アカウントやX/Twitterなど、ログインが必要なページにも対応しています。

### 事前設定

ChromeでApple EventsのJavaScriptを許可（初回のみ）：  
**メニューバー → 表示 → 開発 → Apple EventsによるJavaScriptを許可**

### インストール

**skills CLI**（推奨）
```bash
npx skills add chemark/browser-reader
```

**Claude Code**
```bash
claude install https://github.com/chemark/browser-reader
```

**手動（CodexやほかのAgent）**
```bash
git clone https://github.com/chemark/browser-reader ~/.claude/skills/browser-reader
```

### 使い方

URLをAgentに送るだけ — ChoromeでURLを自動的に開き、ロードを待って本文を取得します：

> 「この記事を読んで：https://mp.weixin.qq.com/s/xxx」  
> 「この記事をHTMLで書き出して：https://mp.weixin.qq.com/s/xxx」

すでに開いているページを読ませることもできます：

> 「今開いているページの内容を読み取って」

ページの種類を自動検出し、最適なセレクターを使用します：

| ページ | セレクター |
|--------|-----------|
| WeChat公式アカウント | `#js_content` |
| X/Twitter 長文記事 | `[data-testid=articleContent]` |
| その他すべてのページ | `article` → `main` → `body` |

### 出力モード

| モード | コマンド | 出力 |
|--------|---------|------|
| デフォルト | `read_browser.sh [URL]` | テキスト＋`[IMAGES]` URL一覧 |
| HTMLエクスポート | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdownエクスポート | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

`--html`・`--md`モードでは、画像が**記事内の正しい位置に埋め込まれます**。HTMLファイルは`open /tmp/browser-reader-article.html`でmacOSプレビュー可能です。

### 制限事項

- macOS + Chromeのみ対応
- `--md`モードはpandocが必要（`brew install pandoc`）
- X Thread非対応（仮想リストのため完全な取得不可）

### コントリビューション

Windows PowerShellサポート、Firefox / Arcブラウザサポート、サイト固有セレクターの追加など、PRを歓迎します。

---

## 한국어

> Agent Skill: Chrome 브라우저 탭의 콘텐츠를 읽어 로그인 벽을 우회합니다.

Claude Code 등 AI Agent가 Chrome에서 이미 열려 있는 페이지의 콘텐츠를 읽을 수 있게 해줍니다. WeChat 공식 계정, X/Twitter 등 로그인이 필요한 페이지도 지원합니다.

### 사전 설정

Chrome에서 Apple Events의 JavaScript 허용 (최초 1회만):  
**메뉴 표시줄 → 보기 → 개발자 → Apple Events로 JavaScript 허용**

### 설치

**skills CLI** (권장)
```bash
npx skills add chemark/browser-reader
```

**Claude Code**
```bash
claude install https://github.com/chemark/browser-reader
```

**수동 설치 (Codex 또는 기타 Agent)**
```bash
git clone https://github.com/chemark/browser-reader ~/.claude/skills/browser-reader
```

### 사용 방법

Agent에게 URL을 전달하면 Chrome에서 자동으로 열고, 로딩을 기다린 후 본문을 추출합니다:

> "이 글 읽어줘: https://mp.weixin.qq.com/s/xxx"  
> "이 글 HTML로 내보내줘: https://mp.weixin.qq.com/s/xxx"

이미 열려 있는 페이지를 읽게 할 수도 있습니다:

> "지금 열린 페이지 내용 읽어줘"

페이지 유형을 자동으로 감지하고 최적의 선택자를 사용합니다:

| 페이지 | 선택자 |
|--------|--------|
| WeChat 공식 계정 | `#js_content` |
| X/Twitter 긴 글 | `[data-testid=articleContent]` |
| 그 외 모든 페이지 | `article` → `main` → `body` |

### 출력 모드

| 모드 | 명령어 | 출력 |
|------|--------|------|
| 기본 | `read_browser.sh [URL]` | 텍스트 + `[IMAGES]` URL 목록 |
| HTML 내보내기 | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdown 내보내기 | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

`--html`·`--md` 모드에서는 이미지가 **기사 내 올바른 위치에 인라인으로 삽입됩니다**. HTML 파일은 `open /tmp/browser-reader-article.html`로 macOS에서 바로 미리볼 수 있습니다.

### 제한 사항

- macOS + Chrome 전용
- `--md` 모드는 pandoc 필요 (`brew install pandoc`)
- X Thread 미지원 (가상 목록으로 완전한 추출 불가)

### 기여

Windows PowerShell 지원, Firefox / Arc 브라우저 지원, 사이트별 전용 선택자 추가 등 PR을 환영합니다.
