-- Для каждой из степеней преподавателей найти средний балл и рейтинг
SELECT degree, name,
		ROUND((AVG(exam_result) OVER (PARTITION BY degree))::numeric, 3) AS avg_exam,
		ROUND((AVG(rating) OVER (PARTITION BY degree))::numeric, 3) AS avg_rating,
		ROUND((exam_result - (AVG(exam_result) OVER (PARTITION BY degree)))::numeric, 3) AS delta_exam,
		ROUND((rating - (AVG(rating) OVER (PARTITION BY degree)))::numeric, 3) AS delta_rating
FROM teachers
INNER JOIN accounts
ON teachers.id = accounts.id;