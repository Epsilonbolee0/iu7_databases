-- Поиск преподавателей с красным дипломом
SELECT name FROM teachers
INNER JOIN accounts 
ON teachers.id = accounts.id
WHERE has_red_diploma = true
