-- Вывести учеников, которые готовятся к ЕГЭ на курсах у непрофильного преподавателя аниме

SELECT name FROM students
INNER JOIN accounts
ON students.id = accounts.id AND purpose = 'preparation for EGE'
WHERE students.id IN (
	SELECT student_id FROM enrolls
	WHERE course_id IN (
		SELECT courses.id FROM courses 
		INNER JOIN teachers
		ON courses.teacher_id = teachers.id
		WHERE courses.subject_code != teachers.profile_subject_id
		AND teachers.profile_subject_id IN (
			SELECT subject_code FROM subjects
			WHERE name = 'anime'
		)
	)
)