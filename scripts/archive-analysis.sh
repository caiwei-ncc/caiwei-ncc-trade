#!/usr/bin/env bash
# archive-analysis.sh
# 机械化归档：从缓存读取 Opus 纯分析原文，加格式壳后追加到 trade 日志
#
# 用法: ./scripts/archive-analysis.sh [日期] [序号中文] [时间HH:MM] [图片路径...]
#   例: ./scripts/archive-analysis.sh 2026-03-27 "第五次" "23:00" \
#        "images/2026-03-27/chart_4h_005.png" \
#        "images/2026-03-27/chart_1h_005.png" \
#        "images/2026-03-27/chart_15m_005.png"
#
# 依赖: .cache/latest-analysis.md (Opus 阶段写入的纯分析内容)
# 输出: memory/trade-YYYY-MM-DD.md (追加，不覆盖已有内容)
#
# 格式壳由脚本负责：分割线、标题、说明位、图片 wiki-link
# Opus 只写纯分析内容，不管格式
# GPT 5.4 只传参调脚本，不碰正文也不碰格式

set -euo pipefail

WORKSPACE="/root/.openclaw/workspace"
CACHE_FILE="$WORKSPACE/.cache/latest-analysis.md"
DATE="${1:-$(date +%Y-%m-%d)}"
SEQ="${2:-}"
TIME="${3:-$(date +%H:%M)}"
shift 3 2>/dev/null || true
IMAGES=("$@")

TARGET="$WORKSPACE/memory/trade-${DATE}.md"

# 1. 检查缓存文件存在且非空
if [ ! -f "$CACHE_FILE" ]; then
    echo "❌ 缓存文件不存在: $CACHE_FILE"
    echo "   Opus 分析阶段应先写入缓存，再触发归档"
    exit 1
fi

if [ ! -s "$CACHE_FILE" ]; then
    echo "❌ 缓存文件为空: $CACHE_FILE"
    exit 1
fi

# 2. 读取缓存内容（纯分析原文）
CONTENT=$(cat "$CACHE_FILE")

# 3. 如果 trade 日志不存在，创建并写入头部
if [ ! -f "$TARGET" ]; then
    echo "# ${DATE} GBP/USD 交易分析日志" > "$TARGET"
    echo "" >> "$TARGET"
fi

# 4. 构建格式壳并追加

{
    # 分割线（与前一次分析隔开）
    echo ""
    echo "---"
    echo ""

    # 标题
    if [ -n "$SEQ" ]; then
        echo "## ${SEQ}分析（${TIME}）"
    else
        echo "## 分析（${TIME}）"
    fi

    # 说明位
    echo "> - 已切到 \`anthropic/claude-opus-4-6\`"
    echo "> - 已读取 \`TRADINGVIEW.md\`"
    echo "> - 已读取 \`tradingview/chan-definitions.md\`"
    echo "> - 图片链路：图片随消息附带，由当前 Opus 会话直接读取"
    echo ""

    # 图片 wiki-link（如果有传入图片路径）
    # 图片会插在分析内容之前，按 4H → 1H → 15M 顺序
    for img in "${IMAGES[@]}"; do
        if [ -n "$img" ]; then
            echo "![[../${img}|1300]]"
            echo ""
        fi
    done

    # 纯分析原文（Opus 输出，一字不改）
    echo "$CONTENT"

} >> "$TARGET"

# 5. 报告结果
LINES=$(wc -l < "$CACHE_FILE")
IMG_COUNT=${#IMAGES[@]}
echo "✅ 归档完成"
echo "   来源: $CACHE_FILE ($LINES 行)"
echo "   目标: $TARGET"
echo "   序号: ${SEQ:-未指定}"
echo "   时间: $TIME"
echo "   图片: ${IMG_COUNT} 张"

# 6. 清空缓存（防止重复归档）
> "$CACHE_FILE"
echo "   缓存已清空，防止重复归档"
