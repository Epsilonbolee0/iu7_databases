-- Функция, записывающая логи о комментарии по id

CREATE OR REPLACE FUNCTION get_comment_summary(id_ int) RETURNS TABLE 
(
	id          INT,
	summ_time 	TIMESTAMP,
	email       VARCHAR,
	name        VARCHAR,
	sex   	    CHAR,
	birth_date  DATE,
	task_text   TEXT,
	solution    TEXT,
	task_rating SMALLINT,
	comment     TEXT,
	rating      SMALLINT
) AS 
$$
	
commentary_logs = plpy.execute('SELECT id          INT,
								summ_time 	TIMESTAMP,
								email       VARCHAR,
								name        VARCHAR,
								sex   	    CHAR,
								birth_date  DATE,
								task_text   TEXT,
								solution    TEXT,
								task_rating SMALLINT,
								comment     TEXT,
								rating      SMALLINT FROM commentary JOIN accounts
							    ON commentary.author_id = accounts.id JOIN tasks ON tasks.id = task_id ')
 	
returning_array = []
for row_ in commentary_logs:
	returning_array.append(row_)
RETURN returning_array
$$  LANGUAGE plpython3u;

SELECT * FROM get_comment_summary(2);
