import psycopg2


class DatabaseFacade:
    def __init__(self):
        self.connection = psycopg2.connect(dbname='educational_site', user='postgres',
                                           password='1029384756tnn_', host='localhost')
        self.cursor = self.connection.cursor()

    def __del__(self):
        self.connection.close()
        self.cursor.close()

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(DatabaseFacade, cls).__new__(cls)
        return cls.instance

    def query_result(self):
        data = self.cursor.fetchall()
        if data is None:
            print(' No query provided!')
        elif len(data) == 0:
            print(' Query gave no result!')
        else:
            for row in data:
                print(row)

    def get_great_schools(self):
        self.cursor.execute("SELECT college_name, passing_grade "
                            "FROM colleges "
                            "WHERE college_name LIKE 'Higher school%' "
                            " AND passing_grade >= 90")

    def get_unpopular_courses(self):
        self.cursor.execute("SELECT name, code FROM courses "
                            "INNER JOIN subjects "
                            "ON courses.subject_code = subjects.code "
                            "EXCEPT "
                            "SELECT name, code FROM courses "
                            "INNER JOIN subjects "
                            "ON courses.subject_code = subjects.code "
                            "WHERE EXISTS ( "
                            "	SELECT * FROM enrolls "
                            "	WHERE enrolls.course_id = courses.id) ")

    def get_teacher_summary(self):
        self.cursor.execute("SELECT degree, name, "
                            "ROUND((AVG(exam_result) OVER (PARTITION BY degree))::numeric, 3) AS avg_exam, "
                            "ROUND((AVG(rating) OVER (PARTITION BY degree))::numeric, 3) AS avg_rating, "
                            "ROUND((exam_result - (AVG(exam_result) OVER (PARTITION BY degree)))::numeric, 3) AS delta_exam, "
                            "ROUND((rating - (AVG(rating) OVER (PARTITION BY degree)))::numeric, 3) AS delta_rating "
                            "FROM teachers "
                            "INNER JOIN accounts "
                            "ON teachers.id = accounts.id ")

    def get_tables(self):
        self.cursor.execute("SELECT table_name, table_type "
                            "FROM information_schema.tables "
                            "WHERE table_schema = 'public'")

    def get_table_columns(self, table_name):
        self.cursor.execute("SELECT column_name, data_type, is_nullable "
                            "FROM information_schema.columns "
                            "WHERE table_name = (%s)", [table_name])

    def get_comment_summary(self, commentary_id):
        self.cursor.callproc("get_comment_summary", [commentary_id])
        self.connection.commit()

    def create_permission_table(self):
        self.cursor.execute("SELECT * FROM information_schema.tables "
                            "WHERE table_schema = 'public' "
                            "AND table_name = 'permissions'")

        data = self.cursor.fetchone()
        if data is not None:
            print(" Table permissions already exists!")
            return False

        try:
            self.cursor.execute("CREATE TABLE permissions(id SERIAL PRIMARY KEY,"
                                "                   role VARCHAR NOT NULL,"
                                "                   permission_level INT NOT NULL)")
        except psycopg2.OperationalError:
            print(" Table creation was denied by postgres!")
            return False

        self.connection.commit()
        print(" Table permissions successfully created!")
        return True

    def delete_bad_tasks(self):
        self.cursor.callproc("delete_bad_tasks")

    def drop_permissions_table(self):
        self.cursor.execute("SELECT * FROM information_schema.tables "
                            "WHERE table_schema = 'public' "
                            "AND table_name = 'permissions'")

        data = self.cursor.fetchone()
        if data is None:
            print(" Table permissions does not exist!")
            return False

        try:
            self.cursor.execute("CREATE TABLE permissions(id INT PRIMARY KEY,"
                                "                   role VARCHAR NOT NULL,"
                                "                   permission_level INT NOT NULL)")
        except psycopg2.OperationalError:
            print(" Table drop was denied by postgres!")
            return False

        self.connection.commit()
        print(" Table permissions successfully dropped!")
        return True

    def add_new_permission(self, id, role, permission_level):
        self.cursor.execute("SELECT * FROM information_schema.tables "
                            "WHERE table_schema = 'public' "
                            "AND table_name = 'permissions'")

        data = self.cursor.fetchone()
        if data is None:
            print(" Table permissions does not exist!")
            return False

        try:
            self.cursor.execute("INSERT INTO permissions VALUES ((%s), (%s), (%s))", [id, role, permission_level])
        except psycopg2.OperationalError:
            print(" Insertion was denied by postgres")
            return False
        except psycopg2.errors.UniqueViolation:
            print(" Value with such id already exists!")
            return False

        self.connection.commit()
        print(" Values were successfully inserted!")
        return True

    def get_version(self):
        self.cursor.callproc("version")
        self.query_result()

    def get_teacher_number(self):
        self.cursor.callproc("get_teacher_number")


facade = DatabaseFacade()
facade.get_teacher_summary()
facade.query_result()


