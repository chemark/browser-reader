---
name: browser-reader
version: 1.4.6
description: 读取 Chrome 页面正文和图片，自动适配微信公众号、X/Twitter 推文串和通用网页。支持直接传入 URL（自动在 Chrome 打开后读取）。支持输出为 HTML 文档（--html）或 Markdown 文档（--md），图片内嵌在正文正确位置。适用于 defuddle/curl 无法访问的需要登录态的页面。触发：用户提供 URL 要求读取内容，或说「帮我读这篇文章」「导出这篇文章」时。
---

# browser-reader

读取 Chrome 页面正文，自动适配微信/推特/通用页面。支持直接传 URL，无需手动打开浏览器。

## 何时使用

- 用户提供 URL，要求读取需要登录的页面（微信公众号、X/Twitter Articles 等）
- `defuddle` / `curl` 返回登录页或 403
- 用户说「帮我读这篇文章」「读一下这个页面」

## 前置条件（用户一次性设置）

- Chrome 必须开启「允许 Apple 事件中的 JavaScript」：  
  **菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript**  
  如果未开启，脚本会给出明确提示。
- `--md` 模式需要 pandoc：`brew install pandoc`

## 使用方法

参数可任意组合，顺序不限：

```bash
# 默认模式：输出纯文字 + 图片 URL 列表
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh [URL]

# 导出干净 HTML 文档（图片内嵌在正文位置，macOS 可直接预览）
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh [URL] --html

# 导出 Markdown 文档（需要 pandoc）
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh [URL] --md
```

- URL 可省略，省略时读取 Chrome 当前已打开的 tab
- `--html` / `--md` 输出文件路径到 stdout（`/tmp/browser-reader-article.html` 或 `.md`）
- 默认模式输出纯文字正文，图片 URL 列在 `[IMAGES]` 区块，收到后用 Read 工具逐一查看

导出 HTML 后可用 `open /tmp/browser-reader-article.html` 在 macOS 预览。

## 自动识别逻辑

| URL 匹配 | 模式 | 说明 |
|----------|------|------|
| `mp.weixin.qq.com` | 单次读取 | `#js_content` 容器 |
| `x.com` / `twitter.com` + `/status/` | **滚动收集** | 自动从顶到底，只收集原作者推文 |
| `x.com` / `twitter.com`（其他） | 单次读取 | `[data-testid=articleContent]` 或 body |
| 其他所有页面 | 单次读取 | `article` → `main` → `body` 降级 |

X 推文串模式自动触发（无需额外参数），默认只读原作者。可加参数切换：

```bash
# 默认：只读原作者
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh

# 只读指定用户（@ 可省略）
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh --user @somehandle

# 读取所有人的推文（输出时显示每条的作者）
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh --all
```

输出格式：`[1/N]`…`[N/N]`，`--all` 模式每条前显示 `@作者`。

## 局限性

- **仅 macOS + Chrome**
