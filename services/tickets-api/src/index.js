import express from 'express';
import { createTicket, getTicket, listTickets } from './store.js';

const app = express();
app.use(express.json());

app.post('/v1/tickets', (req, res) => {
  const ticket = createTicket(req.body);
  res.status(201).json(ticket);
});

app.get('/v1/tickets/:id', (req, res) => {
  const ticket = getTicket(req.params.id);
  if (!ticket) return res.status(404).json({ error: 'not found' });
  res.json(ticket);
});

app.get('/v1/tickets', (req, res) => {
  res.json(listTickets());
});

app.get('/health', (req, res) => res.json({ status: 'ok' }));

const port = Number(process.env.PORT) || 4001;
app.listen(port, () => {
  console.log(`tickets-api listening on :${port}`);
});
