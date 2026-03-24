#!/usr/bin/env node
const { execFileSync } = require('node:child_process');

const msg = [
  '今天别忘了把这些事情往前推一推：',
  '',
  '1. 走通阿里云服务器单独截取 15MIN 图',
  '2. 走通根据金蝉的分析自动设置时间提醒',
  '3. 走通阿里云自动设置价格提醒',
  '4. 走通飞书消息提醒（Push）',
  '5. 给香港云服务器切换为 chatgpt5.4（此前为 minimax）',
  '6. 总结缠论 108 课剩余文档并上传到云空间（当前只到 72 课）',
  '7. 建立腾讯股票的禅林分析体系，作为后续股票做 T 的基础',
  '8. 为 Claude 账号充值 100 美金',
  '9. 尝试走通 Obsidian 在手机端查看电脑端 Git 工程文件的方式',
].join('\n');

execFileSync('openclaw', ['message', 'send', '--channel', 'feishu', '--target', 'user:ou_2e94f4d90060ddc13d0bd33bbd5ffa78', '--message', msg], {
  stdio: 'inherit',
});
