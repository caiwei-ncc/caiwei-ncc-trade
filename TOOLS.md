# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics - the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

## 模型切换规则

### 阿里云服务器专用（hostname: `iZmj7cqb1nl6lp5rzrhhpgZ`）
- 默认模型：`videnx/gpt-5.4`
- 图片 / 行情 / 图表分析：切到 `anthropic/claude-opus-4-6`
- 分析完成后：自动切回 `videnx/gpt-5.4`
- 当 `videnx/gpt-5.4` 报错、异常或不可用时：切到 `anthropic/claude-sonnet-4-6`

### 本机（Mac）
- 不启用上述 `videnx/gpt-5.4` 规则
- 本机仍按本机已配置模型执行，不假设存在 GPT-5.4 中转
- 本机为备用 OpenClaw，不承担主力工作流
- 本机关闭所有 heartbeat
- 本机不生成每日 `trade` 交易文件
- 交易记录、交易分析文件、主工作流统一由阿里云服务器负责

### 口令映射（仅阿里云服务器生效）
- 切换chatgpt → `videnx/gpt-5.4`
- 切换opus → `anthropic/claude-opus-4-6`
- 切换sonnet → `anthropic/claude-sonnet-4-6`

## 交易 / 图表分析执行纪律

- 凡是交易、行情、图表、复盘、入场/止损/止盈建议，**不得擅自改模板、改风格、改流程**
- 必须严格沿用既有交易分析模板，不允许用普通聊天口吻替代
- 交易 / 图表分析固定流程：
  1. 切 `anthropic/claude-opus-4-6`
  2. 读 `TRADINGVIEW.md`
  3. 读 `tradingview/chan-definitions.md`
  4. 按固定模板分析
  5. 切回 `videnx/gpt-5.4`
  6. 明确告知当前已切换的模型名称
  7. 若属于当天分析，更新或创建 `memory/trade-YYYY-MM-DD.md`
  8. 如果涉及真实入场，再建 `trades/YYYY-MM-DD-HHMM-方向.md`
  9. 保存图片到 `images/YYYY-MM-DD/`
  10. 更新 daily memory（必要时）
  11. commit
  12. push
- 后续每进行一步操作，都要明确告知用户，不得省略状态播报
- `🧠 模型：Claude Opus 4.6` 只有在**真实切换到 Opus 且已开始该次分析**后才能写，不能作为固定装饰文案
- 同理，`已读取 TRADINGVIEW.md`、`已读取 chan-definitions.md`、`已切回 videnx/gpt-5.4`、`已更新日志`、`已 commit`、`已 push` 等表述，必须在**真实完成该步骤后**才能说
- 分析前必须先读 `TRADINGVIEW.md` 与 `tradingview/chan-definitions.md`，不得凭记忆直接分析
- 交易分析日志中的**分析正文**，默认以飞书当次实际发出的回复原文为准，尽量原样入档
- 如需补充审计、结果、复盘，只能在正文后追加，**不得改写原始分析正文**
- 文档中的分析内容应与飞书实际回复尽量保持一致，保证后续复盘与学习价值
- 图表分析排版统一改为：**4H图 → 4H分析 → 1H图 → 1H分析 → 15M图 → 15M分析 → 最终结论**
- 不再使用"三张图连续放在前面、分析统一堆在后面"的排版
- 图片宽度统一使用 `|1300`
- 交易分析模板、日志格式、图文结构属于风控流程的一部分，**禁止临场自由发挥**
- 每次图表分析完成后，**必须在最终回复末尾输出 12 步执行状态表**，格式如下：

```
| 步骤 | 内容 | 状态 |
|------|------|------|
| 1 | 切 Opus | |
| 2 | 读 TRADINGVIEW.md | |
| 3 | 读 chan-definitions.md | |
| 4 | 按固定模板分析 | |
| 5 | 切回 videnx/gpt-5.4 | |
| 6 | 告知当前模型名称 | |
| 7 | 更新 memory/trade-YYYY-MM-DD.md | |
| 8 | 建 trades/ 文件（如有入场） | |
| 9 | 保存图片到 images/ | |
| 10 | 更新 daily memory | |
| 11 | commit | |
| 12 | push | |
```

- 每完成一步填 ✅，不适用填 -，未完成填 ❌
- 表里有任何空格或 ❌，说明流程未完成
- **此表不可省略**
- 交易分析日志中，不同时间的分析属于不同记录，**只追加，不覆盖，不删除旧版分析**
- 即使后续有更严格的重做版本，原始版本也必须完整保留在文件中

## Git 提交信息规则

- 阿里云服务器提交时：commit message 前缀加 `[阿里云]`
- 本机（Mac）提交时：commit message 前缀加 `[本地]`
- 目的：方便区分这次更新来自哪台机器

---

Add whatever helps you do your job. This is your cheat sheet.
