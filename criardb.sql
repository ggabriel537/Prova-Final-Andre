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

-- Registros de teste

INSERT INTO vendas (id, data_venda, cliente, valor_total) VALUES
('11111111-1111-1111-1111-111111111111', '2025-01-05', 'João Silva', 58.50),
('22222222-2222-2222-2222-222222222222', '2025-01-07', 'Maria Souza', 132.00),
('33333333-3333-3333-3333-333333333333', '2025-01-09', 'Carlos Lima', 75.90),
('44444444-4444-4444-4444-444444444444', '2025-01-10', 'Fernanda Rocha', 22.00),
('55555555-5555-5555-5555-555555555555', '2025-01-12', 'Ricardo Alves', 155.00),
('66666666-6666-6666-6666-666666666666', '2025-01-15', 'Ana Oliveira', 44.50),
('77777777-7777-7777-7777-777777777777', '2025-01-17', 'Paulo Santos', 89.70),
('88888888-8888-8888-8888-888888888888', '2025-01-20', 'Juliana Costa', 210.00),
('99999999-9999-9999-9999-999999999999', '2025-01-21', 'Gabriel Torres', 32.40),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '2025-01-22', 'Beatriz Ramos', 63.00),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '2025-01-23', 'Marcelo Pires', 142.80),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '2025-01-24', 'Vanessa Martins', 118.50),
('dddddddd-dddd-dddd-dddd-dddddddddddd', '2025-01-25', 'Thiago Nunes', 34.00),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '2025-01-26', 'Lucas Mendes', 52.40),
('ffffffff-ffff-ffff-ffff-ffffffffffff', '2025-01-27', 'Patrícia Dias', 199.90),
('12121212-1212-1212-1212-121212121212', '2025-01-28', 'Felipe Rocha', 87.00),
('13131313-1313-1313-1313-131313131313', '2025-01-30', 'Carolina Barros', 67.50),
('14141414-1414-1414-1414-141414141414', '2025-02-01', 'Rodrigo Alves', 155.20),
('15151515-1515-1515-1515-151515151515', '2025-02-03', 'Renata Melo', 76.80),
('16161616-1616-1616-1616-161616161616', '2025-02-05', 'Eduardo Lima', 99.50),
('17171717-1717-1717-1717-171717171717', '2025-02-07', 'Letícia Silva', 108.20),
('18181818-1818-1818-1818-181818181818', '2025-02-09', 'Daniel Castro', 62.00),
('19191919-1919-1919-1919-191919191919', '2025-02-10', 'Alessandra Melo', 83.90),
('20202020-2020-2020-2020-202020202020', '2025-02-12', 'Henrique Duarte', 144.70),
('21212121-2121-2121-2121-212121212121', '2025-02-14', 'Bruno Henrique', 129.90);


INSERT INTO produtos_venda (venda_id, nome, valor, quantidade) VALUES
-- venda 1
('11111111-1111-1111-1111-111111111111', 'Parafuso', 2.50, 10),
('11111111-1111-1111-1111-111111111111', 'Porca', 1.50, 10),
('11111111-1111-1111-1111-111111111111', 'Arruela', 0.85, 15),

-- venda 2
('22222222-2222-2222-2222-222222222222', 'Cabo de Aço', 40.00, 2),
('22222222-2222-2222-2222-222222222222', 'Chave Philips', 12.00, 3),
('22222222-2222-2222-2222-222222222222', 'Kit Broca', 20.00, 3),

-- venda 3
('33333333-3333-3333-3333-333333333333', 'Tinta Spray', 25.90, 1),
('33333333-3333-3333-3333-333333333333', 'Lixa Grossa', 5.00, 2),
('33333333-3333-3333-3333-333333333333', 'Pincel 2"', 7.00, 3),

-- venda 4
('44444444-4444-4444-4444-444444444444', 'Cola Instantânea', 11.00, 2),
('44444444-4444-4444-4444-444444444444', 'Fita Isolante', 5.00, 2),
('44444444-4444-4444-4444-444444444444', 'Abraçadeira', 1.00, 10),

-- venda 5
('55555555-5555-5555-5555-555555555555', 'Serrote', 55.00, 1),
('55555555-5555-5555-5555-555555555555', 'Martelo', 35.00, 1),
('55555555-5555-5555-5555-555555555555', 'Trena 5m', 25.00, 2),

-- venda 6
('66666666-6666-6666-6666-666666666666', 'Broca 8mm', 8.50, 2),
('66666666-6666-6666-6666-666666666666', 'Parafuso Aço', 1.50, 10),
('66666666-6666-6666-6666-666666666666', 'Fita Dupla Face', 12.00, 1),

-- venda 7
('77777777-7777-7777-7777-777777777777', 'Chave Inglesa', 45.00, 1),
('77777777-7777-7777-7777-777777777777', 'Kit Bucha S6', 12.00, 2),
('77777777-7777-7777-7777-777777777777', 'Arame recozido', 5.90, 3),

-- venda 8
('88888888-8888-8888-8888-888888888888', 'Caixa Ferramentas', 120.00, 1),
('88888888-8888-8888-8888-888888888888', 'Extensão 5m', 45.00, 1),
('88888888-8888-8888-8888-888888888888', 'Parafuso Madeira', 1.00, 45),

-- venda 9
('99999999-9999-9999-9999-999999999999', 'Graxa Alta Temp', 12.40, 1),
('99999999-9999-9999-9999-999999999999', 'Chave Allen 6mm', 20.00, 1),
('99999999-9999-9999-9999-999999999999', 'Abraçadeira Nylon', 0.40, 25),

-- venda 10
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Parafuso Sextavado', 1.00, 30),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Arruela Pressão', 0.50, 20),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Porca M10', 1.50, 10),

-- venda 11
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Espátula Metal', 22.80, 1),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Lixa Fina', 4.00, 5),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tinta óleo 250ml', 18.00, 2),

-- venda 12
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Rolo de Pintura', 28.50, 1),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Bandeja Plástica', 12.00, 1),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Lixa 220', 4.00, 5),

-- venda 13
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Cola Madeira', 17.00, 2),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Pregos 18mm', 0.50, 30),
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Parafuso Chipboard', 1.00, 15),

-- venda 14
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Broca 10mm', 12.40, 2),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Serra Copo', 30.00, 1),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Fita Crepe', 5.00, 2),

-- venda 15
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Alicate de Corte', 40.00, 1),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Extensão 10m', 45.00, 1),
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'Parafuso Rosca Soberba', 0.90, 20),

-- venda 16
('12121212-1212-1212-1212-121212121212', 'Luva Borracha', 7.00, 4),
('12121212-1212-1212-1212-121212121212', 'Máscara PFF2', 5.00, 3),
('12121212-1212-1212-1212-121212121212', 'Óculos Proteção', 20.00, 1),

-- venda 17
('13131313-1313-1313-1313-131313131313', 'Chave Torres', 27.50, 1),
('13131313-1313-1313-1313-131313131313', 'Kit Parafusos Surtido', 15.00, 2),
('13131313-1313-1313-1313-131313131313', 'Espuma Expansiva', 25.00, 1),

-- venda 18
('14141414-1414-1414-1414-141414141414', 'Disco Corte Metal', 7.20, 5),
('14141414-1414-1414-1414-141414141414', 'Mangueira Ar', 55.00, 1),
('14141414-1414-1414-1414-141414141414', 'Fita Teflon', 3.00, 4),

-- venda 19
('15151515-1515-1515-1515-151515151515', 'Lâmpada LED 9W', 12.80, 3),
('15151515-1515-1515-1515-151515151515', 'Interruptor', 8.00, 2),
('15151515-1515-1515-1515-151515151515', 'Tomada 10A', 10.00, 2),

-- venda 20
('16161616-1616-1616-1616-161616161616', 'Chave Teste', 9.50, 1),
('16161616-1616-1616-1616-161616161616', 'Fio 2.5mm', 4.00, 10),
('16161616-1616-1616-1616-161616161616', 'Fio 4mm', 5.00, 8),

-- venda 21
('17171717-1717-1717-1717-171717171717', 'Lanterna LED', 58.20, 1),
('17171717-1717-1717-1717-171717171717', 'Pilha AA', 3.00, 8),
('17171717-1717-1717-1717-171717171717', 'Pilha AAA', 2.20, 8),

-- venda 22
('18181818-1818-1818-1818-181818181818', 'Spray Lubrificante', 18.00, 2),
('18181818-1818-1818-1818-181818181818', 'Garrafa Térmica', 26.00, 1),
('18181818-1818-1818-1818-181818181818', 'Fita Adesiva', 6.00, 3),

-- venda 23
('19191919-1919-1919-1919-191919191919', 'Chave Combinada 12mm', 18.90, 1),
('19191919-1919-1919-1919-191919191919', 'Parafuso Alumínio', 0.50, 20),
('19191919-1919-1919-1919-191919191919', 'Bucha 8mm', 0.40, 20),

-- venda 24
('20202020-2020-2020-2020-202020202020', 'Martelo Unha', 35.00, 1),
('20202020-2020-2020-2020-202020202020', 'Nível Bolha', 42.00, 1),
('20202020-2020-2020-2020-202020202020', 'Parafuso Latão', 0.70, 30),

-- venda 25
('21212121-2121-2121-2121-212121212121', 'Alicate Universal', 39.90, 1),
('21212121-2121-2121-2121-212121212121', 'Trena 3m', 22.00, 1),
('21212121-2121-2121-2121-212121212121', 'Broca 6mm', 6.00, 3);
