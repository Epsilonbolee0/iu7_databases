-- Слияние версионных таблиц (доп. задание 1)

DROP TABLE IF EXISTS table1;
DROP TABLE IF EXISTS table2;

CREATE TABLE IF NOT EXISTS table1 (
	id INTEGER,
	var1 CHAR,
	date_from DATE,
	date_to DATE
);

CREATE TABLE IF NOT EXISTS table2 (
	id INTEGER,
	var2 char,
	date_from DATE,
	date_to DATE
);

INSERT INTO table1 (id, var1, date_from, date_to) VALUES(1, 'A', '2018-09-01', '2018-09-15');
INSERT INTO table1 (id, var1, date_from, date_to) VALUES(1, 'B', '2018-09-16', '5999-12-31');

INSERT INTO table2 (id, var2, date_from, date_to) VALUES(1, 'A', '2018-09-01', '2018-09-18');
INSERT INTO table2 (id, var2, date_from, date_to) VALUES(1, 'B', '2018-09-19', '5999-12-31');

SELECT table1.id, var1, var2,
	CASE WHEN table1.date_from < table2.date_from
		THEN table2.date_from
		ELSE table1.date_from
	END AS date_from,
	CASE WHEN table1.date_to < table2.date_to
		THEN table1.date_to
		ELSE table2.date_to
	END AS date_to
FROM table1 INNER JOIN table2 ON
table1.id = table2.id AND
table1.date_from < table2.date_to AND
table1.date_to > table2.date_from