-- "Индульгенция" аккаунтов молодых студентов
UPDATE students
SET rating = (
	SELECT AVG(rating) FROM students
	INNER JOIN accounts
	ON accounts.id = students.id
	WHERE rating > 200 AND date_part('year', age(birth_date)) < 12
)
WHERE rating < 200 AND id IN (
	SELECT id FROM accounts
	WHERE date_part('year', age(birth_date)) < 12
);

SELECT name, rating FROM students
INNER JOIN accounts 
ON accounts.id = students.id
WHERE date_part('year', age(birth_date)) < 12