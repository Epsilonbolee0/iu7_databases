DROP TABLE accounts CASCADE;
DROP TABLE students CASCADE;
DROP TABLE teachers CASCADE;
DROP TABLE courses CASCADE;
DROP TABLE subjects CASCADE;
DROP TABLE colleges CASCADE;
DROP TABLE homeworks CASCADE;
DROP TABLE commentary CASCADE;
DROP TABLE tasks CASCADE;
DROP TABLE themes CASCADE;
DROP TABLE enrolls CASCADE;

--SET CLIENT_ENCODING TO "WIN1251";

CREATE TABLE IF NOT EXISTS subjects (
		code SMALLINT NOT NULL PRIMARY KEY,
		name VARCHAR(32) NOT NULL UNIQUE
		);

CREATE TABLE IF NOT EXISTS accounts (
		id SERIAL NOT NULL PRIMARY KEY,
		email VARCHAR (64) NOT NULL,
		name VARCHAR (128) NOT NULL,
		sex CHAR NOT NULL,
		birth_date DATE NOT NULL,
		account_type VARCHAR(8) NOT NULL,
		login VARCHAR (32) NOT NULL,
		salt CHAR (32) NOT NULL,
		hash CHAR (64) NOT NULL,		
		UNIQUE(email, login, salt),
		CONSTRAINT student_is_born CHECK (birth_date < current_date) 
		);

CREATE TABLE IF NOT EXISTS students (
		id INTEGER PRIMARY KEY REFERENCES accounts(id),
		grade SMALLINT NOT NULL,
		purpose TEXT, 
		account_level VARCHAR(8) NOT NULL,
		rating INTEGER NOT NULL
		);

CREATE TABLE IF NOT EXISTS colleges (
		id SERIAL NOT NULL PRIMARY KEY,
		college_name TEXT NOT NULL,
		number_of_places INTEGER NOT NULL,
		passing_grade SMALLINT NOT NULL,
		rating SMALLINT NOT NULL,
		address TEXT NOT NULL,
		site VARCHAR(64),
		phone_number VARCHAR(32),
		UNIQUE(rating, college_name, site, phone_number)
		);

CREATE TABLE IF NOT EXISTS teachers (
		id INTEGER PRIMARY KEY REFERENCES accounts(id),
		college_id INTEGER REFERENCES colleges(id),
		profile_subject_id SMALLINT REFERENCES subjects(code),
		has_red_diploma BOOLEAN NOT NULL DEFAULT FALSE,
		exam_result SMALLINT NOT NULL,
		degree VARCHAR(16) NOT NULL,
		rating REAL NOT NULL,
		CONSTRAINT valid_result CHECK (exam_result >= 0),
		CONSTRAINT rating_check CHECK (rating >= 0)
		);


CREATE TABLE IF NOT EXISTS courses (
		id SERIAL NOT NULL PRIMARY KEY,
		teacher_id INTEGER REFERENCES teachers(id),
		subject_code SMALLINT REFERENCES subjects(code),
		price MONEY
		);
		
CREATE TABLE IF NOT EXISTS enrolls(
		student_id INTEGER REFERENCES students(id),
		course_id INTEGER REFERENCES courses(id),
		PRIMARY KEY(student_id, course_id)
		);

CREATE TABLE IF NOT EXISTS homeworks (
		id SERIAL NOT NULL PRIMARY KEY,
		course_id INTEGER NOT NULL REFERENCES courses(id),
		rating_cost SMALLINT NOT NULL CONSTRAINT valid_rating_cost CHECK (rating_cost >= 0),
		deadline TIMESTAMP DEFAULT current_timestamp,
		CONSTRAINT valid_deadline CHECK (deadline >= current_timestamp)
		);

CREATE TABLE IF NOT EXISTS themes (
		code INTEGER NOT NULL PRIMARY KEY,
		subject_code SMALLINT REFERENCES subjects(code),	
		name TEXT NOT NULL
		);

CREATE TABLE IF NOT EXISTS tasks (
		id SERIAL NOT NULL PRIMARY KEY,
		homework_id INTEGER REFERENCES homeworks(id),
		theme_code INTEGER REFERENCES themes(code),
		author_id INTEGER REFERENCES teachers(id),
		data TEXT NOT NULL,
		solution TEXT NOT NULL,
		publication_date DATE NOT NULL DEFAULT current_date,
		rating SMALLINT,
		UNIQUE(data)
		);
		
CREATE TABLE IF NOT EXISTS commentary (
		id SERIAL NOT NULL PRIMARY KEY,
		author_id INTEGER REFERENCES students(id),
		task_id INTEGER REFERENCES tasks(id),
		data TEXT NOT NULL,
		publication_date DATE NOT NULL DEFAULT current_date,
		rating SMALLINT NOT NULL DEFAULT 0 
		);

ALTER TABLE homeworks DROP CONSTRAINT valid_deadline;
ALTER TABLE homeworks ADD CONSTRAINT valid_deadline CHECK (deadline > current_date);
ALTER TABLE students ADD CONSTRAINT valid_grade CHECK(grade >= 1 and grade <= 11);
ALTER TABLE students ADD CONSTRAINT valid_rating CHECK (rating >= 0);
ALTER TABLE colleges ADD CONSTRAINT valid_number_of_places CHECK (number_of_places > 0);
ALTER TABLE colleges ADD CONSTRAINT valid_passing_grade CHECK(passing_grade > 30 and passing_grade <= 100);
ALTER TABLE colleges ADD CONSTRAINT valid_rating CHECK(rating > 0);
ALTER TABLE teachers DROP CONSTRAINT valid_result;
ALTER TABLE teachers ADD CONSTRAINT valid_result CHECK(exam_result > 30 and exam_result <= 100);

COPY subjects(code, name) FROM 'C:\studies\sem_5\DB\base\src\subjects.csv' WITH (FORMAT csv);
COPY accounts(email, name, sex, birth_date, account_type, login, salt, hash) FROM 'C:\studies\sem_5\DB\base\src\accounts.csv' WITH (FORMAT csv);
COPY students(id, grade, purpose, account_level, rating) FROM 'C:\studies\sem_5\DB\base\src\students.csv' WITH (FORMAT csv);
COPY colleges(college_name, number_of_places, passing_grade, rating, address, site, phone_number) FROM 'C:\studies\sem_5\DB\base\src\colleges.csv' WITH (FORMAT csv);
COPY themes(code, subject_code, name) FROM 'C:\studies\sem_5\DB\base\src\themes.csv' WITH (FORMAT csv);
COPY teachers(id, college_id, profile_subject_id, has_red_diploma, exam_result, degree, rating) FROM 'C:\studies\sem_5\DB\base\src\teachers.csv' WITH (FORMAT csv);
COPY courses(teacher_id, subject_code, price) FROM 'C:\studies\sem_5\DB\base\src\courses.csv' WITH (FORMAT csv);
COPY homeworks(course_id, rating_cost, deadline) FROM 'C:\studies\sem_5\DB\base\src\homeworks.csv' WITH (FORMAT csv);
COPY tasks(homework_id, theme_code, author_id, data, solution, publication_date, rating) FROM 'C:\studies\sem_5\DB\base\src\tasks.csv' WITH (FORMAT csv);
COPY commentary(author_id, task_id, data, publication_date, rating) FROM 'C:\studies\sem_5\DB\base\src\comments.csv' WITH (FORMAT csv);
COPY enrolls(student_id, course_id) FROM 'C:\studies\sem_5\DB\base\src\enrolls.csv' WITH (FORMAT csv);

