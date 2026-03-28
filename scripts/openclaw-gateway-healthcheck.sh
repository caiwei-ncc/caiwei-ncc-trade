#!/bin/sh
set -eu
LOG="/root/.openclaw/workspace/logs/openclaw-gateway-healthcheck.log"
STATEFILE="/root/.openclaw/workspace/logs/openclaw-gateway-healthcheck.state"
TMP1="/tmp/openclaw-gateway-status1.$$"
TMP2="/tmp/openclaw-gateway-status2.$$"
mkdir -p /root/.openclaw/workspace/logs
NOW="$(date '+%Y-%m-%d %H:%M:%S %Z')"
TARGET='user:ou_2e94f4d90060ddc13d0bd33bbd5ffa78'

check_ok() {
  FILE="$1"
  if [ ! -f "$FILE" ]; then
    return 1
  fi
  grep -q 'RPC probe: ok' "$FILE"
}

openclaw gateway status >"$TMP1" 2>&1 || true
if check_ok "$TMP1"; then
  echo "$NOW OK" >> "$LOG"
  echo "ok" > "$STATEFILE"
  rm -f "$TMP1" "$TMP2"
  exit 0
fi

echo "$NOW FAIL" >> "$LOG"
cat "$TMP1" >> "$LOG" 2>/dev/null || true
/root/.openclaw/workspace/scripts/gateway-force-restart.sh >> "$LOG" 2>&1 || true
sleep 8
openclaw gateway status >"$TMP1" 2>&1 || true
sleep 5
openclaw gateway status >"$TMP2" 2>&1 || true

if check_ok "$TMP1" && check_ok "$TMP2"; then
  echo "$NOW RECOVERED" >> "$LOG"
  echo "ok" > "$STATEFILE"
  openclaw message send --channel feishu --target "$TARGET" --message "【OpenClaw网关已自动恢复】\n已自动重启恢复。无需你手动处理。\n时间：$NOW" >> "$LOG" 2>&1 || true
  sleep 2
  openclaw message send --channel feishu --target "$TARGET" --message "【恢复确认】OpenClaw网关已恢复正常。" >> "$LOG" 2>&1 || true
else
  LAST=""
  [ -f "$STATEFILE" ] && LAST="$(cat "$STATEFILE" 2>/dev/null || true)"
  if [ "$LAST" != "alerted" ]; then
    openclaw message send --channel feishu --target "$TARGET" --message "【OpenClaw网关恢复失败，需要手动处理】\n自动重启后仍未恢复。请立即执行：\nopenclaw gateway status\nopenclaw gateway restart\n时间：$NOW" >> "$LOG" 2>&1 || true
    sleep 2
    openclaw message send --channel feishu --target "$TARGET" --message "【失败确认】若上一条未看到，请立即手动检查 gateway。" >> "$LOG" 2>&1 || true
    echo "alerted" > "$STATEFILE"
  fi
fi
rm -f "$TMP1" "$TMP2"
