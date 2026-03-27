#!/usr/bin/env node
/**
 * morning-new-reminder.js
 * 每日 09:30 发飞书，提醒才为新建对话。
 * 文案由 Anthropic API 动态生成，风格固定：
 *   第一行：提醒新建对话（自然语气，不生硬）
 *   第二行：禅意祝福（愿你……）
 *   第三行：收束句（简短，有力）
 *   结尾固定：扎西德勒，吉祥如意！🪷🌿🪷
 */

const { execFileSync } = require('node:child_process');
const https = require('node:https');

const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

const PROMPT = `你是才为的私人助手。每天早上 9:30，给才为发一条飞书消息，提醒他新建对话，同时送上今天的祝福。

格式（严格遵守）：
- 第一行：提醒新建对话。语气自然，像人说话，不生硬，不说"提醒新建对话"这种标签式文案。可以有温度，有点小幽默，但不轻浮。
- 第二行：禅意祝福，以"愿你"开头，简短有力。
- 第三行：收束句，1-2句，有定力，有方向感。
- 第四行固定：扎西德勒，吉祥如意！🪷🌿🪷

注意：
- 不要用"十点了"，提醒时间是 9:30
- 不要加解释、引号、标题、markdown
- 直接输出四行纯文本，不多不少`;

function callAnthropic() {
  return new Promise((resolve, reject) => {
    const body = JSON.stringify({
      model: 'claude-sonnet-4-6',
      max_tokens: 256,
      messages: [{ role: 'user', content: PROMPT }],
    });

    const req = https.request({
      hostname: 'api.anthropic.com',
      path: '/v1/messages',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01',
      },
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const parsed = JSON.parse(data);
          const text = parsed?.content?.[0]?.text?.trim();
          resolve(text || '');
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function main() {
  let message;

  try {
    message = await callAnthropic();
  } catch (e) {
    // fallback
    message = '新对话开起来，今天从这里走。\n愿你心有定处，脚下有路。\n守住自己的方向，比一时快慢更重要。';
  }

  if (!message.includes('扎西德勒')) {
    message += '\n扎西德勒，吉祥如意！🪷🌿🪷';
  }

  message += '\n\n可直接复制切换模型：\n/model anthropic/claude-sonnet-4-6\n/model videnx/gpt-5.4\n/model anthropic/claude-opus-4-6\n/model status';

  execFileSync('openclaw', [
    'message', 'send',
    '--channel', 'feishu',
    '--target', 'user:ou_2e94f4d90060ddc13d0bd33bbd5ffa78',
    '--message', message,
  ], { stdio: 'inherit' });
}

main();
