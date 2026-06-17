<div align="center">

**[English](#english) · [中文](#中文) · [日本語](#日本語) · [한국어](#한국어)**

[![skills.sh](https://skills.sh/b/chemark/browser-reader)](https://skills.sh/chemark/browser-reader)

</div>

---

## English

> Agent Skill: Read Chrome browser tab content, bypassing login walls.

Lets Claude Code (and other AI agents) read the content of any page already open in your Chrome browser — including pages behind login walls like WeChat Official Accounts and X/Twitter Articles.

### Prerequisites

- Enable JavaScript in Apple Events in Chrome (one-time setup):  
  **View → Developer → Allow JavaScript from Apple Events**
- `--md` mode requires pandoc: `brew install pandoc`

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

Auto-detects the page type:

| Page | What happens |
|------|-------------|
| WeChat Official Account | Extracts `#js_content` |
| X/Twitter thread (`/status/`) | Auto-scrolls top to bottom, collects tweets (see [X Thread modes](#x-thread-modes) below) |
| X/Twitter other pages | Extracts `[data-testid=articleContent]` or `body` |
| Everything else | Tries `article` → `main` → `body` |

### Output modes

| Mode | Command | Output |
|------|---------|--------|
| Default | `read_browser.sh [URL]` | Plain text + `[IMAGES]` URL list |
| HTML export | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdown export | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

In `--html` and `--md` modes, images are embedded **inline at their correct positions** in the article. Open the HTML file with `open /tmp/browser-reader-article.html` for a clean preview on macOS.

The `--md` output is clean, noise-free Markdown — no `:::` div artifacts. A pre-processor strips layout-only containers (div/span/section) before conversion, keeping only semantic elements.

### X Thread modes

When reading an X/Twitter thread (`x.com/*/status/*`), the script auto-scrolls from top to bottom and collects tweets. Three filter modes:

| Flag | Collects | Output |
|------|----------|--------|
| _(none)_ | Thread author only | `[1/N]` … `[N/N]` |
| `--user @handle` | Specific user only | `[1/N]` … `[N/N]` |
| `--all` | Everyone | `[1/N] @author` … |

### Limitations

- macOS + Chrome only

### Contributing

PRs welcome for Windows PowerShell support, Firefox / Arc browser support, and additional site-specific selectors.

---

## 中文

> Agent Skill：读取 Chrome 浏览器当前标签页正文，绕过登录墙。

让 Claude Code 等 AI Agent 能读取 Chrome 中已打开页面的内容——包括微信公众号、X/Twitter 等需要登录才能访问的页面。

### 前置条件

- 在 Chrome 中开启「允许 Apple 事件中的 JavaScript」（仅需设置一次）：  
  **菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript**
- `--md` 模式需要 pandoc：`brew install pandoc`

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

自动识别页面类型：

| 页面类型 | 行为 |
|----------|------|
| 微信公众号 | 提取 `#js_content` |
| X/Twitter 推文串（`/status/`） | 自动从顶到底滚动收集推文（见下方 [X 推文串模式](#x-推文串模式)） |
| X/Twitter 其他页面 | 提取 `[data-testid=articleContent]` 或 `body` |
| 其他所有页面 | 依次尝试 `article` → `main` → `body` |

### 输出模式

| 模式 | 命令 | 输出 |
|------|------|------|
| 默认 | `read_browser.sh [URL]` | 纯文字 + `[IMAGES]` 图片 URL 列表 |
| HTML 导出 | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdown 导出 | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

`--html` 和 `--md` 模式下，图片**内嵌在文章正确位置**，不是附在末尾。HTML 文件可用 `open /tmp/browser-reader-article.html` 在 macOS 直接预览。

`--md` 输出干净无噪声——内置预处理器会在转换前剥离 div/span 等布局容器，只保留语义标签，不会产生 `:::` 这类 pandoc 转换产物。

### X 推文串模式

读取 X/Twitter 推文串（`x.com/*/status/*`）时自动从顶到底滚动收集，支持三种过滤模式：

| 参数 | 收集范围 | 输出格式 |
|------|----------|----------|
| _（无）_ | 仅原作者 | `[1/N]` … `[N/N]` |
| `--user @handle` | 指定用户 | `[1/N]` … `[N/N]` |
| `--all` | 所有人 | `[1/N] @作者` … |

### 局限性

- 仅支持 macOS + Chrome

### 贡献

欢迎 PR：Windows PowerShell 支持、Firefox / Arc 浏览器支持、更多网站专属选择器。

---

## 日本語

> Agent Skill：Chromeのブラウザタブのコンテンツを読み取り、ログイン壁を回避します。

Claude Codeなどの AI AgentがChromeで開いているページのコンテンツを読み取れるようにします。WeChat公式アカウントやX/Twitterなど、ログインが必要なページにも対応しています。

### 事前設定

- ChromeでApple EventsのJavaScriptを許可（初回のみ）：  
  **メニューバー → 表示 → 開発 → Apple EventsによるJavaScriptを許可**
- `--md`モードはpandocが必要：`brew install pandoc`

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

ページの種類を自動検出します：

| ページ | 動作 |
|--------|------|
| WeChat公式アカウント | `#js_content` を抽出 |
| X/Twitterスレッド（`/status/`） | 上から下へ自動スクロールしてツイートを収集（下記 [X スレッドモード](#x-スレッドモード) 参照） |
| X/Twitterその他のページ | `[data-testid=articleContent]` または `body` を抽出 |
| その他すべてのページ | `article` → `main` → `body` の順で試行 |

### 出力モード

| モード | コマンド | 出力 |
|--------|---------|------|
| デフォルト | `read_browser.sh [URL]` | テキスト＋`[IMAGES]` URL一覧 |
| HTMLエクスポート | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdownエクスポート | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

`--html`・`--md`モードでは、画像が**記事内の正しい位置に埋め込まれます**。HTMLファイルは`open /tmp/browser-reader-article.html`でmacOSプレビュー可能です。

`--md`の出力はノイズのないクリーンなMarkdown — `:::`などのdivアーティファクトは生成されません。変換前にdiv/spanなどのレイアウト用コンテナを除去し、セマンティックな要素のみを保持する前処理器を内蔵しています。

### X スレッドモード

X/Twitterスレッド（`x.com/*/status/*`）を読む際、上から下へ自動スクロールして収集します。3つのフィルターモード：

| フラグ | 収集対象 | 出力形式 |
|--------|----------|----------|
| _（なし）_ | スレッド投稿者のみ | `[1/N]` … `[N/N]` |
| `--user @handle` | 指定ユーザーのみ | `[1/N]` … `[N/N]` |
| `--all` | 全員 | `[1/N] @author` … |

### 制限事項

- macOS + Chromeのみ対応

### コントリビューション

Windows PowerShellサポート、Firefox / Arcブラウザサポート、サイト固有セレクターの追加など、PRを歓迎します。

---

## 한국어

> Agent Skill: Chrome 브라우저 탭의 콘텐츠를 읽어 로그인 벽을 우회합니다.

Claude Code 등 AI Agent가 Chrome에서 이미 열려 있는 페이지의 콘텐츠를 읽을 수 있게 해줍니다. WeChat 공식 계정, X/Twitter 등 로그인이 필요한 페이지도 지원합니다.

### 사전 설정

- Chrome에서 Apple Events의 JavaScript 허용 (최초 1회만):  
  **메뉴 표시줄 → 보기 → 개발자 → Apple Events로 JavaScript 허용**
- `--md` 모드는 pandoc 필요: `brew install pandoc`

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

페이지 유형을 자동으로 감지합니다:

| 페이지 | 동작 |
|--------|------|
| WeChat 공식 계정 | `#js_content` 추출 |
| X/Twitter 스레드 (`/status/`) | 위에서 아래로 자동 스크롤하며 트윗 수집 (아래 [X 스레드 모드](#x-스레드-모드) 참고) |
| X/Twitter 기타 페이지 | `[data-testid=articleContent]` 또는 `body` 추출 |
| 그 외 모든 페이지 | `article` → `main` → `body` 순으로 시도 |

### 출력 모드

| 모드 | 명령어 | 출력 |
|------|--------|------|
| 기본 | `read_browser.sh [URL]` | 텍스트 + `[IMAGES]` URL 목록 |
| HTML 내보내기 | `read_browser.sh [URL] --html` | `/tmp/browser-reader-article.html` |
| Markdown 내보내기 | `read_browser.sh [URL] --md` | `/tmp/browser-reader-article.md` |

`--html`·`--md` 모드에서는 이미지가 **기사 내 올바른 위치에 인라인으로 삽입됩니다**. HTML 파일은 `open /tmp/browser-reader-article.html`로 macOS에서 바로 미리볼 수 있습니다.

`--md` 출력은 노이즈 없는 깔끔한 Markdown — `:::` 같은 div 아티팩트가 생성되지 않습니다. 변환 전에 div/span 등 레이아웃 전용 컨테이너를 제거하고 시맨틱 요소만 유지하는 전처리기가 내장되어 있습니다.

### X 스레드 모드

X/Twitter 스레드(`x.com/*/status/*`)를 읽을 때 위에서 아래로 자동 스크롤하며 수집합니다. 세 가지 필터 모드:

| 플래그 | 수집 대상 | 출력 형식 |
|--------|----------|----------|
| _(없음)_ | 스레드 작성자만 | `[1/N]` … `[N/N]` |
| `--user @handle` | 특정 사용자만 | `[1/N]` … `[N/N]` |
| `--all` | 모든 사람 | `[1/N] @author` … |

### 제한 사항

- macOS + Chrome 전용

### 기여

Windows PowerShell 지원, Firefox / Arc 브라우저 지원, 사이트별 전용 선택자 추가 등 PR을 환영합니다.
