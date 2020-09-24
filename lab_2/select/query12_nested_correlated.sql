-- Выбрать предметы заданий
SELECT tasks.id, tasks.data, themes.name, subjects.name
FROM tasks INNER JOIN (
	themes INNER JOIN subjects
	ON themes.subject_code = subjects.code
) ON tasks.theme_code = themes.code


