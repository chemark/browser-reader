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

Tell your agent to read the current browser page:

> "Help me read this article"  
> "Read the content of this page"

Auto-detects the page type and uses the optimal selector:

| Page | Selector |
|------|----------|
| WeChat Official Account | `#js_content` |
| X/Twitter Articles | `[data-testid=articleContent]` |
| Everything else | `document.body.innerText` |

### Limitations

- macOS + Chrome only (v1)
- **Images are not extracted** — text only (image support coming in v2)
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

直接告诉你的 Agent：

> "帮我读一下这篇文章"  
> "读一下当前页面的内容"

自动识别页面类型，选择最优选择器：

| 页面类型 | 选择器 |
|----------|--------|
| 微信公众号 | `#js_content` |
| X/Twitter 长文章 | `[data-testid=articleContent]` |
| 其他所有页面 | `document.body.innerText` |

### 局限性

- 仅支持 macOS + Chrome（v1）
- **暂不支持图片提取**，仅提取文字（图片支持将在 v2 中加入）
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

Agentに伝えるだけ：

> 「この記事を読んで」  
> 「今開いているページの内容を読み取って」

ページの種類を自動検出し、最適なセレクターを使用します：

| ページ | セレクター |
|--------|-----------|
| WeChat公式アカウント | `#js_content` |
| X/Twitter 長文記事 | `[data-testid=articleContent]` |
| その他すべてのページ | `document.body.innerText` |

### 制限事項

- macOS + Chromeのみ対応（v1）
- **画像の取得は未対応** — テキストのみ（画像対応はv2で追加予定）
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

Agent에게 말하기만 하면 됩니다:

> "이 글 읽어줘"  
> "지금 열린 페이지 내용 읽어줘"

페이지 유형을 자동으로 감지하고 최적의 선택자를 사용합니다:

| 페이지 | 선택자 |
|--------|--------|
| WeChat 공식 계정 | `#js_content` |
| X/Twitter 긴 글 | `[data-testid=articleContent]` |
| 그 외 모든 페이지 | `document.body.innerText` |

### 제한 사항

- macOS + Chrome 전용 (v1)
- **이미지 추출 미지원** — 텍스트만 추출 (이미지 지원은 v2에서 추가 예정)
- X Thread 미지원 (가상 목록으로 완전한 추출 불가)

### 기여

Windows PowerShell 지원, Firefox / Arc 브라우저 지원, 사이트별 전용 선택자 추가 등 PR을 환영합니다.
