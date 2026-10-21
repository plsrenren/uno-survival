#!/bin/sh
# game.html is the page body as published in Claude (Claude adds the document head there).
# The website needs a full document with a viewport tag, or phones render it at desktop width.
cd "$(dirname "$0")"
{
  printf '%s\n' '<!doctype html>' '<html lang="en">' '<head>' \
    '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">' \
    '<meta name="theme-color" content="#020617">' \
    '</head>' '<body>'
  cat game.html
  printf '%s\n' '</body>' '</html>'
} > index.html
