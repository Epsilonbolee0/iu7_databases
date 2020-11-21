-- Сделать скидку для всех курсов по определённому предмету,
-- которые ведёт непрофильный преподаватель

DROP TABLE IF EXISTS courses_copy;

SELECT *
INTO courses_copy
FROM courses;

CREATE OR REPLACE PROCEDURE set_discount_on_courses(coeff real, subj_code int) AS
$$
DECLARE courses_cursor CURSOR
	FOR SELECT courses.* 
	FROM courses JOIN teachers
	ON courses.teacher_id = teachers.id
	AND teachers.profile_subject_id != courses.subject_code
	WHERE subject_code = courses.subject_code;
	row RECORD;
BEGIN
	OPEN courses_cursor;
	LOOP
		FETCH courses_cursor INTO ROW;
		EXIT WHEN NOT FOUND;
		UPDATE courses_copy
		SET price = price * coeff
		WHERE courses_copy.id = row.id;
	END LOOP;
	CLOSE courses_cursor;
END
$$ language plpgsql;

CALL set_discount_on_courses(0.75, 42);

SELECT courses.* 
FROM courses JOIN teachers
ON courses.teacher_id = teachers.id
AND teachers.profile_subject_id != courses.subject_code
WHERE subject_code = courses.subject_code;
