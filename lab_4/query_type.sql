-- Тип
-- Сводка по предмету

CREATE TYPE subject_summary AS (
	name VARCHAR,
	themes_cnt INT,
	courses_cnt INT,
	teachers_cnt INT
);

CREATE OR REPLACE FUNCTION get_subject_summary(code_ INT) 
RETURNS subject_summary 
AS $$
plan_name_ = plpy.prepare('SELECT name FROM subjects WHERE code = $1', ['int'])
plan_themes_cnt = plpy.prepare('SELECT COUNT(*) FROM themes WHERE subject_code = $1', ['int'])
plan_courses_cnt = plpy.prepare('SELECT COUNT(*) FROM courses WHERE subject_code = $1', ['int'])
plan_teachers_cnt = plpy.prepare('SELECT COUNT(*) FROM teachers WHERE profile_subject_id = $1', ['int'] )

name_ = plpy.execute(plan_name_, [code_])[0]['name']
themes_cnt = plpy.execute(plan_themes_cnt, [code_])[0]['count']
courses_cnt = plpy.execute(plan_courses_cnt, [code_])[0]['count']
teachers_cnt = plpy.execute(plan_teachers_cnt, [code_])[0]['count']
return (name_, themes_cnt, courses_cnt, teachers_cnt)
$$ language plpython3u;

SELECT * FROM get_subject_summary(28);
