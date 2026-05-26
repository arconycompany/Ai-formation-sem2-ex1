import Fastify from 'fastify';
import { signToken, verifyToken } from './jwt.js';

const app = Fastify({ logger: true });

app.post('/auth/login', async (req, reply) => {
  const { username, password } = req.body || {};
  if (!username || !password) {
    return reply.code(400).send({ error: 'username and password required' });
  }
  // mock auth : tout couple non-vide est accepté
  const token = signToken({ sub: username, role: 'user' });
  return { token };
});

app.get('/auth/verify', async (req, reply) => {
  const auth = req.headers.authorization;
  if (!auth?.startsWith('Bearer ')) {
    return reply.code(401).send({ error: 'missing bearer token' });
  }
  try {
    const payload = verifyToken(auth.slice(7));
    return { ok: true, payload };
  } catch {
    return reply.code(401).send({ error: 'invalid token' });
  }
});

app.get('/health', async () => ({ status: 'ok' }));

const port = Number(process.env.PORT) || 4000;
app.listen({ port, host: '0.0.0.0' }).then(() => {
  console.log(`auth-gateway listening on :${port}`);
});
