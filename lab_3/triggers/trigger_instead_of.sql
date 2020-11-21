-- Удаление очень плохих комментариев :)

CREATE VIEW commentary_view AS
SELECT *
FROM commentary;

CREATE OR REPLACE FUNCTION delete_comment() RETURNS TRIGGER AS $$
	BEGIN
		IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
			DELETE FROM commentary_view 
			WHERE commentary.id = old.id AND new.rating < -10
			RETURN new;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_bad_comment
	INSTEAD OF UPDATE OR INSERT ON commentary_view
	FOR EACH ROW 
		EXECUTE PROCEDURE update_student_rating();