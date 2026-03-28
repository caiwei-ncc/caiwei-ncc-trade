#!/bin/sh
set -eu
LOG="/root/.openclaw/workspace/logs/openclaw-gateway-notify-drill.log"
HC="/root/.openclaw/workspace/scripts/openclaw-gateway-healthcheck.sh"
{
  echo "=== NOTIFY DRILL START $(date '+%Y-%m-%d %H:%M:%S %Z') ==="
  openclaw gateway stop || true
  sleep 2
  "$HC" || true
  echo "=== NOTIFY DRILL END $(date '+%Y-%m-%d %H:%M:%S %Z') ==="
} >> "$LOG" 2>&1
