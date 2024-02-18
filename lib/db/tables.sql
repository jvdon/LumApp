CREATE TABLE IF NOT EXISTS carros (
    id INTEGER PRIMARY KEY,
    cliente TEXT,
    placa TEXT UNIQUE,
    renavam TEXT,
    chassi TEXT,
    dataVenda INTEGER,
    tipo TEXT,
    color TEXT,
    marca TEXT,
    modelo TEXT,
    ano NUMBER,
    vendido BOOLEAN,
    valor FLOAT,
    debitos TEXT DEFAULT "[]"
);

CREATE TABLE IF NOT EXISTS clientes (
    nome TEXT PRIMARY KEY,
    CPF TEXT,
    telefone TEXT,
    endereco TEXT
);