-- Вариант 4

CREATE TABLE IF NOT EXISTS visitors (
	id 		SERIAL PRIMARY KEY,
	fio 	VARCHAR(128) NOT NULL,
	address VARCHAR(32) NOT NULL,
	phone 	VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS stands (
	id		SERIAL PRIMARY KEY,
	name	VARCHAR(64) NOT NULL,
	field	VARCHAR(32) NOT NULL,
	descr	VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS excursions (
	id 			SERIAL PRIMARY KEY,
	descr		VARCHAR(32) NOT NULL,
	date_from 	DATE NOT NULL,
	date_to  	DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS ev (
	excursion_id INTEGER REFERENCES excursions(id),
	visitor_id 	 INTEGER REFERENCES visitors(id),
	PRIMARY KEY (excursion_id, visitor_id)
);

CREATE TABLE IF NOT EXISTS es (
	excursion_id INTEGER REFERENCES excursions(id),
	stand_id	 INTEGER REFERENCES stands(id),
	PRIMARY KEY (excursion_id, stand_id)
);

INSERT INTO visitors (fio, address, phone) VALUES 
('Иван Иванов', 'Улица Медных Горшков', 3371590);
INSERT INTO visitors (fio, address, phone) VALUES 
('Олег Кизару', 'Улица Красного Октября', 3371684);
INSERT INTO visitors (fio, address, phone) VALUES 
('Денис Денисович', 'Улица Медных Горшков', 3079090);
INSERT INTO visitors (fio, address, phone) VALUES 
('Иван Пиваныч', 'Улица Ленина', 3371216);
INSERT INTO visitors (fio, address, phone) VALUES 
('Егор Летов', 'Улица Маркса', 3371684);
INSERT INTO visitors (fio, address, phone) VALUES 
('Виктор Цой', 'Улица Ленина', 2156565);
INSERT INTO visitors (fio, address, phone) VALUES 
('Ирина Аллегрова', 'Бульвар Постиронии', 1122233);
INSERT INTO visitors (fio, address, phone) VALUES 
('Женское Имя', 'Улица Забоя Скота', 123456);
INSERT INTO visitors (fio, address, phone) VALUES 
('Гений Мысли', 'Переулок Ночных Дорог', 800800);

INSERT INTO stands (name, field, descr) VALUES
('Рука Бога', 'Теология', 'Выходит, это рука бога');
INSERT INTO stands (name, field, descr) VALUES
('Мадонна', 'Картина', 'Точно не чайлдфри');
INSERT INTO stands (name, field, descr) VALUES
('Венера Милосская', 'Статуя', 'Красива и без рук');
INSERT INTO stands (name, field, descr) VALUES
('Ника Самофракийская', 'Статуя', 'Голова - лишняя роскошь');
INSERT INTO stands (name, field, descr) VALUES
('Мона Лиза', 'Картина', 'В её улыбке загадка на века');
INSERT INTO stands (name, field, descr) VALUES
('Первый амперметр', 'Прибор', 'Мелочь, а приятно');
INSERT INTO stands (name, field, descr) VALUES
('Скелет Тирекса', 'Паолеонтология', 'Реликвия для биологов');
INSERT INTO stands (name, field, descr) VALUES
('Вилы Геральта', 'Артефакт', 'Сапковский не шутил');
INSERT INTO stands (name, field, descr) VALUES
('Грааль', 'Теология', 'А ведь нашёлся');
INSERT INTO stands (name, field, descr) VALUES
('Машина времени', 'Прибор', 'Опасно тут ставить');

INSERT INTO excursions (descr, date_from, date_to) VALUES
('3 дивы Лувра', '1999-01-08', '1999-08-08');
INSERT INTO excursions (descr, date_from, date_to) VALUES
('Самое лучшее', '2015-01-08', '2018-08-08');
INSERT INTO excursions (descr, date_from, date_to) VALUES
('По следам теологии', '2019-01-08', '2000-08-08');
INSERT INTO excursions (descr, date_from, date_to) VALUES
('Всё и сразу', '2016-01-08', '2013-08-08');
INSERT INTO excursions (descr, date_from, date_to) VALUES
('Машина времени', '2017-01-08', '2016-08-08');

INSERT INTO ev VALUES (1, 1);
INSERT INTO ev VALUES (2, 2);
INSERT INTO ev VALUES (3, 5);
INSERT INTO ev VALUES (1, 7);
INSERT INTO ev VALUES (5, 1);
INSERT INTO ev VALUES (5, 2);
INSERT INTO ev VALUES (4, 3);
INSERT INTO ev VALUES (2, 6);
INSERT INTO ev VALUES (3, 6);
INSERT INTO ev VALUES (3, 4);

INSERT INTO es VALUES (2, 1);
INSERT INTO es VALUES (5, 4);
INSERT INTO es VALUES (1, 6);
INSERT INTO es VALUES (1, 7);
INSERT INTO es VALUES (2, 4);
INSERT INTO es VALUES (3, 5);
INSERT INTO es VALUES (4, 3);
INSERT INTO es VALUES (2, 2);
INSERT INTO es VALUES (3, 4);
INSERT INTO es VALUES (3, 7);

-- Инструкция SELECT, использующая поисковое выражение CASE
-- Вывести для каждой экскурсии статус по её 'возрасту'
SELECT descr,
	   CASE WHEN date_from < '2000-01-01' THEN 'Очень старая'
	   		WHEN date_from < '2010-01-01' THEN 'Старая'
	   	    WHEN date_from < '2015-01-10' THEN 'Новая'
	   		ELSE 'Очень новая'
	   END AS status
	   
FROM excursions

-- Конструкция UPDATE со скалярным подзапросом в предложении
-- Переименовать все экспонаты-приборы в экспонаты "физика"

UPDATE stands
SET field = 'Физика'
WHERE id IN (
	SELECT id FROM stands
	WHERE field = 'Прибор'
);

SELECT * FROM stands;

-- Конструкция GROUP BY, консолидирующая данные с помощью
-- Экскурсии, посещённые хотя бы одним человеком

SELECT descr, COUNT(*)
FROM excursions JOIN ev 
ON ev.excursion_id = excursions.id
GROUP BY id
HAVING COUNT(*) > 1;

-- Создать хранимую процедуру с выходным параметром, которая уничтожает
-- все представления в текущей базе данных, которые не были зашифрованы.
-- Выходной параметр возвращает количество уничтоженных представлений.
-- Созданную хранимую процедуру протестировать. 


CREATE OR REPLACE FUNCTION delete_views(OUT cnt int) AS $$
DECLARE
	r RECORD;
BEGIN
	cnt := (SELECT COUNT(*) FROM pg_views WHERE schemaname = 'public');
	
	FOR r IN (SELECT viewname FROM pg_views WHERE schemaname = 'public') LOOP
		EXECUTE 'DROP VIEW IF EXISTS ' || r.viewname || ' CASCADE';
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM pg_views
WHERE schemaname = 'public';

SELECT * FROM delete_views();