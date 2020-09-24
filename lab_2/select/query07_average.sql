-- Найти средний рейтинг девочек и мальчиков
SELECT sex, round(AVG(rating))
FROM students
INNER JOIN accounts
ON students.id = accounts.id
GROUP BY sex