#!/usr/bin/env bash
set -euo pipefail

# 解析参数：支持任意顺序的 URL 和格式标志
URL=""
FORMAT=""
for arg in "$@"; do
  case "$arg" in
    --md|--html) FORMAT="$arg" ;;
    *) URL="$arg" ;;
  esac
done

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
  sleep 0.5
  for i in $(seq 1 30); do
    state=$(osascript -e 'tell application "Google Chrome" to execute active tab of front window javascript "document.readyState"' 2>/dev/null || echo "loading")
    if [[ "$state" == "complete" ]]; then break; fi
    sleep 1
  done
  sleep 1

  # 等待 URL 稳定（避免重定向未完成时就读取）
  prev_url=""
  for i in $(seq 1 5); do
    cur=$(osascript -e 'tell application "Google Chrome" to return URL of active tab of front window' 2>/dev/null || echo "")
    if [[ "$cur" == "$prev_url" && -n "$cur" ]]; then break; fi
    prev_url="$cur"
    sleep 0.5
  done
fi

# 获取当前 tab URL
current_url=$(osascript -e 'tell application "Google Chrome" to return URL of active tab of front window' 2>&1) || {
  echo "错误：无法获取 Chrome 页面 URL。请确认已开启「允许 Apple 事件中的 JavaScript」：菜单栏 → 查看 → 开发者 → 允许 Apple 事件中的 JavaScript" >&2
  exit 1
}

# 根据 URL 确定最优选择器（用单引号字符串，避免与 AppleScript 双引号冲突）
if [[ "$current_url" == *"mp.weixin.qq.com"* ]]; then
  text_expr="document.querySelector('#js_content') ? document.querySelector('#js_content').innerText : document.body.innerText"
  img_expr="Array.from(document.querySelectorAll('#js_content img')).map(function(i){return i.getAttribute('data-src')||i.src}).filter(Boolean).join(String.fromCharCode(10))"
  # 微信图片用 data-src 懒加载，克隆时修正为 src
  html_js="(function(){ var c=document.querySelector('#js_content')||document.body; var cl=c.cloneNode(true); cl.querySelectorAll('img').forEach(function(i){var d=i.getAttribute('data-src');if(d)i.setAttribute('src',d);}); cl.querySelectorAll('script,style,iframe,noscript').forEach(function(e){e.remove();}); return cl.innerHTML; })()"
elif [[ "$current_url" == *"x.com"* || "$current_url" == *"twitter.com"* ]]; then
  text_expr="document.querySelector('[data-testid=articleContent]') ? document.querySelector('[data-testid=articleContent]').innerText : document.body.innerText"
  img_expr="Array.from(document.querySelectorAll('[data-testid=articleContent] img')).map(function(i){return i.src}).filter(Boolean).join(String.fromCharCode(10))"
  html_js="(function(){ var c=document.querySelector('[data-testid=articleContent]')||document.body; var cl=c.cloneNode(true); cl.querySelectorAll('script,style,iframe,noscript').forEach(function(e){e.remove();}); return cl.innerHTML; })()"
else
  text_expr='document.body.innerText'
  img_expr="Array.from(document.querySelectorAll('img')).map(function(i){return i.src}).filter(Boolean).join(String.fromCharCode(10))"
  # 通用：优先 article/main，过滤导航栏等噪声
  html_js="(function(){ var c=document.querySelector('article')||document.querySelector('main')||document.querySelector('[role=main]')||document.body; var cl=c.cloneNode(true); cl.querySelectorAll('script,style,iframe,noscript,nav,header,footer').forEach(function(e){e.remove();}); return cl.innerHTML; })()"
fi

# ── 文档导出模式（--html 或 --md）────────────────────────────────────────────

if [[ -n "$FORMAT" ]]; then
  if [[ "$FORMAT" == "--md" ]] && ! command -v pandoc &>/dev/null; then
    echo "错误：--md 模式需要 pandoc（brew install pandoc）" >&2
    exit 1
  fi

  PAGE_TITLE=$(osascript -e 'tell application "Google Chrome" to return title of active tab of front window' 2>/dev/null || echo "Article")
  TMP_RAW="/tmp/browser-reader-raw.html"

  # 提取文章 HTML
  article_html=$(osascript -e "
tell application \"Google Chrome\"
  set activeTab to active tab of front window
  return execute activeTab javascript \"${html_js}\"
end tell
" 2>&1) || {
    echo "错误：JS 执行失败。请确认已开启「允许 Apple 事件中的 JavaScript」" >&2
    exit 1
  }

  if [[ -z "$article_html" || "$article_html" == "missing value" ]]; then
    echo "错误：未能提取到文章内容" >&2
    exit 1
  fi

  printf '%s' "$article_html" > "$TMP_RAW"

  if [[ "$FORMAT" == "--html" ]]; then
    OUT_FILE="/tmp/browser-reader-article.html"
    {
      cat << HEADER
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${PAGE_TITLE}</title>
  <style>
    body { max-width: 800px; margin: 40px auto; padding: 0 20px; font-family: -apple-system, BlinkMacSystemFont, sans-serif; line-height: 1.7; color: #333; }
    img { max-width: 100%; height: auto; display: block; margin: 1em 0; }
    h1, h2, h3 { line-height: 1.3; }
    a { color: #0066cc; }
  </style>
</head>
<body>
HEADER
      cat "$TMP_RAW"
      printf '\n</body>\n</html>\n'
    } > "$OUT_FILE"
    echo "$OUT_FILE"

  elif [[ "$FORMAT" == "--md" ]]; then
    OUT_FILE="/tmp/browser-reader-article.md"
    pandoc -f html -t markdown-raw_html --wrap=none "$TMP_RAW" -o "$OUT_FILE"
    echo "$OUT_FILE"
  fi

# ── 默认模式：纯文字 + 图片 URL 列表 ────────────────────────────────────────

else
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
fi
