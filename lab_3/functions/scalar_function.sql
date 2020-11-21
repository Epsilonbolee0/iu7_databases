CREATE OR REPLACE FUNCTION get_teacher_number() RETURNS BIGINT AS $$
	SELECT COUNT(*)
	FROM teachers
$$  LANGUAGE SQL;

SELECT get_teacher_number();	
