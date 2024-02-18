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
    anoMod NUMBER,
    anoFab NUMBER,
    vendido BOOLEAN,
    valor FLOAT,
    debitos TEXT DEFAULT "[]"
);