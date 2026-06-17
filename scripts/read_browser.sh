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
IS_X_THREAD=false
if [[ "$current_url" == *"mp.weixin.qq.com"* ]]; then
  text_expr="document.querySelector('#js_content') ? document.querySelector('#js_content').innerText : document.body.innerText"
  img_expr="Array.from(document.querySelectorAll('#js_content img')).map(function(i){return i.getAttribute('data-src')||i.src}).filter(Boolean).join(String.fromCharCode(10))"
  # 微信图片用 data-src 懒加载，克隆时修正为 src
  html_js="(function(){ var c=document.querySelector('#js_content')||document.body; var cl=c.cloneNode(true); cl.querySelectorAll('img').forEach(function(i){var d=i.getAttribute('data-src');if(d)i.setAttribute('src',d);}); cl.querySelectorAll('script,style,iframe,noscript').forEach(function(e){e.remove();}); return cl.innerHTML; })()"
elif [[ "$current_url" == *"x.com"* || "$current_url" == *"twitter.com"* ]]; then
  # 推文串（含 /status/）且非导出模式时，启用滚动收集
  if [[ "$current_url" == *"/status/"* ]] && [[ -z "$FORMAT" ]]; then
    IS_X_THREAD=true
  fi
  text_expr="document.querySelector('[data-testid=articleContent]') ? document.querySelector('[data-testid=articleContent]').innerText : document.body.innerText"
  img_expr="Array.from(document.querySelectorAll('[data-testid=articleContent] img')).map(function(i){return i.src}).filter(Boolean).join(String.fromCharCode(10))"
  html_js="(function(){ var c=document.querySelector('[data-testid=articleContent]')||document.body; var cl=c.cloneNode(true); cl.querySelectorAll('script,style,iframe,noscript').forEach(function(e){e.remove();}); return cl.innerHTML; })()"
else
  text_expr='document.body.innerText'
  img_expr="Array.from(document.querySelectorAll('img')).map(function(i){return i.src}).filter(Boolean).join(String.fromCharCode(10))"
  # 通用：优先 article/main，过滤导航栏等噪声
  html_js="(function(){ var c=document.querySelector('article')||document.querySelector('main')||document.querySelector('[role=main]')||document.body; var cl=c.cloneNode(true); cl.querySelectorAll('script,style,iframe,noscript,nav,header,footer').forEach(function(e){e.remove();}); return cl.innerHTML; })()"
fi

# ── X 推文串模式：滚动读取作者所有原帖 ────────────────────────────────────────

if [[ "$IS_X_THREAD" == "true" ]]; then
  echo "正在滚动读取推文串，请稍候..." >&2

  # 异步收集器：从顶部滚动到底，只收集第一条推文作者的内容
  COLLECTOR_JS=$(cat << 'JSEOF'
(async function(){
  window.__threadData = { done: false, tweets: [], authorHandle: null };
  try {
    await new Promise(function(r){ setTimeout(r, 500); });
    var f = document.querySelector("[data-testid=tweet]");
    if (!f) { window.__threadData.done = true; return; }
    var aa = f.querySelector("[data-testid=User-Name] a");
    var ah = aa ? location.origin + aa.getAttribute("href") : null;
    window.__threadData.authorHandle = ah;
    var seen = new Set();
    function collect() {
      var ts = document.querySelectorAll("[data-testid=tweet]");
      ts.forEach(function(t) {
        var a = t.querySelector("[data-testid=User-Name] a");
        if (!a) return;
        var h = location.origin + a.getAttribute("href");
        if (h !== ah) return;
        var el = t.querySelector("[data-testid=tweetText]");
        if (!el) return;
        var tx = el.innerText.trim();
        if (tx && !seen.has(tx)) { seen.add(tx); window.__threadData.tweets.push(tx); }
      });
    }
    window.scrollTo(0, 0);
    await new Promise(function(r){ setTimeout(r, 1000); });
    collect();
    var nc = 0, last = 0;
    while (nc < 4) {
      window.scrollBy(0, 700);
      await new Promise(function(r){ setTimeout(r, 900); });
      collect();
      var cur = window.__threadData.tweets.length;
      if (cur === last) { nc++; } else { nc = 0; last = cur; }
    }
    collect();
  } catch(e) {
    window.__threadData.error = e.message;
  }
  window.__threadData.done = true;
})();
JSEOF
)

  # base64 编码避免 AppleScript 引号转义问题
  JS_B64=$(printf '%s' "$COLLECTOR_JS" | base64 | tr -d '\n')

  # 注入异步收集器（立即返回，后台继续运行）
  osascript -e "tell application \"Google Chrome\"
    execute active tab of front window javascript \"eval(atob('${JS_B64}'))\"
  end tell" 2>/dev/null || true

  # 轮询直到完成（最多 90 秒）
  DONE=false
  for i in $(seq 1 45); do
    sleep 2
    status=$(osascript -e 'tell application "Google Chrome" to execute active tab of front window javascript "window.__threadData ? window.__threadData.done : false"' 2>/dev/null || echo "false")
    if [[ "$status" == "true" ]]; then DONE=true; break; fi
    if [[ $((i % 5)) -eq 0 ]]; then
      count=$(osascript -e 'tell application "Google Chrome" to execute active tab of front window javascript "window.__threadData ? window.__threadData.tweets.length : 0"' 2>/dev/null || echo "0")
      echo "已读取 ${count} 条..." >&2
    fi
  done

  if [[ "$DONE" != "true" ]]; then
    echo "警告：读取超时，输出已收集内容" >&2
  fi

  # 提取 JSON 结果
  result=$(osascript -e 'tell application "Google Chrome" to execute active tab of front window javascript "window.__threadData ? JSON.stringify(window.__threadData.tweets) : \"[]\""' 2>/dev/null || echo "[]")

  printf '%s\n' "$result" | python3 -c '
import sys, json
raw = sys.stdin.read().strip()
try:
    tweets = json.loads(raw)
except Exception:
    tweets = []
if not tweets:
    print("未读取到推文，请确认页面已加载完成", file=sys.stderr)
    sys.exit(1)
for i, t in enumerate(tweets, 1):
    print(f"[{i}/{len(tweets)}]")
    print(t)
    if i < len(tweets):
        print()
' || {
    echo "错误：未能提取推文串内容" >&2
    exit 1
  }

# ── 文档导出模式（--html 或 --md）────────────────────────────────────────────

elif [[ -n "$FORMAT" ]]; then
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
    CLEAN_PY="$(dirname "$0")/clean_html.py"
    python3 "$CLEAN_PY" < "$TMP_RAW" | pandoc -f html -t gfm --wrap=none -o "$OUT_FILE"
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
