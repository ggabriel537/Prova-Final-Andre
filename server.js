// server.js
const express = require('express');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const cors = require('cors');

const app = express();
const DATA_FILE = path.join(__dirname, 'sales.json');

app.use(express.json());
app.use(cors());
app.use(express.static(path.join(__dirname, 'public')));

// === MÉTRICAS PROMETHEUS ===
const client = require('prom-client');

// Habilita coleta padrão (CPU, memória, event loop, etc.)
client.collectDefaultMetrics();

// Métrica: total de requisições por método e rota
const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total de requisições HTTP',
  labelNames: ['method', 'route', 'status']
});

// Métrica: histograma de duração das requisições
const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duração das requisições HTTP em segundos',
  labelNames: ['method', 'route', 'status'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.3, 0.5, 1, 3, 5]
});

// Middleware para medir requisições
app.use((req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const route = req.route?.path || req.path;
    const status = res.statusCode;

    httpRequestCounter.inc({
      method: req.method,
      route,
      status
    });

    httpRequestDuration.observe(
      {
        method: req.method,
        route,
        status
      },
      (Date.now() - start) / 1000
    );
  });

  next();
});

// Endpoint /metrics
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  } catch (err) {
    res.status(500).end(err);
  }
});


// util: read/write JSON file
function readData() {
  try {
    const raw = fs.readFileSync(DATA_FILE, 'utf8');
    return JSON.parse(raw || '[]');
  } catch (e) {
    return [];
  }
}
function writeData(data) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), 'utf8');
}

// calcula total a partir dos produtos
function calculaValorTotal(produtosVenda) {
  if (!Array.isArray(produtosVenda)) return 0;
  return produtosVenda.reduce((acc, pv) => {
    const valor = Number(pv?.produto?.valor || 0);
    const qtd = Number(pv?.quantidade || 0);
    return acc + valor * qtd;
  }, 0);
}

// endpoints
const pool = require('./db');
app.get('/api/sales', async (req, res) => {
  try {
    const vendas = await pool.query(`SELECT * FROM vendas`);

    for (let v of vendas.rows) {

      const prods = await pool.query(
        `SELECT * FROM produtos_venda WHERE venda_id = $1`,
        [v.id]
      );

      v.produtos = prods.rows;
    }

    res.json(vendas.rows);
  } catch (e) {
    console.error("ERRO:", e);   // debug
    res.status(500).json({ error: e.message });
  }
});



app.get('/api/sales/:id', async (req, res) => {
  try {
    const venda = await pool.query(
      `SELECT * FROM vendas WHERE id = $1`,
      [req.params.id]
    );

    if (venda.rowCount === 0) {
      return res.status(404).json({ error: 'Venda não encontrada' });
    }

    const produtos = await pool.query(
      `SELECT nome, valor, quantidade FROM produtos_venda WHERE venda_id = $1`,
      [req.params.id]
    );

    venda.rows[0].produtos = produtos.rows;
    res.json(venda.rows[0]);

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


app.post('/api/sales', async (req, res) => {
  try {
    const { dataVenda, cliente, produtos } = req.body;

    if (!dataVenda || !cliente || !Array.isArray(produtos)) {
      return res.status(400).json({ error: 'Campos obrigatórios: dataVenda, cliente, produtos' });
    }

    const valorTotal = calculaValorTotal(produtos);
    const id = uuidv4();

    await pool.query(
      `INSERT INTO vendas (id, data_venda, cliente, valor_total)
       VALUES ($1, $2, $3, $4)`,
      [id, dataVenda, cliente, valorTotal]
    );

    for (const p of produtos) {
      await pool.query(
        `INSERT INTO produtos_venda (venda_id, nome, valor, quantidade)
         VALUES ($1, $2, $3, $4)`,
        [id, p.produto.nome, p.produto.valor, p.quantidade]
      );
    }

    res.status(201).json({ id, dataVenda, cliente, produtos, valorTotal });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


app.put('/api/sales/:id', async (req, res) => {
  try {
    const { dataVenda, cliente, produtos } = req.body;
    const id = req.params.id;

    const venda = await pool.query(`SELECT * FROM vendas WHERE id = $1`, [id]);
    if (venda.rowCount === 0) {
      return res.status(404).json({ error: 'Venda não encontrada' });
    }

    const valorTotal = calculaValorTotal(produtos);

    await pool.query(
      `UPDATE vendas SET data_venda=$1, cliente=$2, valor_total=$3 WHERE id=$4`,
      [dataVenda, cliente, valorTotal, id]
    );

    // Apagar produtos antigos
    await pool.query(`DELETE FROM produtos_venda WHERE venda_id = $1`, [id]);

    // Inserir novos
    for (const p of produtos) {
      await pool.query(
        `INSERT INTO produtos_venda (venda_id, nome, valor, quantidade)
         VALUES ($1, $2, $3, $4)`,
        [id, p.produto.nome, p.produto.valor, p.quantidade]
      );
    }

    res.json({ id, dataVenda, cliente, produtos, valorTotal });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


app.delete('/api/sales/:id', async (req, res) => {
  try {
    const id = req.params.id;

    const result = await pool.query(
      `DELETE FROM vendas WHERE id = $1`,
      [id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Venda não encontrada' });
    }

    res.json({ success: true });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// fallback: serve index.html for SPA
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor rodando em http://localhost:${PORT}`));
