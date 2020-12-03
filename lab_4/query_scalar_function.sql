-- Определяемая пользователем скалярная функция CLR
-- Получить проходной балл в колледж по названию

CREATE OR REPLACE FUNCTION get_college_grade(name_ VARCHAR) RETURNS VARCHAR
AS $$
colleges = plpy.execute("SELECT * FROM colleges")
for college in colleges:
	if college['college_name'] == name_:
		return college['passing_grade']
return 'None'
$$ LANGUAGE plpython3u;

SELECT * FROM get_college_grade('College of integrate open-source convergence');
SELECT * FROM get_college_grade('Not existing college');
