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
        else:
            for row in data:
                print(' ', row)

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
        self.cursor.execute("CALL delete_bad_tasks()")

    def drop_permissions_table(self):
        self.cursor.execute("SELECT * FROM information_schema.tables "
                            "WHERE table_schema = 'public' "
                            "AND table_name = 'permissions'")

        data = self.cursor.fetchone()
        if data is None:
            print(" Table permissions does not exist!")
            return False

        try:
            self.cursor.execute("DROP TABLE permissions")
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

    def get_teacher_count(self):
        self.cursor.callproc("get_teacher_number")


def print_options():
    print(" [0] Get great schools")
    print(" [1] Get unpopular courses")
    print(" [2] Get teacher count")
    print(" [3] Get all tables")
    print(" [4] Get table columns")
    print(" [5] Get comment summary")
    print(" [6] Create permission table")
    print(" [7] Drop permission table")
    print(" [8] Add new permission")
    print(" [9] Delete bad tasks")
    print(" [10] Get Postgres version")


def menu():
    facade = DatabaseFacade()
    while True:
        print_options()
        option = int(input(" Choose wisely: "))
        if option == 0:
            facade.get_great_schools()
            facade.query_result()
        elif option == 1:
            facade.get_unpopular_courses()
            facade.query_result()
        elif option == 2:
            facade.get_teacher_count()
            facade.query_result()
        elif option == 3:
            facade.get_tables()
            facade.query_result()
        elif option == 4:
            table_name = input(" Enter name of table: ")
            facade.get_table_columns(table_name)
            facade.query_result()
        elif option == 5:
            comment_id = int(input(" Enter comment id: "))
            if comment_id < 0:
                print(" Invalid comment id")
                continue
            facade.get_comment_summary(comment_id)
            facade.query_result()
        elif option == 6:
            facade.create_permission_table()
        elif option == 7:
            facade.drop_permissions_table()
        elif option == 8:
            id, permission_level = map(int, input(" Enter id and level: ").split())
            if not id or not permission_level:
                print(" Id or permission level is no integer")
                continue
            role = input(" Enter role: ")
            facade.add_new_permission(id, role, permission_level)
        elif option == 9:
            facade.delete_bad_tasks()
        elif option == 10:
            facade.get_version()
            facade.query_result()
        else:
            print(" Invalid option. Please, try again")
        input(" Press any key to continue\n ")


menu()