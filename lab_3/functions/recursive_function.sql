-- создание

CREATE OR REPLACE FUNCTION get_course_len(id int, depth int = 1) RETURNS int
$$
BEGIN
	IF (EXISTS SELECT * FROM courses WHERE courses.father_id != NULL AND courses.id = id)
	THEN
		CALL get_course_len(courses.father_id, depth + 1);
	ELSE
		RETURN depth;
	END IF;
END;
$$ language plpgsql;

CALL previous_courses(3);