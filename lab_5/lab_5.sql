
-- Извлечение данных из таблицы tasks в формате JSON
COPY (SELECT row_to_json(tasks) FROM tasks)
TO 'C:\studies\lab_5\tasks.json'

-- Импорт таблицы из формата JSON
CREATE TEMP TABLE tasks_temp(doc JSON);
COPY tasks_temp FROM 'C:\studies\lab_5\tasks.JSON';

SELECT p.*
FROM tasks_temp;

DROP TABLE tasks_temp;