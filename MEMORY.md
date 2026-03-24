# MEMORY.md — 长期记忆（精华提炼）

> 每周更新一次。日常对话只读这个文件，不遍历 memory/ 目录。
> 需要查历史细节时再去读具体的 memory/YYYY-MM-DD.md。

---

## 基础设施架构（2026-03-22 完成，2026-03-23 补全）

- **双端部署**：OpenClaw 同时运行在 Mac（本机，连飞书）和阿里云服务器
- **阿里云服务器**：Ubuntu 22.04，hostname `iZmj7cqb1nl6lp5rzrhhpgZ`
- **代理**：阿里云服务器部署 sing-box，出站走韩国干净 IP（203.248.81.252:7778），飞书直连
- **同步**：workspace 通过 GitHub（caiwei-ncc/caiwei-ncc-trade）双端同步，Mac ↔ GitHub ↔ 阿里云
- **heartbeat**：1小时一次（已从30分钟改为1小时）
- **每日9点**：cron job 自动发飞书开盘问候，提醒 /new

## 关于用户

- 飞书 ID：ou_07cb51b84b10cd7859115a46a54cf71b
- 交易账户：Dukascopy Bank，GBP/USD 日内交易，实验账户
- 股票账户：A股，约 400 万人民币（主账户，未使用缠论）
- 目标：用外汇小账户验证缠论方法论，跑通后迁移到股票账户
- Claude 账号（ncc.caiwei@gmail.com）被封，申诉表单已于 2026-03-20 填写提交
  - Anthropic 确认是 Safeguards 团队封禁，客服无权处理，需等待 Safeguards 审查（预计数天至数周）
  - 已有两个账号被封，计划用新邮箱注册 API 账号继续使用
  - **API（console.anthropic.com）目前仍可正常使用，OpenClaw 走 API 路径不受影响**

---

## 工作区关键文件

| 文件 | 作用 |
|------|------|
| `TRADINGVIEW.md` | 缠论 GBP/USD 分析协议（自动加载，勿覆盖） |
| `tradingview/chan-definitions.md` | 缠论形式化定义手册（每次分析前必须 read） |
| `tradingview/audit-checklist.md` | 分析审计清单（用户说"审计"时 read） |
| `tradingview/chan-theory-lessons-*.md` | 原始课程文档（按需 read） |
| `memory/YYYY-MM-DD.md` | 每日交易记录 |

---

## 账户状态（最近更新：2026-03-20）

- 净值：**$5,749**
- 最大单笔亏损：**$229.96**（4%）
- 连续亏损计数：1天（2026-03-20）
- 规则：连续2天亏损 → 第3天强制观望

---

## 核心教训（已写入 TRADINGVIEW.md）

1. **入场价敏感性**：入场价偏差 ≥5 点，必须重新计算手数。建议入场时同步说明"如果入场价高于X，手数减至Y"
2. **风控优先于机会**：今日实际风险 $409（6.8%），超出限额仍选择持仓 → 止损 $421。规则存在的意义是拦住这种决定
3. **指标买卖点标签不可引用**：Chan Theory 指标的 1买/2买/3卖等标注不得作为分析依据，必须自行推导
4. **背驰分场景**：截图只能视觉判断，有数值才能精确比较
5. **分析协议必须严格遵循**（2026-03-23）：看到图表不能直接分析，必须先读取 TRADINGVIEW.md 和 chan-definitions.md，按既定流程执行。临时发挥会导致分析混乱、数字错误、逻辑自相矛盾

---

## 代理 IP（防封号用）

- 购买了一个干净 IP 代理，用于阿里云服务器出站流量，防止 Claude/API 封号
- 格式：`IP:PORT:USER:PASS`
- 地址：`203.248.81.252:7778:X5Z6S9A3z8y3:d0A4S3W4v3U3`
- 过期：**2026年4月19日 18:40:41**
- 协议：待确认（SOCKS5 或 HTTP）

---

## 交易日志格式（已确认）

- 单笔成交：`trades/YYYY-MM-DD-HHMM-方向.md`
- 每日分析：`memory/trade-YYYY-MM-DD.md`
- 图片：`images/YYYY-MM-DD/chart_xxx.jpg`，MD 里用 `|960` 统一宽度
- 风格：简洁，无表格，无彩色块，参考 `trades/2026-03-23-demo-short.md`

---

## 工具与设置

- 模型：Sonnet（日常）/ Opus（图表分析，分析后自动切回）
- **切换模型必须用正确字符串**：Sonnet = `anthropic/claude-sonnet-4-6`，Opus = `anthropic/claude-opus-4-6`（不带日期后缀！带日期后缀会调用旧版本，价格更贵）
- 图表分析回复顶部必须标注：`🧠 模型：Claude Opus 4.6`
- compaction targetRatio：0.3（已写入 openclaw.json）
- Chan Theory 指标：¥300/月，下个月到期，暂定不续费
- 指标设置：严格包含-STRICT + 严格延续-STRICT + 宽笔-LOOSE

### OpenClaw 双端部署
- **Mac（本机）**：主实例，连接飞书，日常使用
- **阿里云服务器**（iZmj7cqb1nl6lp5rzrhhpgZ）：备用实例，独立部署
- workspace 通过 GitHub 仓库（caiwei-ncc/caiwei-ncc-trade）同步
- 阿里云配置 sing-box 代理，出口 IP：203.248.81.252:7778
- **模型切换规则按主机区分**：阿里云服务器默认用 `videnx/gpt-5.4`，图片/行情/图表分析切 `opus`，5.4 报错时用 `sonnet`；本机（Mac）不启用这套 5.4 规则
- **Git 提交标记规则**：阿里云提交前缀 `[阿里云]`，本地提交前缀 `[本地]`

---

## 周期复盘记录

| 日期 | 盈亏 | 净值 | 备注 |
|------|------|------|------|
| 2026-03-20 | -$421 | $5,749 | 入场价偏差，风控超标，止损出局 |
