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
LLM_PROVIDER=ollama
LLM_API_URL=http://your-llm-api-url
LLM_MODEL=your-llm-model
LLM_API_KEY=your-llm-api-key
```

`LLM_PROVIDER` поддерживает:
- `ollama` — текущий локальный формат `/api/chat`
- `gemini` — Google Gemini `models/*:generateContent`; для прямого вызова обычно нужен `LLM_API_KEY`

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

## 📏 Метрики качества дедупликации

В backend добавлен утилитарный модуль для offline-оценки качества дедупликации:
`server/src/utils/dedup_metrics.py`.

Он считает:
- `pair_precision`, `pair_recall`, `pair_f1` на размеченном pair-датасете
- `candidate_stage.precision`, `candidate_stage.recall`, `candidate_stage.f1`
- `final_stage.precision`, `final_stage.recall`, `final_stage.f1`
- `false_merge_rate`
- `coverage`

Для полного offline-прогона pipeline по размеченному benchmark-датасету добавлен runner:
`server/src/evaluation/benchmark.py`
и CLI:
`server/evaluate_benchmark.py`

Поддерживаются два формата входа:
- список пар вида `{"item_one_id": 1, "item_two_id": 2}`
- размеченный список пар вида `{"item_one_id": 1, "item_two_id": 2, "is_duplicate": true}`
- список групп вида `{"items": [{"item_id": 1}, {"item_id": 2}, {"item_id": 3}]}`

Пример использования:

```python
from server.src.utils.dedup_metrics import (
    build_pair_set_from_groups,
    calculate_pair_metrics_on_labeled_dataset,
    build_pair_set_from_pairs,
    calculate_deduplication_quality_metrics,
)

gold_pairs = build_pair_set_from_groups(gold_groups)
candidate_pairs = build_pair_set_from_pairs(candidate_stage_pairs)
predicted_pairs = build_pair_set_from_groups(predicted_duplicate_groups)
labeled_pairs_report = calculate_pair_metrics_on_labeled_dataset(
    predicted_duplicate_pairs=predicted_pairs,
    labeled_pairs=labeled_pairs,
)

report = calculate_deduplication_quality_metrics(
    candidate_pairs=candidate_pairs,
    predicted_duplicate_pairs=predicted_pairs,
    gold_duplicate_pairs=gold_pairs,
)

print(labeled_pairs_report.to_dict())
print(report.to_dict())
```

Интерпретация:
- `pair_precision`, `pair_recall`, `pair_f1` считаются напрямую на размеченном датасете пар.
- `candidate_stage` показывает качество candidate generation до LLM/финальной логики.
- `final_stage` показывает качество итоговых merge-рекомендаций.
- `false_merge_rate` показывает долю ложных объединений среди всех предложенных merge.
- `coverage` показывает, какую долю эталонных дублей удалось покрыть итоговыми merge-рекомендациями.

## 🧪 Benchmark-датасет

Формат benchmark JSON повторяет поля из `public.items` в `openpim.sql` и добавляет разметку пар:

```json
{
  "items": [
    {
      "identifier": "Metalll445",
      "path": "7.15.425",
      "name": { "en": "Арматура №10х6000-А500С" },
      "typeId": 7,
      "typeIdentifier": "Metalll",
      "parentIdentifier": "NMAb",
      "values": {},
      "fileOrigName": "",
      "storagePath": "",
      "mimeType": "",
      "id": 425,
      "tenantId": "default",
      "createdBy": "admin",
      "updatedBy": "admin",
      "createdAt": "2024-10-30T06:34:41.446+00:00",
      "updatedAt": "2024-10-30T06:34:41.446+00:00",
      "deletedAt": null,
      "channels": {}
    }
  ],
  "labeled_pairs": [
    { "item_one_id": 425, "item_two_id": 426, "is_duplicate": true }
  ]
}
```

Готовый пример лежит в [datasets/benchmark/example_labeled_dataset.json](/Users/npredein/repositories/snorlaxify/datasets/benchmark/example_labeled_dataset.json).

Запуск оценки:

```bash
python server/evaluate_benchmark.py datasets/benchmark/example_labeled_dataset.json
```

Если benchmark запускается с хоста, а в `.env` стоят Docker-URL вида `http://host.docker.internal:11434/...`,
runner автоматически подменит `host.docker.internal` на `localhost`.

При необходимости URL и модели можно переопределить явно:

```bash
python server/evaluate_benchmark.py \
  datasets/benchmark/example_labeled_dataset.json \
  --vectorizer-url http://localhost:11434/api/embed \
  --llm-url http://localhost:11434/api/chat \
  --vectorizer-model embeddinggemma:latest \
  --llm-model qwen3:4b
```

Что делает runner:
- берет `items` из benchmark JSON;
- строит тот же `vectorizer_input`, что и основной pipeline;
- вызывает текущий vectorizer;
- строит candidate groups по cosine distance и той же логике grouping;
- вызывает текущий recommender;
- считает `pair_precision`, `pair_recall`, `pair_f1` и stage-метрики качества.
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
