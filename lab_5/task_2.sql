-- Добавление столбца в 
ALTER TABLE tasks_copy ADD COLUMN data_json JSON;

-- Импорт таблицы из формата JSON во временную
CREATE TEMP TABLE tasks_json(id SERIAL, doc JSON);
COPY tasks_json FROM 'C:\studies\lab_5\data.JSON';

-- Добавление столбца в таблицу
UPDATE tasks_copy
SET    data_json = (SELECT doc FROM tasks_json WHERE tasks_copy.id = tasks_json.id)