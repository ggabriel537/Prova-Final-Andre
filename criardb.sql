CREATE DATABASE vendasdb;

\c vendasdb;

CREATE TABLE vendas (
    id UUID PRIMARY KEY,
    data_venda DATE NOT NULL,
    cliente TEXT NOT NULL,
    valor_total NUMERIC(12,2) NOT NULL
);

CREATE TABLE produtos_venda (
    id SERIAL PRIMARY KEY,
    venda_id UUID REFERENCES vendas(id) ON DELETE CASCADE,
    nome TEXT NOT NULL,
    valor NUMERIC(12,2) NOT NULL,
    quantidade INT NOT NULL
);
