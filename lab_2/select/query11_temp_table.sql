-- Получение всех олимпиадников
DROP TABLE pupils;

SELECT accounts.id, name
INTO TEMP pupils
FROM students
INNER JOIN accounts 
ON accounts.id = students.id
WHERE purpose = 'preparation for olympiad';

SELECT * FROM pupils;