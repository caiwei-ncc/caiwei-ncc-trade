#!/bin/sh
export HOME=/root
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export XDG_RUNTIME_DIR=/run/user/0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/0/bus

openclaw gateway stop 2>/dev/null || true
sleep 5
openclaw gateway start >> /root/.openclaw/workspace/logs/gateway-scheduled-restart.log 2>&1
