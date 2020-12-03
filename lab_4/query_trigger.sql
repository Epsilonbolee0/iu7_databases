-- Триггер
-- При обновлении рейтинга вуза рейтинг всех его учеников увеличивается

CREATE OR REPLACE FUNCTION update_teacher_rating() RETURNS TRIGGER
AS $$
if TG_OP == 'UPDATE':
	plpy.execute('UPDATE teachers SET rating = rating + 1 WHERE teachers.id = OLD.id')
$$ LANGUAGE plpython3u;

CREATE TRIGGER on_college_upgrade
	AFTER UPDATE OF rating ON colleges
	FOR EACH ROW
	WHEN (OLD.rating > NEW.rating)
		EXECUTE PROCEDURE update_teacher_rating();
		
UPDATE colleges
SET rating = rating + 1
WHERE college_id = 3;

SELECT *
FROM teachers
WHERE college_id = 3;

