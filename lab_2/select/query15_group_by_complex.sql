-- Получить средний рейтинг "одобренных" комментариев по возрасту 
SELECT ROUND(AVG(commentary.rating), 3) AS avg_rating FROM (
	SELECT students.id, birth_date FROM students 
	INNER JOIN accounts
	ON students.id = accounts.id
) AS student_names
INNER JOIN commentary
ON student_names.id = commentary.author_id
GROUP BY date_part('year', age(birth_date))
HAVING AVG(commentary.rating) >= 0;

