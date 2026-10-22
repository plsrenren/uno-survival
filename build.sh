#!/bin/sh
# game.html is the page body as published in Claude (Claude adds the document head there).
# The website needs a full document with a viewport tag, or phones render it at desktop width.
# It also gets Tailwind prebuilt and inlined, in place of the in-browser CDN build the artifact uses.
set -e
cd "$(dirname "$0")"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
printf '@tailwind base;\n@tailwind components;\n@tailwind utilities;\n' > "$tmp/in.css"
npx -y tailwindcss@3.4.17 -i "$tmp/in.css" -o "$tmp/tw.css" --content game.html --minify 2>/dev/null
cdn='<script src="https://cdn.tailwindcss.com/3.4.17"></script>'
grep -qF "$cdn" game.html || { echo "build.sh: Tailwind CDN tag not found in game.html" >&2; exit 1; }
{
  printf '%s\n' '<!doctype html>' '<html lang="en">' '<head>' \
    '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">' \
    '<meta name="theme-color" content="#020617">' \
    '</head>' '<body>'
  python3 -I -c '
import sys
page, css, tag = open(sys.argv[1]).read(), open(sys.argv[2]).read(), sys.argv[3]
sys.stdout.write(page.replace(tag, "<style>" + css + "</style>", 1))' game.html "$tmp/tw.css" "$cdn"
  printf '%s\n' '</body>' '</html>'
} > index.html
