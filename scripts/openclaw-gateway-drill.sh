#!/bin/sh
set -eu
LOG="/root/.openclaw/workspace/logs/openclaw-gateway-drill.log"
HC="/root/.openclaw/workspace/scripts/openclaw-gateway-healthcheck.sh"
NOW="$(date '+%Y-%m-%d %H:%M:%S %Z')"
{
  echo "=== DRILL START $NOW ==="
  openclaw gateway stop || true
  sleep 2
  "$HC" || true
  echo "=== DRILL END $(date '+%Y-%m-%d %H:%M:%S %Z') ==="
} >> "$LOG" 2>&1
