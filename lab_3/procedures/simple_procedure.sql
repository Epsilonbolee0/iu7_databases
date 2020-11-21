-- Удаление всех комментариев с негативным рейтингом

SELECT * 
INTO TEMP tasks_copy
FROM tasks;

CREATE OR REPLACE PROCEDURE delete_bad_tasks() AS
$$
	DELETE FROM tasks_copy
	WHERE rating < 0;
$$ language sql;

call delete_bad_tasks();

SELECT * FROM tasks_copy
WHERE rating < 0;