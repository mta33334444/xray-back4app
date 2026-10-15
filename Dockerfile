FROM alpine:latest

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip \
    && mkdir /tmp/xray \
    && curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com \
    && unzip /tmp/xray/xray.zip -d /tmp/xray \
    && mv /tmp/xray/xray /usr/local/bin/xray \
    && chmod +x /usr/local/bin/xray \
    && rm -rf /tmp/xray

RUN mkdir -p /etc/xray && echo '{\
  "inbounds": [{\
    "port": 8080,\
    "protocol": "vmess",\
    "settings": {\
      "clients": [{\
        "id": "b16e53d6-2542-4eaac-9dae-6e6b7368ebe0",\
        "alterId": 0\
      }]\
    },\
    "streamSettings": {\
      "network": "ws",\
      "wsSettings": {\
        "path": "/"\
      }\
    }\
  }],\
  "outbounds": [{\
    "protocol": "freedom",\
    "settings": {}\
  }]\
}' > /etc/xray/config.json

EXPOSE 8080

CMD ["/usr/local/bin/xray", "-config", "/etc/xray/config.json"]
