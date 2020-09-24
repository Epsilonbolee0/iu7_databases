-- Числа Фибоначчи до 100000 
WITH RECURSIVE fibonacci(a, b) AS (
	VALUES(0, 1)
	UNION ALL
	SELECT b, a + b FROM fibonacci WHERE b < 100000
)
SELECT a FROM fibonacci;