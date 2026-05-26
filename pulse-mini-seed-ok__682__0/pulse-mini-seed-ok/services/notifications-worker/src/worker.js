import { sendToSlack } from './slack.js';

const queue = [];

export function enqueue(item) {
  queue.push(item);
}

export function pendingCount() {
  return queue.length;
}

export function startWorker({ intervalMs = 1000 } = {}) {
  return setInterval(async () => {
    while (queue.length) {
      const item = queue.shift();
      if (item.channel === 'slack') {
        await sendToSlack(item.message, item.recipient);
      }
    }
  }, intervalMs);
}
