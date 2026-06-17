# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 测试命令

```bash
# 读取当前 Chrome tab（默认模式）
bash scripts/read_browser.sh

# 打开 URL 后读取
bash scripts/read_browser.sh https://mp.weixin.qq.com/s/xxx

# 导出 HTML
bash scripts/read_browser.sh --html

# 导出 Markdown（依赖 pandoc：brew install pandoc）
bash scripts/read_browser.sh --md
```

临时输出文件：`/tmp/browser-reader-article.html` 和 `/tmp/browser-reader-article.md`。

## 架构

两个脚本，职责清晰：

- **`scripts/read_browser.sh`**：入口。AppleScript + JavaScript 注入读取 Chrome，按 URL 选选择器，处理等待/重定向，输出文字或调度 `clean_html.py | pandoc`。
- **`scripts/clean_html.py`**：HTML 清洗器（标准库 `html.parser`，无依赖）。将 div/span/section 透明化，只保留语义标签，丢弃整棵 script/style/nav 子树，消除 pandoc 产生的 `:::` 容器产物。

### 页面适配（`read_browser.sh:54-68`）

| 条件 | 文字选择器 | HTML 提取 |
|------|-----------|-----------|
| `mp.weixin.qq.com` | `#js_content.innerText` | 克隆 `#js_content`，将 `data-src` 修正为 `src` |
| `x.com` / `twitter.com` | `[data-testid=articleContent].innerText` | 克隆 `[data-testid=articleContent]` |
| 其他 | `document.body.innerText` | 优先 `article` → `main` → `[role=main]` → `body`，移除 nav/header/footer |

### `clean_html.py` 三类标签处理

- `KEEP_BLOCK`（p/h1-h6/ul/ol/li/table 等）：保留原标签，去掉所有属性
- `KEEP_INLINE`（strong/em/code 等）和 `a`（保留 href）：保留
- `DROP`（script/style/nav/aside 等）：整棵子树丢弃，用 `self.drop` 计数器跟踪嵌套
- 其他（div/span/section）：透明化，只输出子节点内容

## 关键约束

- 仅支持 macOS + Google Chrome（依赖 AppleScript `osascript`）
- Chrome 须开启「允许 Apple 事件中的 JavaScript」（开发者菜单）
- X Thread 推文串（`/status/` URL）自动滚动收集，默认只取原作者；`--user @handle` 取指定用户；`--all` 取所有人

## 发版规范

改动后同步更新：
1. `SKILL.md` 的 `version` 字段和使用说明
2. `CHANGELOG.md` 新增版本条目（格式 `## vX.Y.Z (YYYY-MM-DD)`）
3. git push 后 GitHub Actions 自动创建 Release（无需手动打 tag）

## 文档规范

- **改代码后必须同步文档**：功能说明、局限性、前置条件都要对照实际行为逐条核对，不能从旧文档复制了事
- **局限性只写真正的限制**（平台、依赖、无法做到的事），功能的使用说明放在使用方法里
- **前置条件写安装/配置依赖**（Chrome 设置、pandoc 等），不是限制
- 改动涉及多个文档（SKILL.md、README 四语言）时，逐一核对每份，不能只改其中一份
