-- Найти магистра с отзывами не хуже, чем у самого "популярного" специалиста

SELECT name, rating FROM teachers
INNER JOIN accounts
ON teachers.id = accounts.id AND degree = 'master'
WHERE rating >= ALL (
	SELECT rating FROM teachers
	WHERE degree = 'bachelor'
)