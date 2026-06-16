#!/usr/bin/env bash
set -euo pipefail

URL="${1:-}"  # 可选 URL 参数

# 检查 Chrome 是否运行
if ! pgrep -x "Google Chrome" > /dev/null; then
  echo "错误：Google Chrome 未运行" >&2
  exit 1
fi

# 如果传入了 URL，先在 Chrome 打开
if [[ -n "$URL" ]]; then
  osascript -e "tell application \"Google Chrome\"
    activate
    open location \"${URL}\"
  end tell" 2>&1 || {
    echo "错误：无法在 Chrome 中打开链接" >&2
    exit 1
  }

  # 等 Chrome 建好新 tab
  sleep 0.5

  # 轮询 document.readyState，最多等 30 秒
  for i in $(seq 1 30); do
    state=$(osascript -e 'tell application "Google Chrome" to execute active tab of front window javascript "document.readyState"' 2>/dev/null || echo "loading")
    if [[ "$state" == "complete" ]]; then
      break
    fi
    sleep 1
  done

  # JS 渲染型页面（React/SPA）加载完 DOM 后还需要短暂等待
  sleep 1
fi

# 获取当前 tab URL（失败时给出权限提示）
current_url=$(osascript -e 'tell application "Google Chrome" to return URL of active tab of front window' 2>&1) || {
  echo "错误：无法获取 Chrome 页面 URL。请确认已开启「允许 Apple 事件中的 JavaScript」：菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript" >&2
  exit 1
}

# 根据 URL 选择最优 JS 选择器（文字 + 图片）
if [[ "$current_url" == *"mp.weixin.qq.com"* ]]; then
  text_expr="document.querySelector('#js_content') ? document.querySelector('#js_content').innerText : document.body.innerText"
  # 微信图片用 data-src 懒加载，优先取 data-src
  img_expr="Array.from(document.querySelectorAll('#js_content img')).map(function(i){return i.getAttribute('data-src')||i.src}).filter(Boolean).join(String.fromCharCode(10))"
elif [[ "$current_url" == *"x.com"* || "$current_url" == *"twitter.com"* ]]; then
  text_expr="document.querySelector('[data-testid=articleContent]') ? document.querySelector('[data-testid=articleContent]').innerText : document.body.innerText"
  img_expr="Array.from(document.querySelectorAll('[data-testid=articleContent] img')).map(function(i){return i.src}).filter(Boolean).join(String.fromCharCode(10))"
else
  text_expr='document.body.innerText'
  img_expr="Array.from(document.querySelectorAll('img')).map(function(i){return i.src}).filter(Boolean).join(String.fromCharCode(10))"
fi

# 提取正文
osascript -e "
tell application \"Google Chrome\"
  set activeTab to active tab of front window
  set pageContent to execute activeTab javascript \"${text_expr}\"
  return pageContent
end tell
" 2>&1 || {
  echo "错误：JS 执行失败。请确认已开启「允许 Apple 事件中的 JavaScript」" >&2
  exit 1
}

# 提取图片 URL
img_urls=$(osascript -e "
tell application \"Google Chrome\"
  set activeTab to active tab of front window
  set imgList to execute activeTab javascript \"${img_expr}\"
  return imgList
end tell
" 2>/dev/null || echo "")

if [[ -n "$img_urls" && "$img_urls" != "missing value" ]]; then
  echo ""
  echo "---"
  echo "[IMAGES]"
  echo "$img_urls"
fi
