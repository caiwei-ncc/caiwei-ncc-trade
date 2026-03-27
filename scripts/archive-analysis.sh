#!/usr/bin/env bash
# archive-analysis.sh
# 机械化归档：从缓存文件读取 Opus 原文，追加到 trade 日志
# 用法: ./scripts/archive-analysis.sh [日期 YYYY-MM-DD] [分析序号，如"第二次"]
#
# 依赖: .cache/latest-analysis.md (Opus 阶段写入的原文缓存)
# 输出: memory/trade-YYYY-MM-DD.md (追加，不覆盖已有内容)

set -euo pipefail

WORKSPACE="/root/.openclaw/workspace"
CACHE_FILE="$WORKSPACE/.cache/latest-analysis.md"
DATE="${1:-$(date +%Y-%m-%d)}"
SEQ="${2:-}"
TARGET="$WORKSPACE/memory/trade-${DATE}.md"

# 1. 检查缓存文件存在
if [ ! -f "$CACHE_FILE" ]; then
    echo "❌ 缓存文件不存在: $CACHE_FILE"
    echo "   Opus 分析阶段应先写入缓存，再触发归档"
    exit 1
fi

# 2. 检查缓存不为空
if [ ! -s "$CACHE_FILE" ]; then
    echo "❌ 缓存文件为空: $CACHE_FILE"
    exit 1
fi

# 3. 读取缓存内容
CONTENT=$(cat "$CACHE_FILE")

# 4. 如果 trade 日志不存在，创建并写入头部
if [ ! -f "$TARGET" ]; then
    echo "# GBP/USD 交易分析日志 - ${DATE}" > "$TARGET"
    echo "" >> "$TARGET"
fi

# 5. 追加分析原文（前面加两个空行分隔）
{
    echo ""
    echo ""
    echo "$CONTENT"
} >> "$TARGET"

# 6. 报告结果
LINES=$(wc -l < "$CACHE_FILE")
echo "✅ 归档完成"
echo "   来源: $CACHE_FILE ($LINES 行)"
echo "   目标: $TARGET"
echo "   序号: ${SEQ:-未指定}"

# 7. 清空缓存（防止重复归档）
> "$CACHE_FILE"
echo "   缓存已清空，防止重复归档"
