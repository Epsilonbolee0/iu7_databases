-- Модерация комментариев несовершеннолетних
DELETE FROM commentary
WHERE author_id IN (
	SELECT students.id FROM students
	INNER JOIN accounts
	ON students.id = accounts.id
	WHERE date_part('year', age(birth_date)) < 18
) AND rating < 0;