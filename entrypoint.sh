#!/bin/sh
# Build the Xray config from environment variables at container start.
# Secrets never live in this repo: set UUID and WS_PATH in the Cloady dashboard.
set -e
: "${UUID:?UUID env var is required}"
: "${WS_PATH:?WS_PATH env var is required}"

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": 3000,
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "$UUID", "flow": "" }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WS_PATH" }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom" }
  ]
}
EOF

exec /usr/local/bin/xray run -c /etc/xray/config.json
