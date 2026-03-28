#!/bin/sh
set -eu
LOG="/root/.openclaw/workspace/logs/final-gateway-drill.log"
HC="/root/.openclaw/workspace/scripts/openclaw-gateway-healthcheck.sh"
{
  echo "=== FINAL DRILL START $(date '+%Y-%m-%d %H:%M:%S %Z') ==="
  openclaw gateway stop || true
  sleep 2
  "$HC" || true
  echo "=== FINAL DRILL END $(date '+%Y-%m-%d %H:%M:%S %Z') ==="
} >> "$LOG" 2>&1
