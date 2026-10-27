// Short-lived Cloudflare TURN credentials for the game's online play.
// The key id and API token live in the Vercel project's environment variables, never in the page.
module.exports = async (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  const id = process.env.CF_TURN_KEY_ID, token = process.env.CF_TURN_API_TOKEN;
  if (!id || !token) { res.status(503).json({ iceServers: [] }); return; }
  try {
    const r = await fetch(`https://rtc.live.cloudflare.com/v1/turn/keys/${id}/credentials/generate-ice-servers`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ ttl: 86400 })
    });
    if (!r.ok) { res.status(502).json({ iceServers: [] }); return; }
    const data = await r.json();
    const list = Array.isArray(data.iceServers) ? data.iceServers : [data.iceServers].filter(Boolean);
    // browsers refuse port 53, so those addresses would only slow the link down
    const iceServers = list.map(s => ({ ...s, urls: [].concat(s.urls).filter(u => !/:53(\?|$)/.test(u)) })).filter(s => s.urls.length);
    res.status(200).json({ iceServers });
  } catch (e) {
    res.status(502).json({ iceServers: [] });
  }
};
