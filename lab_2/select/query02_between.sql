-- Поиск всех учеников от 18 до 24 лет
SELECT name, birth_date FROM students
INNER JOIN accounts
ON students.id = accounts.id
WHERE date_part('year', age(birth_date)) BETWEEN 18 AND 24