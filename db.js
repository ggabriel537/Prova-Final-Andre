const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'postgres',
  database: 'vendasdb',
  password: 'sisgea123',
  port: 5432
});

module.exports = pool;
