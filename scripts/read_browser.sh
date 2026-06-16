#!/usr/bin/env bash
set -euo pipefail

# 检查 Chrome 是否运行
if ! pgrep -x "Google Chrome" > /dev/null; then
  echo "错误：Google Chrome 未运行" >&2
  exit 1
fi

# 获取当前 tab URL（失败时给出权限提示）
current_url=$(osascript -e 'tell application "Google Chrome" to return URL of active tab of front window' 2>&1) || {
  echo "错误：无法获取 Chrome 页面 URL。请确认已开启「允许 Apple 事件中的 JavaScript」：菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript" >&2
  exit 1
}

# 根据 URL 选择最优 JS 选择器
# 注意：选择器字符串使用单引号，避免与 AppleScript 字符串的双引号冲突
if [[ "$current_url" == *"mp.weixin.qq.com"* ]]; then
  js_expr="document.querySelector('#js_content') ? document.querySelector('#js_content').innerText : document.body.innerText"
elif [[ "$current_url" == *"x.com"* || "$current_url" == *"twitter.com"* ]]; then
  # 属性值不加引号（articleContent 是合法标识符），避免双引号嵌套问题
  js_expr="document.querySelector('[data-testid=articleContent]') ? document.querySelector('[data-testid=articleContent]').innerText : document.body.innerText"
else
  js_expr='document.body.innerText'
fi

# 执行 JS 提取正文
osascript -e "
tell application \"Google Chrome\"
  set activeTab to active tab of front window
  set pageContent to execute activeTab javascript \"${js_expr}\"
  return pageContent
end tell
" 2>&1 || {
  echo "错误：JS 执行失败。请确认已开启「允许 Apple 事件中的 JavaScript」" >&2
  exit 1
}
