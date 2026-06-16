#!/usr/bin/env python3
"""把 HTML 里的布局容器（div/span/section 等）透明化，只保留语义标签，供 pandoc 转 Markdown 用。"""
import sys
from html.parser import HTMLParser

# 保留为块级元素
KEEP_BLOCK = {
    'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
    'ul', 'ol', 'li', 'blockquote', 'pre',
    'table', 'thead', 'tbody', 'tr', 'td', 'th',
    'figure', 'figcaption',
}
# 保留为行内元素
KEEP_INLINE = {'strong', 'b', 'em', 'i', 'code', 's', 'del', 'sup', 'sub'}
# 整棵子树丢弃
DROP = {
    'script', 'style', 'noscript', 'iframe', 'svg',
    'form', 'button', 'input', 'select', 'textarea',
    'nav', 'aside',
}

class Cleaner(HTMLParser):
    def __init__(self):
        super().__init__()
        self.out = []
        self.drop = 0  # 嵌套计数，>0 时丢弃所有内容

    def handle_starttag(self, tag, attrs):
        if self.drop:
            self.drop += 1
            return
        if tag in DROP:
            self.drop = 1
            return

        d = dict(attrs)

        if tag in KEEP_BLOCK:
            self.out.append(f'<{tag}>')
        elif tag in KEEP_INLINE:
            self.out.append(f'<{tag}>')
        elif tag == 'a':
            href = d.get('href', '#')
            self.out.append(f'<a href="{href}">')
        elif tag == 'img':
            src = d.get('src') or d.get('data-src', '')
            alt = d.get('alt', '')
            if src:
                self.out.append(f'\n<img src="{src}" alt="{alt}">\n')
        elif tag == 'br':
            self.out.append('\n')
        elif tag == 'hr':
            self.out.append('\n<hr>\n')
        # div / span / section / article 等：透明化，只处理子节点

    def handle_endtag(self, tag):
        if self.drop:
            self.drop -= 1
            return
        if tag in KEEP_BLOCK or tag in KEEP_INLINE or tag == 'a':
            self.out.append(f'</{tag}>\n')

    def handle_data(self, data):
        if not self.drop:
            self.out.append(data)

    def handle_entityref(self, name):
        if not self.drop:
            self.out.append(f'&{name};')

    def handle_charref(self, name):
        if not self.drop:
            self.out.append(f'&#{name};')

cleaner = Cleaner()
cleaner.feed(sys.stdin.read())
sys.stdout.write(''.join(cleaner.out))
