CREATE TABLE IF NOT EXISTS carros (
    id INTEGER PRIMARY KEY,
    cliente TEXT,
    placaBR VARCHAR(7) UNIQUE,
    placaMS VARCHAR(7) UNIQUE,
    color TEXT,
    marca TEXT,
    modelo TEXT,
    ano NUMBER,
    vendido BOOLEAN,
    valor FLOAT,
    debitos TEXT DEFAULT "[]"
);

CREATE TABLE IF NOT EXISTS clientes (
    nome TEXT,
    CPF TEXT  PRIMARY KEY,
    telefone TEXT,
    endereco TEXT
);