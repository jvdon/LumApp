INSERT INTO carros(
        placa,
        cliente,
        color,
        marca,
        modelo,
        ano,
        vendido,
        valor,
        debitos
    )
VALUES (
        'ABC1D34',
        'Thiago',
        'PRETO',
        'FIAT',
        'Uno',
        2010,
        false,
        2600.0,
        '[{"tipoDebito":"IPVA","valor":2600.0},{"tipoDebito":"MULTA","valor":500.0}]'
    )