import jwt from 'jsonwebtoken';

function getSecret() {
  const s = process.env.JWT_SECRET;
  if (!s) {
    throw new Error('JWT_SECRET environment variable is required');
  }
  return s;
}

export function signToken(payload) {
  return jwt.sign(payload, getSecret(), { expiresIn: '1h' });
}

export function verifyToken(token) {
  return jwt.verify(token, getSecret());
}
