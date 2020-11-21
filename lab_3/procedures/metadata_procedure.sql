-- Получить названия всех ограничений в столбцах и таблицах

SELECT * 
	FROM (
		SELECT table_name, column_name, constraint_name
		FROM information_schema.constraint_column_usage
		WHERE constraint_schema NOT IN ('information_schema', 'pg_catalog')
	) AS tmp;

CREATE OR REPLACE PROCEDURE get_constraint_data() AS $$
BEGIN
	FOR row IN tmp
	LOOP
		RAISE NOTICE '{table: %} {column: %} {constraint: %}', row.table_name, row.column_name, row.constraint_name;
	END LOOP;
END
$$ language plpgsql;

CALL get_constraint_data();