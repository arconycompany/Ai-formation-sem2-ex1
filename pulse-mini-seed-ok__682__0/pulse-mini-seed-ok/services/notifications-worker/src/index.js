import express from 'express';
import { enqueue, startWorker } from './worker.js';

const app = express();
app.use(express.json());

app.post('/v1/notifications', (req, res) => {
  const { channel, message, recipient } = req.body || {};
  if (!channel || !message) {
    return res.status(400).json({ error: 'channel and message required' });
  }
  enqueue({ channel, message, recipient });
  res.status(202).json({ queued: true });
});

app.get('/health', (req, res) => res.json({ status: 'ok' }));

startWorker();

const port = Number(process.env.PORT) || 4002;
app.listen(port, () => {
  console.log(`notifications-worker listening on :${port}`);
});
