---
name: browser-reader
version: 1.1.0
description: 读取 Chrome 页面正文，自动适配微信公众号、X/Twitter Articles 和通用网页。支持直接传入 URL（自动在 Chrome 打开后读取），或读取当前已打开的 tab。适用于 defuddle/curl 无法访问的需要登录态的页面。触发：用户提供 URL 要求读取内容，或说「帮我读这篇文章」「读一下这个页面」时。
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

**传入 URL（推荐）：** agent 自动在 Chrome 打开链接，等待加载后提取正文
```bash
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh "https://mp.weixin.qq.com/s/xxx"
```

**读取当前 tab：** 用户已在 Chrome 打开页面时使用
```bash
bash ~/.claude/skills/browser-reader/scripts/read_browser.sh
```

输出：正文纯文本到 stdout。

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
