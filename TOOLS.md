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

### 模型能力顺序与统一规则（阿里云服务器）
- 能力顺序统一为：`anthropic/claude-opus-4-6` > `videnx/gpt-5.4` > `anthropic/claude-sonnet-4-6`
- 聊天主模型与图片工具模型，默认按同一顺序理解与播报
- 默认主力模型：`videnx/gpt-5.4`
- 高质量交易 / 图表 / 行情 / 复盘 / 审计分析：切到 `anthropic/claude-opus-4-6`
- 当 `videnx/gpt-5.4` 异常、不可用、超时或表现失常时：切到 `anthropic/claude-sonnet-4-6`
- 图片工具若发生模型切换，必须明确告知用户；不得静默 fallback 到未约定模型
- 交易场景优先保证时效性：若某模型失败或等待过久，应尽快切换到下一档，并如实播报

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
- **用了什么模型就写什么模型，切了模型也必须明确告诉用户**
- 若图片工具与聊天主模型发生切换，必须分别播报“当前聊天主模型”和“当前图片工具模型”
- 若本次分析过程中发生模型切换、工具链 fallback、图片工具独立调用其他模型（如 Opus 4.5 / 其他模型），必须如实说明；不得把“当前会话模型”偷换成“整条分析链路唯一模型”
- 若只切了会话模型，但图片分析 / 其他工具链实际使用了不同模型，必须区分表述，例如：`分析会话模型`、`图片工具链模型`，不得笼统写成“本次分析模型就是 X”
- 只有在**分析正文确实由该模型直接完成，且中途没有其他模型 fallback 污染表述**时，才可以把顶部模型标注理解为本次分析主模型；否则必须补充说明链路中的其他模型
- 同理，`已读取 TRADINGVIEW.md`、`已读取 chan-definitions.md`、`已切回 videnx/gpt-5.4`、`已更新日志`、`已 commit`、`已 push` 等表述，必须在**真实完成该步骤后**才能说
- 分析前必须先读 `TRADINGVIEW.md` 与 `tradingview/chan-definitions.md`，不得凭记忆直接分析
- 交易分析日志中的**分析正文**，默认以飞书当次实际发出的回复原文为准，尽量原样入档
- 如需补充审计、结果、复盘，只能在正文后追加，**不得改写原始分析正文**
- 文档中的分析内容应与飞书实际回复尽量保持一致，保证后续复盘与学习价值
- 图片宽度统一使用 `|1300`
- 图表分析日志固定结构模板如下，**每次必须严格按此结构输出，不得合并或嵌套**：

```
## 第X次分析（HH:MM）

### 4H 图
（图片）

### 4H 分析
（bullet 列表：分型、笔、线段、中枢、走势类型、背驰、结论）

### 1H 图
（图片）

### 1H 分析
（bullet 列表：分型、笔、线段、中枢、当前价格vs中枢、三买判断、背驰、结论）

### 15M 图
（图片）

### 15M 分析
（bullet 列表：分型、笔、线段、中枢、买卖点、背驰、区间套、多义性）

### 最终结论
（独立标题，不塞在 15M 分析里）

### 关键观察位
（独立标题，不塞在 15M 分析里）
```
- 交易分析模板、日志格式、图文结构属于风控流程的一部分，**禁止临场自由发挥**
- 每次图表分析完成后，**必须在最后只发 1 条完整成品消息**；不得拆成“分析正文一条 + 状态更新一条”分开发送，避免飞书侧只显示后一条、导致前面正文丢失、折叠或不可见
- 这条最终成品消息必须一次性包含：分析正文 + 12 步执行状态表；除非内容长度已明显接近发送风险，否则不得默认改为多条拆发
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

## "开启会话"口令

当用户说"开启会话"时，执行以下流程：
1. 检查今天的 memory 有没有需要补记的内容
2. 如果有，写入 memory/YYYY-MM-DD.md
3. commit + push
4. 回复用户："已保存完毕，请发 `/new`"

用户发 `/new` 后新会话自动开始，workspace 文件会重新加载，规则不会丢失。

## Daily Memory 落盘执行条款

### 核心原则
- `memory/YYYY-MM-DD.md` 不是会自动增长的系统日志，必须由助手主动维护
- 只要本轮对话产出可复用信息，助手必须判断是否需要落盘；**宁可多记一条，也不要漏记一条**
- 凡是已经在对话里说成“已确认 / 已完成 / 结论 / 规则 / 更新”的内容，默认都要检查是否应写入 `memory/YYYY-MM-DD.md`

### 必须落盘的 5 类内容
出现以下任一类内容，必须在**本回合或下一回合**写入 `memory/YYYY-MM-DD.md`，不得只停留在聊天回复里：

1. **明确事实**
   - 新确认的客观信息
   - 典型特征：数字、时间、价格、盈亏、净值、仓位、文件路径、模型名、配置值
   - 例：`账户净值更新为 $5,584.40`、`入场价 1.33311`

2. **明确规则**
   - 对以后行为的约束、要求、禁止、统一格式、固定流程
   - 典型特征：`必须`、`不得`、`统一`、`固定`、`以后`、`每次`
   - 例：`图片宽度统一 |1300`、`图表分析必须先读 TRADINGVIEW.md`

3. **明确判断**
   - 已形成结论的分析结果、因果判断、做/不做结论
   - 典型特征：`成立` / `不成立`、`做` / `不做`、`原因是`、`结论是`
   - 例：`今天不做`、`1H 三买不成立`、`昨晚 token 高主要是 heartbeat + 大上下文`

4. **明确完成动作**
   - 已经实际完成的创建、修改、切换、保存、归档、更新动作
   - 典型特征：`已`、`已经`、`完成`、`创建`、`更新`、`切换`、`保存`、`补建`
   - 例：`已创建 trades 文件`、`已切换到 videnx/gpt-5.4`

5. **用户明确要求记录**
   - 用户说“记住这个 / 记一下 / 写到 memory / 总结一下今天 / 更新长期记忆”
   - 这类不再判断重要性，直接落盘

### 不得延后到遗忘
- 助手不得把“先回复，等会儿一起写”当成默认策略
- 如果一条回复里已经出现上述 5 类内容，必须在**紧邻的后续操作**中完成落盘
- 若因当下还有连续多步操作，最迟也必须在**该小任务结束时**完成落盘

### 回复与落盘绑定规则
- 凡是回复中使用以下措辞之一，必须同步检查并执行落盘：
  - `已确认`
  - `结论`
  - `规则`
  - `已更新`
  - `已补记`
  - `已创建`
  - `已切换`
  - `已保存`
  - `已完成`
- 禁止出现“聊天里说已经确认/完成，但 memory 文件未更新”的断裂状态

### 写入确认规则（新增）
- 凡是涉及 `memory/YYYY-MM-DD.md`、`MEMORY.md`、规则文件（如 `TOOLS.md`、`TRADINGVIEW.md`）的更新，**不得只凭印象或口头确认**
- 标准流程固定为：**写入 → 回读 → 摘录确认**
- 只有在真实 `read` 到更新后的文件内容，并能给出新增原文、关键片段或明确位置后，才能使用：
  - `已更新`
  - `已记录`
  - `已补记`
  - `已写入`
  - `文件里已经有`
- 如果尚未回读核对，一律按**未完成确认**处理，不得使用上述确定性措辞
- 对 daily memory，优先直接贴出刚写入的新增条目，避免用“已经有了”“已经记了”这类不可核对表述

### 交易场景附加条款
- 图表分析：除写 `memory/trade-YYYY-MM-DD.md` 外，当天的 `memory/YYYY-MM-DD.md` 也必须记录“今天进行了第几次分析、结论是什么、是否更新了规则/图片/文件”
- 真实入场：除写 `trades/YYYY-MM-DD-HHMM-方向.md` 外，当天的 `memory/YYYY-MM-DD.md` 也必须记录“何时入场、方向、关键价格、当前是否缺结果信息”
- 配置调整：模型、heartbeat、主机分工、Git 规则等改动，除必要时写 `MEMORY.md` 外，当天 daily memory 必须先记一份

### 失败判定
出现以下任一情况，视为 daily memory 维护失败：
- 已在聊天中总结出新信息，但未写入 `memory/YYYY-MM-DD.md`
- 已说“已更新 / 已补记 / 已确认”，但文件实际未变
- 当天结束时，`memory/YYYY-MM-DD.md` 无法反映今天已完成的重要工作

### 执行偏好
- 以**追加**为默认，不随意覆盖当天已有内容
- 先保证写进去，再考虑整理措辞
- 对 daily memory：**完整性优先于优雅性**

## Git 提交信息规则

- 阿里云服务器提交时：commit message 前缀加 `[阿里云]`
- 本机（Mac）提交时：commit message 前缀加 `[本地]`
- 目的：方便区分这次更新来自哪台机器

---

Add whatever helps you do your job. This is your cheat sheet.
