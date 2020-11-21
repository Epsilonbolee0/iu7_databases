-- Получить все курсы, предшествующие первому текущему
ALTER TABLE courses ADD COLUMN father_id INTEGER;

WITH RECURSIVE previous_courses(course_id, subject) AS (
	SELECT courses.id, courses.subject 
	FROM courses AS courses_1
	WHERE courses.id = 1
	UNION ALL
	SELECT courses.id, courses.subject
	FROM courses
	INNER JOIN new_levels 
	ON courses_1.father_id = courses.id 
)

SELECT * FROM previous_courses;