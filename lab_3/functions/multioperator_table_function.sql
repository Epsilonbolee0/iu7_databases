CREATE OR REPLACE FUNCTION get_comment_summary(int, int, date, char) RETURNS TABLE 
(
	id          INT,
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
	SELECT commentary.id,
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
	JOIN tasks ON tasks.id = task_id AND commentary.id = $1
	WHERE tasks.rating >= $2 AND accounts.birth_date <= $3 AND accounts.sex = $4;

$$  LANGUAGE SQL;

SELECT * FROM get_comment_summary(22);


