# Mech Royale submission: the wall bot (wall7) from bot/provenw.ts on Hamster-J-duel (bot/main-wall7.ts, settings
# bot/params-wall7.json; wall-end spots, route graph and heat map embedded in bot.js).
# The match runs it with no network, a read-only root (writable /tmp), 1 CPU, 512 MB, uid 65534, and the map at /arena.
FROM oven/bun:1.4.4-slim@sha256:1846adf22496bd711036aae8be147e57bdebbaea2e5264e3e0b5af1db187d9a4
WORKDIR /bot
COPY bot.js /bot/bot.js
ENTRYPOINT ["bun", "/bot/bot.js"]
