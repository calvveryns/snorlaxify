# Duplicate Search Pipeline

Короткая справка по текущей реализации поиска дублей.

## Что уходит в embedding модель

- Источник данных: записи из `items` через `get_identifiers_with_vector_metadata()`.
- Поля, которые реально читаются: `item_id`, `name`, `path`, `type_id`, `type_identifier`, `updated_at`, metadata из `vector_data`.
- Поля, которые реально уходят в embedding API сейчас:

```text
name: {name}
```

- `path`, `typeId`, `typeIdentifier` сейчас в `build_vectorizer_input()` не используются, хотя в `CHANGELOG.md` описана более широкая версия.
- Для повторной векторизации считается SHA-256 от итоговой строки `vectorizer_input`.

## Кратко про промпты к моделям

### 1. `regroup_duplicate_groups`

Задача:
- разбить candidate group на смысловые подгруппы дублей;
- не возвращать одиночные записи;
- не добавлять новые `item_ids`;
- не дублировать одну запись в нескольких подгруппах.

Вход:
- `source_anchor_item_id`
- `items[]` с `item_id`, `title`, `distance`, `is_anchor`

Выход:

```json
{
  "results": [
    {
      "anchor_item_id": 123,
      "item_ids": [123, 456]
    }
  ]
}
```

### 2. `filter_duplicate_groups`

Задача:
- проверить, какие элементы группы реально являются дублями anchor-записи;
- можно вернуть только часть дублей;
- если дублей нет, группу не возвращать.

Вход:
- `anchor_item_id`
- `items[]` с `item_id`, `title`, `is_anchor`

Выход:

```json
{
  "results": [
    {
      "anchor_item_id": 123,
      "duplicate_item_ids": [456]
    }
  ]
}
```

### 3. `recommend_duplicates`

Задача:
- предложить общее нормализованное имя для уже подтвержденной группы дублей;
- если уверенности нет, вернуть `suggested_name: null`.

Вход:
- `items[]` с `title`, `is_anchor`

Выход:

```json
{
  "results": [
    {
      "suggested_name": "Borjomi 0.5"
    }
  ]
}
```

## Алгоритм формирования групп дубликатов

### Stage 1. Candidate generation

1. Для каждого объекта берется embedding.
2. В `vector_data` для каждого вектора ищутся соседи:
   - метрика: cosine distance через pgvector `<=>`
   - порог: `DUPLICATE_DISTANCE_THRESHOLD`
   - ограничение: `DUPLICATE_GROUP_TOP_K`, по умолчанию `10`
3. Из связей строится неориентированный граф.
4. Кандидатная группа = connected component графа.
5. Компоненты из 1 элемента отбрасываются.

### Stage 2. Выбор anchor

Для каждой компоненты выбирается anchor:

1. Считается shortest-path distance до всех остальных узлов.
2. Берется вершина с минимальным средним расстоянием до остальных.
3. Если есть tie:
   - побеждает более длинный `title`
   - потом меньший `vector_id`

### Stage 3. Расстояния внутри группы

- Для anchor `distance = 0.0`.
- Для остальных `distance` = длина кратчайшего пути от anchor.
- Элементы группы сортируются так:
  - anchor первым
  - затем по `distance`
  - затем по `item_id`

### Stage 4. LLM post-processing

1. `regroup_duplicate_groups` может разбить одну candidate group на несколько подгрупп.
2. `filter_duplicate_groups` может выкинуть часть элементов из группы.
3. `recommend_duplicates` добавляет только `suggested_name`.
4. В финальном merge код принудительно ставит `duplicate_likelihood = "high"` для всех дошедших групп.

## Важные нюансы текущей реализации

- Фильтр `_should_link_titles()` существует, но сейчас отключен в `_build_groups_from_neighbors()`. То есть кандидатные группы строятся по embedding distance без дополнительной проверки конфликтующих чисел/модельных токенов.
- Если `regroup` возвращает невалидный JSON/структуру, код откатывается к исходным candidate groups.
- Если `filter` возвращает невалидный ответ, включается fallback: оставить всех не-anchor элементов как дубли.

## Полезные ссылки на код

- `server/src/processes/pipeline.py`
- `server/src/utils/vectorizer_input.py`
- `server/src/databases/database.py`
- `server/src/utils/recommender.py`
