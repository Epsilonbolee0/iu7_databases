-- Обновить все просроченые дедлайны на завтрашний день

DROP TABLE IF EXISTS homeworks_copy;

SELECT *
INTO TEMP homeworks_copy
FROM homeworks;

CREATE OR REPLACE PROCEDURE update_deadlines(curr_id int, last_id int) AS
$$
BEGIN
	IF (curr_id <= last_id)
THEN
	UPDATE homeworks_copy
	SET deadline = current_date + 1
	WHERE id = curr_id AND deadline <= current_date;
	CALL update_deadlines(curr_id + 1, last_id);
END IF;
END;
$$ language plpgsql;


CALL update_deadlines(1, 100);

SELECT *
FROM homeworks_copy
WHERE deadline <= current_date
AND id < 100;