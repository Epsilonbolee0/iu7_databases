-- Создание лога по сообщениям на текущий момент

CREATE TEMP TABLE IF NOT EXISTS commentary_summary (
	id          INT,
	summ_time	TIMESTAMP,		
	email       VARCHAR,
	name        VARCHAR,
	sex   	    CHAR,
	birth_date  DATE,
	task_text   TEXT,
	solution    TEXT,
	task_rating SMALLINT,
	comment     TEXT,
	rating      SMALLINT,
	PRIMARY KEY(id, summ_time)
);

CREATE OR REPLACE FUNCTION get_comment_summary(int) RETURNS TABLE 
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
	INSERT INTO commentary_summary
	SELECT 
		   commentary.id,
		   current_timestamp AS summ_date,
		   email,
		   accounts.name,
		   sex,
		   birth_date,
		   tasks.data,
		   solution,
		   tasks.rating,
		   commentary.data,
		   commentary.rating
	FROM commentary JOIN accounts ON 
	commentary.author_id = accounts.id
	JOIN tasks ON tasks.id = task_id AND commentary.id = $1;
	
	SELECT * FROM commentary_summary
	WHERE id = $1;
$$  LANGUAGE SQL;

SELECT * FROM get_comment_summary(2);

