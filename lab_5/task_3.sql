-- (1) Извлечь JSON фрагмент из JSON документа
-- Получить количество золота, необходимого для постройки зиккурата
SELECT *
FROM json_extract_path('{"name": "zikkurat", "faction": "undeads", "data": {"price": {"gold": 100, "wood": 5, "stone": 10}, "work": 10}}', 'data', 'price', 'gold')

-- (2) Извлечь значения конкретных узлов или атрибутов JSON документа
-- Все авторы в таблице, написавшие книги со сложностью больше 3
SELECT DISTINCT(data_json->>'author') AS author, (data_json->>'difficulty')::int AS difficulty 
FROM tasks_copy
WHERE (data_json->>'difficulty')::int > 3;

-- (3) Выполнить проверку существования узла или атрибута
-- Получение всех книг, у которых есть сложность
SELECT DISTINCT(data_json->>'book') AS book
FROM tasks_copy
WHERE data_json::jsonb ? 'difficulty'::text
ORDER BY data_json->>'book';

-- (4) Изменить JSON документ
-- Удалить из документов параметр picture
UPDATE tasks_copy
SET data_json = data_json::jsonb - 'picture'::text;

-- (5) Разделить JSON документ на несколько строк по узлам
-- Поместить данные о зиккурате в таблицу вида key - values
SELECT *
FROM json_each_text('{"name": "zikkurat", "faction": "undeads", "data": {"price": {"gold": 100, "wood": 5, "stone": 10}, "work": 10}}')