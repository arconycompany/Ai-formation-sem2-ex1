import test from 'node:test';
import assert from 'node:assert';
import { createTicket, getTicket, listTickets } from '../src/store.js';

test('createTicket assigne id et createdAt', () => {
  const t = createTicket({ title: 'foo', body: 'bar', reporter: 'alice' });
  assert.ok(t.id);
  assert.ok(t.createdAt);
  assert.strictEqual(t.title, 'foo');
  assert.strictEqual(t.priority, 'medium');
});

test('getTicket retrouve un ticket stocké', () => {
  const t = createTicket({ title: 'baz', reporter: 'bob' });
  assert.strictEqual(getTicket(t.id).title, 'baz');
});

test('getTicket retourne null pour un id inconnu', () => {
  assert.strictEqual(getTicket('999999'), null);
});

test('listTickets retourne un tableau', () => {
  const list = listTickets();
  assert.ok(Array.isArray(list));
});
