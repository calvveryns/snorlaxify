CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    identifier TEXT UNIQUE NOT NULL,
    "typeIdentifier" TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO items (identifier, "typeIdentifier") VALUES
    -- Группа 1: Минеральная вода (дубликаты)
    ('Минеральная вода', 'item'),
    ('Мин.вода', 'item'),
    ('Вода минеральная', 'item'),
    
    -- Группа 2: Бумага офисная (дубликаты)
    ('Бумага офисная А4', 'item'),
    ('Бумага оф. А4', 'item'),
    
    -- Группа 3: Цемент (дубликаты)
    ('Цемент портландский М500', 'item'),
    ('ПЦ М500', 'item'),
    
    -- Уникальные товары
    ('Молоко пастеризованное 3.2%', 'item'),
    ('Сок апельсиновый 1л', 'item'),
    ('Хлеб пшеничный нарезной', 'item'),
    ('Масло сливочное 82.5%', 'item'),
    ('Сахар-песок 1кг', 'item'),
    ('Мука пшеничная высший сорт 2кг', 'item'),
    ('Соль поваренная пищевая йодированная', 'item'),
    ('Ручка шариковая синяя', 'item'),
    ('Карандаш простой HB', 'item'),
    ('Тетрадь 48 листов клетка', 'item'),
    ('Кирпич керамический красный', 'item'),
    ('Песок строительный речной', 'item'),
    ('Щебень гранитный 5-20мм', 'item'),
    ('Гипсокартон 12.5мм 2500х1200', 'item'),
    ('Краска водоэмульсионная белая 10л', 'item'),
    ('Шприц одноразовый 5мл', 'item'),
    ('Бинт марлевый стерильный 5м', 'item'),
    ('Перчатки медицинские латексные размер M', 'item'),
    ('Маска медицинская одноразовая', 'item'),
    ('Кабель ВВГ 3х2.5', 'item'),
    ('Лампа светодиодная 10Вт E27', 'item'),
    ('Розетка с заземлением белая', 'item'),
    ('Выключатель одноклавишный', 'item'),
    ('Масло моторное 5W-40 синтетика 4л', 'item'),
    ('Фильтр масляный', 'item'),
    ('Свечи зажигания комплект 4шт', 'item'),
    ('Антифриз красный -40C 5л', 'item'),
    ('Порошок стиральный автомат 3кг', 'item'),
    ('Средство для мытья посуды 500мл', 'item'),
    ('Мыло хозяйственное 72% 200г', 'item'),
    ('Туалетная бумага 2-слойная 4 рулона', 'item'),
    ('Отвертка крестовая PH2 150мм', 'item'),
    ('Молоток слесарный 500г', 'item'),
    ('Плоскогубцы 200мм', 'item'),
    ('Рулетка измерительная 5м', 'item')
ON CONFLICT (identifier) DO NOTHING;

CREATE TABLE IF NOT EXISTS vector_data (
    id SERIAL PRIMARY KEY,
    identifier TEXT UNIQUE NOT NULL,
    vector vector(768) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_items_type ON items("typeIdentifier");
CREATE INDEX IF NOT EXISTS idx_items_identifier ON items(identifier);
CREATE INDEX IF NOT EXISTS idx_vector_data_identifier ON vector_data(identifier);