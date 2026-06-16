---
name: browser-reader
version: 1.3.0
description: 读取 Chrome 页面正文和图片，自动适配微信公众号、X/Twitter Articles 和通用网页。支持直接传入 URL（自动在 Chrome 打开后读取）。支持输出为 HTML 文档（--html）或 Markdown 文档（--md），图片内嵌在正文正确位置。适用于 defuddle/curl 无法访问的需要登录态的页面。触发：用户提供 URL 要求读取内容，或说「帮我读这篇文章」「导出这篇文章」时。
---

# browser-reader

读取 Chrome 页面正文，自动适配微信/推特/通用页面。支持直接传 URL，无需手动打开浏览器。

## 何时使用

- 用户提供 URL，要求读取需要登录的页面（微信公众号、X/Twitter Articles 等）
- `defuddle` / `curl` 返回登录页或 403
- 用户说「帮我读这篇文章」「读一下这个页面」

## 前置条件（用户一次性设置）

Chrome 必须开启「允许 Apple 事件中的 JavaScript」：  
**菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript**

如果未开启，脚本会给出明确提示。

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

| URL 匹配 | 选择器 | 说明 |
|----------|--------|------|
| `mp.weixin.qq.com` | `#js_content` | 微信公众号正文容器 |
| `x.com` / `twitter.com` | `[data-testid=articleContent]` | X Articles 正文容器 |
| 其他所有页面 | `document.body.innerText` | 通用回退 |

## 局限性

- **仅 macOS + Chrome**（v1）
- **不提取图片**，仅文字
- **X Thread 不适用**（虚拟列表，无法用单一选择器获取完整内容）
- 懒加载页面如内容未完全渲染，可先手动滚动到底再读取
