# UNO Survival

A single-page UNO elimination game for up to 16 players. Open `index.html` in a browser, or visit the Vercel deployment.

Play against bots, or share your 4-character room code so friends can join. On the website, PeerJS connects the players; inside Claude, the artifact room feature does.

`game.html` is the source (the same file published in Claude). Run `./build.sh` after editing it to regenerate `index.html`, which wraps it in a full page with the mobile viewport tag and swaps the in-browser Tailwind CDN for a prebuilt, inlined stylesheet (needs Node for `npx tailwindcss@3.4.17`).
