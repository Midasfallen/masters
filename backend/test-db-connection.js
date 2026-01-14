const { Client } = require('pg');

const config = {
  host: 'localhost',
  port: 5433,
  user: 'service_user',
  password: 'service_password',
  database: 'service_db',
};

console.log('Connection config:', config);

const client = new Client(config);

async function testConnection() {
  try {
    console.log('Attempting to connect...');
    await client.connect();
    console.log('✅ Connected successfully!');

    const res = await client.query('SELECT version();');
    console.log('PostgreSQL version:', res.rows[0].version);

    await client.end();
    console.log('Connection closed');
  } catch (err) {
    console.error('❌ Connection failed:', err.message);
    console.error('Full error:', err);
    process.exit(1);
  }
}

testConnection();
