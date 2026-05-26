import test from 'node:test';
import assert from 'node:assert';
import { enqueue, pendingCount } from '../src/worker.js';

test('enqueue accepte un item slack', () => {
  const before = pendingCount();
  enqueue({ channel: 'slack', message: 'hi', recipient: '#ops' });
  assert.strictEqual(pendingCount(), before + 1);
});
