-- Найти курсы, которые никто не купил :(
SELECT name, code FROM courses
INNER JOIN subjects
ON courses.subject_code = subjects.code
EXCEPT
SELECT name, code FROM courses
INNER JOIN subjects
ON courses.subject_code = subjects.code
WHERE EXISTS (
	SELECT * FROM enrolls
	WHERE enrolls.course_id = courses.id
)