/**
 * Set GitHub Actions secrets via API (no gh CLI required).
 * Usage: node tools/set_github_secrets_api.js
 * Env: GH_TOKEN (PAT with repo scope)
 */
const https = require('https');
const sodium = require('tweetsodium');

const OWNER = 'Pavelcrypto70';
const REPO = 'trading_education_app';
const TOKEN = process.env.GH_TOKEN;

const SECRETS = {
  PAGES_DEPLOY_TOKEN: process.env.PAGES_DEPLOY_TOKEN || TOKEN,
  SUPABASE_URL: 'https://akwiexmyblpuckvbqjsd.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_FL4lJ9uRe-S2FNw2bdD9fA_7fwI0NvQ',
  SUPABASE_PROJECT_REF: 'akwiexmyblpuckvbqjsd',
  SUPABASE_ACCESS_TOKEN: process.env.SUPABASE_ACCESS_TOKEN || '',
};

function request(method, path, body) {
  return new Promise((resolve, reject) => {
    const data = body ? JSON.stringify(body) : null;
    const req = https.request(
      {
        hostname: 'api.github.com',
        path,
        method,
        headers: {
          Authorization: `token ${TOKEN}`,
          Accept: 'application/vnd.github+json',
          'User-Agent': 'trade-master-setup',
          ...(data ? { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) } : {}),
        },
      },
      (res) => {
        let raw = '';
        res.on('data', (c) => (raw += c));
        res.on('end', () => {
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(raw ? JSON.parse(raw) : {});
          } else {
            reject(new Error(`${method} ${path} -> ${res.statusCode}: ${raw}`));
          }
        });
      }
    );
    req.on('error', reject);
    if (data) req.write(data);
    req.end();
  });
}

function encrypt(secret, publicKey) {
  const key = Buffer.from(publicKey, 'base64');
  const messageBytes = Buffer.from(secret);
  const encryptedBytes = sodium.seal(messageBytes, key);
  return Buffer.from(encryptedBytes).toString('base64');
}

async function setSecret(name, value) {
  if (!value) {
    console.log(`skip ${name} (empty)`);
    return;
  }
  const { key, key_id } = await request(
    'GET',
    `/repos/${OWNER}/${REPO}/actions/secrets/public-key`
  );
  const encrypted_value = encrypt(value, key);
  await request('PUT', `/repos/${OWNER}/${REPO}/actions/secrets/${name}`, {
    encrypted_value,
    key_id,
  });
  console.log(`ok ${name}`);
}

async function main() {
  if (!TOKEN) throw new Error('GH_TOKEN required');
  for (const [name, value] of Object.entries(SECRETS)) {
    await setSecret(name, value);
  }
  const list = await request('GET', `/repos/${OWNER}/${REPO}/actions/secrets?per_page=20`);
  console.log('secrets:', list.secrets.map((s) => s.name).join(', '));
}

main().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
