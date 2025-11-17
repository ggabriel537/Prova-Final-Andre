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
app.get('/api/sales', (req, res) => {
  const sales = readData();
  res.json(sales);
});

app.get('/api/sales/:id', (req, res) => {
  const id = req.params.id;
  const sales = readData();
  const found = sales.find(s => s.id === id);
  if (!found) return res.status(404).json({ error: 'Venda não encontrada' });
  res.json(found);
});

app.post('/api/sales', (req, res) => {
  const body = req.body;

  // validação básica
  if (!body.dataVenda || !body.cliente || !Array.isArray(body.produtos)) {
    return res.status(400).json({ error: 'Campos obrigatórios: dataVenda, cliente, produtos' });
  }

  const valorTotal = calculaValorTotal(body.produtos);

  const sale = {
    id: uuidv4(),
    dataVenda: body.dataVenda, // esperar ISO string ou yyyy-mm-dd
    cliente: body.cliente,
    produtos: body.produtos.map(pv => ({
      produto: {
        nome: String(pv.produto?.nome || '').trim(),
        valor: Number(pv.produto?.valor || 0)
      },
      quantidade: Number(pv.quantidade || 0)
    })),
    valorTotal: Number(valorTotal)
  };

  const sales = readData();
  sales.unshift(sale); // mais recente primeiro
  writeData(sales);

  res.status(201).json(sale);
});

app.put('/api/sales/:id', (req, res) => {
  const id = req.params.id;
  const body = req.body;
  const sales = readData();
  const idx = sales.findIndex(s => s.id === id);
  if (idx === -1) return res.status(404).json({ error: 'Venda não encontrada' });

  const valorTotal = calculaValorTotal(body.produtos);

  const updated = {
    ...sales[idx],
    dataVenda: body.dataVenda || sales[idx].dataVenda,
    cliente: body.cliente || sales[idx].cliente,
    produtos: Array.isArray(body.produtos) ? body.produtos.map(pv => ({
      produto: {
        nome: String(pv.produto?.nome || '').trim(),
        valor: Number(pv.produto?.valor || 0)
      },
      quantidade: Number(pv.quantidade || 0)
    })) : sales[idx].produtos,
    valorTotal: Number(valorTotal)
  };

  sales[idx] = updated;
  writeData(sales);
  res.json(updated);
});

app.delete('/api/sales/:id', (req, res) => {
  const id = req.params.id;
  let sales = readData();
  const origLen = sales.length;
  sales = sales.filter(s => s.id !== id);
  if (sales.length === origLen) return res.status(404).json({ error: 'Venda não encontrada' });
  writeData(sales);
  res.json({ success: true });
});

// fallback: serve index.html for SPA
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor rodando em http://localhost:${PORT}`));
