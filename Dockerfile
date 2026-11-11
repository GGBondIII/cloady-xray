# Stage 1: download the official Xray release (the official image has no shell,
# so we fetch the binary here and copy it into Alpine in stage 2).
FROM alpine:3.20 AS downloader
RUN apk add --no-cache curl unzip
ARG XRAY_VERSION=26.3.27
RUN curl -L -o /tmp/xray.zip \
      "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" \
    && unzip /tmp/xray.zip -d /tmp/xray \
    && chmod +x /tmp/xray/xray

# Stage 2: minimal Alpine runtime with a shell for the entrypoint.
FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=downloader /tmp/xray/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
