CREATE OR REPLACE FUNCTION get_subject_name(int code) RETURNS subjects AS $$
	SELECT *
	FROM subjects
	WHERE subjects.code = code;
$$  LANGUAGE SQL;

SELECT get_subject_name(42);
