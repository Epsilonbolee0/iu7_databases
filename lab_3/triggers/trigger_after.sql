-- Увеличение рейтинга студента при хорошем комментарии

CREATE OR REPLACE FUNCTION update_student_rating() RETURNS TRIGGER AS $$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			UPDATE students
			SET rating = rating + 1
			WHERE students.id = OLD.id;
			RETURN new;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_good_comment
	AFTER UPDATE OF rating ON commentary
	FOR EACH ROW
	WHEN (old.rating IS DISTINCT FROM new.rating AND new.rating > 5)
	EXECUTE PROCEDURE update_student_rating();