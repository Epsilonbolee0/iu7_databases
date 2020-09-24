-- Для каждого домашнего задания найти количество заданий
SELECT homeworks.id, COUNT(*) FROM homeworks
INNER JOIN tasks
ON tasks.homework_id = homeworks.id
GROUP BY homeworks.id
ORDER BY homeworks.id ASC;