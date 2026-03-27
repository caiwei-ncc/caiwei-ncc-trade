#!/usr/bin/env node
const { execFileSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const tasksPath = path.join(__dirname, '..', 'TASKS-2026.md');
const content = fs.readFileSync(tasksPath, 'utf8');

// 提取"## 未完成"区块里的任务标题（以 "- " 开头的行，不含缩进的子行）
const unfinishedMatch = content.match(/## 未完成([\s\S]*?)(?=## |$)/);
const tasks = [];

if (unfinishedMatch) {
  const lines = unfinishedMatch[1].split('\n');
  for (const line of lines) {
    // 匹配顶层任务行（"- " 开头，不含前置空格）
    const m = line.match(/^- (.+)/);
    if (m) {
      tasks.push(m[1].trim());
    }
  }
}

if (tasks.length === 0) {
  console.log('没有未完成任务，跳过发送。');
  process.exit(0);
}

const lines = ['今天别忘了把这些事情往前推一推：', ''];
tasks.forEach((t, i) => {
  lines.push(`${i + 1}. ${t}`);
});
const msg = lines.join('\n');

execFileSync('openclaw', [
  'message', 'send',
  '--channel', 'feishu',
  '--target', 'user:ou_2e94f4d90060ddc13d0bd33bbd5ffa78',
  '--message', msg,
], { stdio: 'inherit' });
