# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

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
- 图片 / 行情 / 图表分析时：先切 `anthropic/claude-opus-4-6`，分析完成后自动切回 `videnx/gpt-5.4`
- 图表分析回复顶部必须带：`🧠 模型：Claude Opus 4.6`
- 分析前必须先读 `TRADINGVIEW.md` 与 `tradingview/chan-definitions.md`，不得凭记忆直接分析
- 交易分析模板、日志格式、图文结构属于风控流程的一部分，**禁止临场自由发挥**

## Git 提交信息规则

- 阿里云服务器提交时：commit message 前缀加 `[阿里云]`
- 本机（Mac）提交时：commit message 前缀加 `[本地]`
- 目的：方便区分这次更新来自哪台机器

---

Add whatever helps you do your job. This is your cheat sheet.
