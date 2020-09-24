-- Выбрать всех выпускников "университетов"
SELECT name, college_name FROM 
teachers INNER JOIN accounts 
ON teachers.id = accounts.id
INNER JOIN colleges 
ON teachers.college_id = colleges.id
WHERE college_name IN (
	SELECT college_name FROM colleges
	WHERE college_name LIKE 'University%'
)