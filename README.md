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

Just send a URL to your agent:

> "Read this for me: https://mp.weixin.qq.com/s/xxx"

The agent opens the URL in Chrome automatically, waits for it to load, then extracts the content — no manual browser step needed.

You can also ask it to read the page you already have open:

> "Read the content of this page"

Auto-detects the page type and uses the optimal selector:

| Page | Selector |
|------|----------|
| WeChat Official Account | `#js_content` |
| X/Twitter Articles | `[data-testid=articleContent]` |
| Everything else | `document.body.innerText` |

### Output format

```
[article text]

---
[IMAGES]
https://...image1
https://...image2
```

Image URLs are listed under `[IMAGES]`. The agent views each one using vision capabilities to understand the image content.

### Limitations

- macOS + Chrome only
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

直接把链接发给 Agent：

> "帮我读这篇文章：https://mp.weixin.qq.com/s/xxx"

Agent 会自动在 Chrome 打开链接、等待加载、提取正文，无需手动打开浏览器。

也可以让它读你已经打开的页面：

> "读一下当前页面的内容"

自动识别页面类型，选择最优选择器：

| 页面类型 | 选择器 |
|----------|--------|
| 微信公众号 | `#js_content` |
| X/Twitter 长文章 | `[data-testid=articleContent]` |
| 其他所有页面 | `document.body.innerText` |

### 输出格式

```
[文章正文]

---
[IMAGES]
https://...图片1
https://...图片2
```

图片 URL 列在 `[IMAGES]` 区块，Agent 会逐一用视觉能力查看图片内容。

### 局限性

- 仅支持 macOS + Chrome
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

URLをAgentに送るだけ：

> 「この記事を読んで：https://mp.weixin.qq.com/s/xxx」

AgentがChromeで自動的にURLを開き、ロードを待ってから本文を取得します。手動でブラウザを操作する必要はありません。

すでに開いているページを読ませることもできます：

> 「今開いているページの内容を読み取って」

ページの種類を自動検出し、最適なセレクターを使用します：

| ページ | セレクター |
|--------|-----------|
| WeChat公式アカウント | `#js_content` |
| X/Twitter 長文記事 | `[data-testid=articleContent]` |
| その他すべてのページ | `document.body.innerText` |

### 出力フォーマット

```
[記事本文]

---
[IMAGES]
https://...画像1
https://...画像2
```

画像URLは`[IMAGES]`セクションに列挙されます。Agentがビジョン機能で各画像を確認します。

### 制限事項

- macOS + Chromeのみ対応
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

Agent에게 URL을 전달하기만 하면 됩니다:

> "이 글 읽어줘: https://mp.weixin.qq.com/s/xxx"

Agent가 Chrome에서 자동으로 URL을 열고, 로딩을 기다린 후 본문을 추출합니다. 수동으로 브라우저를 열 필요가 없습니다.

이미 열려 있는 페이지를 읽게 할 수도 있습니다:

> "지금 열린 페이지 내용 읽어줘"

페이지 유형을 자동으로 감지하고 최적의 선택자를 사용합니다:

| 페이지 | 선택자 |
|--------|--------|
| WeChat 공식 계정 | `#js_content` |
| X/Twitter 긴 글 | `[data-testid=articleContent]` |
| 그 외 모든 페이지 | `document.body.innerText` |

### 출력 형식

```
[기사 본문]

---
[IMAGES]
https://...이미지1
https://...이미지2
```

이미지 URL은 `[IMAGES]` 섹션에 나열됩니다. Agent가 비전 기능으로 각 이미지를 확인합니다.

### 제한 사항

- macOS + Chrome 전용
- X Thread 미지원 (가상 목록으로 완전한 추출 불가)

### 기여

Windows PowerShell 지원, Firefox / Arc 브라우저 지원, 사이트별 전용 선택자 추가 등 PR을 환영합니다.
