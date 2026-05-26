const store = new Map();
let nextId = 1;

export function createTicket({ title, body, priority = 'medium', reporter }) {
  const id = String(nextId++);
  const ticket = {
    id,
    title,
    body,
    priority,
    reporter,
    createdAt: new Date().toISOString(),
  };
  store.set(id, ticket);
  return ticket;
}

export function getTicket(id) {
  return store.get(id) || null;
}

export function listTickets() {
  return Array.from(store.values());
}
