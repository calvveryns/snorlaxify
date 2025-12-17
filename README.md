# Snorlaxify

## Общее описание

Система предназначена для поиска, анализа и предотвращения дубликатов в справочниках (НСИ, мастер‑данные) с использованием векторных представлений и локально развёрнутой языковой модели. Решение поддерживает как пакетную дедупликацию больших массивов данных, так и онлайн‑проверку единичных сущностей через API, в том числе при интеграции с OpenPIM.​
## Архитектура

### Основные компоненты:

- Хранилище данных (PostgreSQL + pgvector) — хранение НСИ и эмбеддингов, HNSW‑индекс для поиска ближайших соседей.​
- ML‑модель эмбеддингов — формирует векторные представления записей и записывает их в хранилище.​
- Языковая модель (Qwen) — по списку близких пар генерирует оценки вероятности дубликата и рекомендуемое master‑имя.​
- Backend (FastAPI) — REST API для запуска пайплайнов, онлайн‑проверок и работы с результатами.​
- Веб‑приложение — интерфейс аналитика для мониторинга процессов и анализа найденных дубликатов.​
### Пайплайн пакетной дедупликации

Пакетный процесс запускается через API и проходит следующие шаги:
- Загрузка исходных записей из целевых таблиц.​
- Векторизация объектов и сохранение эмбеддингов в pgvector.​
- Поиск близких пар методом get_close_pairs (косинусное расстояние, HNSW‑индекс).
- Передача пар в LLM и получение JSON‑рекомендаций (вероятность дубликата, предлагаемое имя).​
- Сохранение результатов и отображение их в интерфейсе аналитика.​
### Онлайн‑проверка через API

Для предотвращения появления дубликатов на этапе ввода реализован отдельный endpoint:
POST /pipeline/start-specific/ — принимает данные одной сущности, строит её вектор, ищет ближайшие записи в базе и возвращает список потенциальных дубликатов с рекомендациями LLM.​
Этот запрос используется внешними системами (например, форком OpenPIM), чтобы перед созданием новой записи проверить, не существует ли уже аналогичный объект в НСИ.​
## 📋 Требования

### Для разработки

- **Node.js** 22+ и npm
- **Python** 3.9+
- **PostgreSQL** 18+ с расширением pgvector
- **Docker** и **Docker Compose** (опционально, для запуска через контейнеры)
### Переменные окружения

Создайте файл `.env` в корне проекта со следующими переменными:
```env
# База данных
DB_SOURCE_URL=postgresql://postgres:postgres@localhost:5432/openpim

# API для векторизации
VECTORIZER_API_URL=http://your-vectorizer-api-url
VECTORIZER_MODEL=your-vectorizer-model

# API для LLM
LLM_API_URL=http://your-llm-api-url
LLM_MODEL=your-llm-model
```

## 🚀 Быстрый старт

### Запуск через Docker Compose (рекомендуется)

1. Убедитесь, что переменные окружения настроены в `.env` файле
2. Запустите все сервисы:
```bash

docker-compose up -d

```

Это запустит:
- PostgreSQL на порту `5432`
- Backend API на порту `8080`
- Frontend на порту `80`
### Ручная установка
#### 1. Настройка базы данных

```bash

# Запустите PostgreSQL с расширением pgvector

docker run -d \
--name snorlaxify-postgres \
-e POSTGRES_PASSWORD=postgres \
-p 5432:5432 \
-v $(pwd)/openpim.sql:/docker-entrypoint-initdb.d/openpim.sql \
pgvector/pgvector:pg18
```
#### 2. Запуск Backend сервера

```bash
cd server
pip install -r requirements.txt
python -m server.src.main
```

Сервер будет доступен по адресу `http://localhost:8080`
#### 3. Запуск Frontend приложения

```bash
cd client
npm install
npm start
```

Приложение будет доступно по адресу `http://localhost:4200`
## 📁 Структура проекта

```

snorlaxify/

├── client/ # Angular фронтенд

│ ├── src/

│ │ ├── app/ # Основное приложение

│ │ ├── features/ # Функциональные модули (login, process)

│ │ ├── pages/ # Страницы приложения

│ │ ├── shared/ # Общие сервисы

│ │ └── widgets/ # UI виджеты

│ ├── angular.json

│ └── package.json

│

├── server/ # FastAPI бэкенд

│ ├── src/

│ │ ├── api/ # API роуты

│ │ ├── databases/ # Работа с БД

│ │ ├── processes/ # Бизнес-логика pipeline

│ │ ├── utils/ # Утилиты (vectorizer, recommender)

│ │ ├── config.py # Конфигурация

│ │ └── main.py # Точка входа

│ └── requirements.txt

│

├── docker-compose.yml # Docker Compose конфигурация

├── Dockerfile.client # Dockerfile для клиента

├── Dockerfile.server # Dockerfile для сервера

```

  
## 🔌 API Endpoints

### Pipeline Management
#### Запуск pipeline

```http
POST /api/pipeline/start
```

**Ответ:**

```json
{
	"status": "started",
	"message": "Pipeline execution started in background",
	"task_id": "uuid-here"
}
```
#### Получение статуса всех задач

```http
GET /api/pipeline/status
```

**Ответ:**

```json
{
	"count": 1,
	"tasks": [
		{
			"uuid": "task-id",
			"status": "running",
			"started_at": "2024-01-01T00:00:00",
			"current_step": 2,
			"total_steps": 5,
			"recommendations": null
		}
	]
}
```
#### Получение статуса конкретной задачи

```http
GET /api/pipeline/{task_id}/status
```
#### Пауза pipeline

```http
POST /api/pipeline/{task_id}/pause
```
#### Возобновление pipeline

```http
POST /api/pipeline/{task_id}/resume
```
#### Удаление задачи

```http

DELETE /api/pipeline/{task_id}

```
#### Разрешение дубликатов

```http

POST /api/pipeline/{task_id}/resolve

Content-Type: application/json

[
	{
		"product_id_1": "id1",
		"product_id_2": "id2"
	}
]
```

  

### Health Check

```http
GET /ping
```

**Ответ:**
```json
{
	"status": "pong"
}
```
## 🎯 Основные функции
### Управление процессами

- Создание и запуск новых процессов векторизации и поиска дубликатов
- Мониторинг статуса выполнения процессов
- Пауза и возобновление выполнения
- Удаление процессов
### Обнаружение дубликатов

- Автоматическое обнаружение дубликатов продуктов с использованием векторных представлений
- Рекомендации по объединению дубликатов с использованием LLM
- Интерактивный интерфейс для просмотра и исправления дубликатов
### Управление соединениями

- Просмотр и управление соединениями с базой данных
## 🛠️ Разработка
### Backend
```bash

cd server
pip install -r requirements.txt
# Запуск в режиме разработки
python -m server.src.main
```
### Frontend
```bash
cd client
npm install

# Запуск локально
npm start

# Сборка
npm run build

# Запуск тестов
npm test
```
## 🐳 Docker

### Сборка образов

```bash
# Сборка клиента
docker build -f Dockerfile.client -t snorlaxify-client .

# Сборка сервера
docker build -f Dockerfile.server -t snorlaxify-server .
```
### Запуск через Docker Compose

```bash
# Запуск всех сервисов
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка сервисов
docker-compose down

# Остановка с удалением volumes
docker-compose down -v
```

## 📊 База данных

Проект использует PostgreSQL с расширением `pgvector` для работы с векторными данными. Схема базы данных инициализируется из файла `openpim.sql` при первом запуске контейнера PostgreSQL.

### Основные таблицы
- `pipeline_tasks` — задачи pipeline
- `pipeline_results` — результаты выполнения pipeline
- `product_vectors` — векторные представления продуктов
