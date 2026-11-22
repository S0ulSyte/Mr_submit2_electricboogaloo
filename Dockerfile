# Mech Royale submission (two brains): the Go bot in core/ (mr-submission 6b128f2) plays until a free-for-all is
# detected, then the TypeScript edge roamer in main.js (bot/hybrid-main.ts on Hamster-J-duel) answers.
# The match runs it with no network, a read-only root (writable /tmp), 1 CPU, 512 MB, uid 65534, and the map at /arena.

# Stage 1: the Go bot, built as in core's own Dockerfile.
FROM golang:1.26.1-bookworm@sha256:ab3d6955bbc813a0f3fdf220c1d817dd89c0b3f283777db8ece4a32fe7858edd AS core
WORKDIR /src
COPY core/go.mod ./
COPY core/mech ./mech
COPY core/cmd/bot ./cmd/bot
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /mechbot ./cmd/bot

# Stage 2: the image that runs.
FROM oven/bun:1.4.4-slim@sha256:1846adf22496bd711036aae8be147e57bdebbaea2e5264e3e0b5af1db187d9a4
WORKDIR /bot
COPY --from=core /mechbot /bot/giddy
COPY main.js /bot/main.js
# JavaScriptCore's third compiler tier (FTL) bursts on helper threads use up the 1-CPU allowance mid-match and
# freeze the container, the Go child included (teammate's measurement); the first two tiers stay on.
ENV BUN_JSC_useFTLJIT=0
ENTRYPOINT ["bun", "/bot/main.js"]
