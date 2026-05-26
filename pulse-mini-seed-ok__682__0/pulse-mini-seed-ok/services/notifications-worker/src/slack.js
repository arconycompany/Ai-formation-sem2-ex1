export async function sendToSlack(message, recipient = '#ops') {
  const webhook = process.env.SLACK_WEBHOOK_URL;
  if (!webhook) {
    console.warn('[slack] SLACK_WEBHOOK_URL not set, skipping send');
    return { ok: false, reason: 'no webhook configured' };
  }
  // mock : on ne tape pas Slack en vrai dans le seed
  return { ok: true, recipient, len: message.length };
}
