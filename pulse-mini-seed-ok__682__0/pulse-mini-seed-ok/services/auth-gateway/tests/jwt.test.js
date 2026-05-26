import test from 'node:test';
import assert from 'node:assert';
import { signToken, verifyToken } from '../src/jwt.js';

process.env.JWT_SECRET = process.env.JWT_SECRET || 'test-only-secret-not-for-prod';

test('signToken produit un token vérifiable', () => {
  const token = signToken({ sub: 'alice' });
  const decoded = verifyToken(token);
  assert.strictEqual(decoded.sub, 'alice');
});

test('verifyToken lève une erreur sur un token invalide', () => {
  assert.throws(() => verifyToken('not-a-token'));
});
