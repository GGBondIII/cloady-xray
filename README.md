# xray on Cloady (free tier)

VLESS + WebSocket + TLS, for personal use only.

## How it works

- The container listens on port **3000** inside; Cloady terminates TLS and
  exposes it on **443** under the app's `*.cloady.io` subdomain.
- The official Xray image has no shell, so this repo uses a multi-stage
  `Dockerfile`: stage 1 downloads the official Xray release binary, stage 2
  copies it into a minimal Alpine image with an entrypoint script.
- The entrypoint builds `/etc/xray/config.json` from environment variables
  at container start, so no secret is ever committed to this repo.

## Required environment variables (set in the Cloady dashboard)

| Variable | Meaning |
|----------|---------|
| `UUID` | VLESS client UUID (generate one, e.g. `uuidgen`) |
| `WS_PATH` | WebSocket path, e.g. `/9f2c4a7b1e8d4a6f` (must start with `/`, random hex) |

## Resource limits (Cloady free tier)

Keep the app inside 0.5 vCPU / 1 GB RAM / 5 GB SSD — going over any one
limit makes the whole workspace billable. Region: US West (USW1).

## Client

`vless://<UUID>@<subdomain>.cloady.io:443?encryption=none&security=tls&sni=<subdomain>.cloady.io&type=ws&host=<subdomain>.cloady.io&path=<url-encoded WS_PATH>#Cloady-USW1`

Import the link into Clash Verge (Android) or any VLESS client.
