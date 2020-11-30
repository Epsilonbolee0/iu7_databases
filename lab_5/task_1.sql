DROP TABLE tasks_temp;
DROP TABLE tasks_copy_copy;

-- Извлечение данных из таблицы tasks в формате JSON
COPY (SELECT row_to_json(tasks) FROM tasks)
TO 'C:\studies\lab_5\tasks.json';

-- Импорт таблицы из формата JSON
CREATE TEMP TABLE tasks_temp(doc JSON);
COPY tasks_temp FROM 'C:\studies\lab_5\tasks.JSON';

-- Создание копии таблицы
CREATE TABLE IF NOT EXISTS tasks_copy_copy(LIKE tasks INCLUDING ALL); 
INSERT INTO tasks_copy_copy
SELECT t.*
FROM tasks_temp, json_populate_record(null::tasks, doc) AS t;

-- Проверка совпадения значения
(	SELECT * FROM tasks_copy_copy
	EXCEPT
 	SELECT * FROM tasks
)
UNION
(
	SELECT * FROM tasks
	EXCEPT
	SELECT * FROM tasks_copy_copy
)