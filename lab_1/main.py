import hashlib
from faker import Faker
from random import randint, choice, shuffle, random
from time import time

faker = Faker()

number = 5000
college_number = 500
themes_number = 1000
courses_number = 800
homework_number = 2500
task_number = 4000
comment_number = 3000
enrolls_number = 2500

teachers = []
students = []
subject_codes = []
themes = []
subjects = ['Russian language', 'Algebra', 'Geometry', 'Computer graphics',
                'Taco making', 'Blietzkriek', 'Anime', 'Gamedev',
                'History', 'Geography', 'Chemistry', 'Biology', 'Physics',
                'Sociology', 'Grazhdanskay oborona', 'Astronomy', 'Music',
                'Grappling', 'Sambo', 'Tatar belt fighting', 'OOP']


def generate_accounts():
    global faker
    f_accounts = open('src/accounts.csv', 'w')
    f_students = open('src/students.csv', 'w')
    f_teachers = open('src/teachers.csv', 'w')

    purposes = ["improving marks", "preparation for EGE", "preparation for GIA",
                "self-improvment", "preparation for olympiad", "improvment of qualification"]
    red_diploma = [True, False]
    qualifications = ['bachelor', 'master', 'specialist', 'doctor']
    account_levels = ["free", "improved", "vip"]

    for i in range(number):
        profile = faker.simple_profile()

        email = profile["mail"]
        gender = profile["sex"]
        name = profile["name"]
        date = profile["birthdate"]
        login = profile["username"]
        salt = faker.password()
        account_type = 'teacher' if randint(0, 10) > 8 else 'student'

        hash = hashlib.md5((faker.password() + salt).encode('utf-8'))
        row = "{0},{1},{2},{3},{4},{5},{6},{7}\n".format(
            email,
            name,
            gender,
            date,
            account_type,
            login,
            salt,
            hash.hexdigest()
        )
        f_accounts.write(row)

        account_id = i + 1
        if account_type == 'student':
            students.append(account_id)
            grade = randint(1, 11)
            purpose = choice(purposes)
            rating = randint(0, 1000)
            account_level = choice(account_levels)
            row = "{0},{1},{2},{3},{4}\n".format(
                account_id,
                grade,
                purpose,
                account_level,
                rating
            )
            f_students.write(row)
        else:
            teachers.append(account_id)
            education_code = randint(1, college_number)
            profile_subject = choice(subject_codes)
            has_red_diploma = choice(red_diploma)
            exam_result = randint(80, 100)
            degree = choice(qualifications)
            rating = round(random() * 5, 3)
            row = "{0},{1},{2},{3},{4},{5},{6}\n".format(
                account_id,
                education_code,
                profile_subject,
                has_red_diploma,
                exam_result,
                degree,
                rating
            )
            f_teachers.write(row)

    f_accounts.close()
    f_students.close()
    f_teachers.close()
    print("--Accounts generated!--")


def generate_colleges():
    college_names = ['University', 'Estate', 'College', 'Higher school', 'Institute', 'Home']

    college_top = [i + 1 for i in range(college_number)]
    shuffle(college_top)

    global faker
    f_colleges = open('src/colleges.csv', 'w')
    for i in range(college_number):
        college_name = choice(college_names) + ' of ' + faker.bs()
        number_of_places = randint(25, 1500)
        passing_grade = randint(55, 100)
        rating = college_top[i]
        address = faker.street_address()
        site = faker.url()
        phone_number = faker.phone_number()
        row = "{0},{1},{2},{3},{4},{5},{6}\n".format(
            college_name,
            number_of_places,
            passing_grade,
            rating,
            address,
            site,
            phone_number
        )
        f_colleges.write(row)
    f_colleges.close()
    print("--Colleges generated!--")


def generate_subjects():
    f_subject = open("src/subjects.csv", 'w')
    codes = [i for i in range(10, 99)]
    shuffle(codes)

    global faker
    for i in range(len(subjects)):
        subject = subjects[i]
        code = codes[i]
        subject_codes.append(code)
        row = "{0},{1}\n".format(
            code,
            subject
        )
        f_subject.write(row)
    f_subject.close()
    print("--Subjects generated!--")


def generate_themes():
    f_themes = open("src/themes.csv", 'w')
    codes = [i for i in range(1000, 9999)]
    shuffle(codes)

    global faker
    for i in range(themes_number):
        subject_num = randint(0, len(subject_codes) - 1)
        subject = subject_codes[subject_num]
        code = int(str(subject_codes[subject_num]) + str(codes[i]))
        themes.append(code)
        name = faker.word() + " " + faker.word() + " in " + subjects[subject_num].lower()
        row = "{0},{1},{2}\n".format(
            code,
            subject,
            name
        )
        f_themes.write(row)
    f_themes.close()
    print("--Subjects generated!--")


def generate_courses():
    f_courses = open("src/courses.csv", 'w')

    global faker
    for i in range(courses_number):
        teacher_id = choice(teachers)
        subject_code = choice(subject_codes)
        price = randint(0, 50000)
        row = "{0},{1},{2}\n".format(
            teacher_id,
            subject_code,
            price
        )
        f_courses.write(row)
    f_courses.close()
    print("--Courses generated!--")


def generate_homeworks():
    f_homeworks = open("src/homeworks.csv", 'w')

    global faker
    for i in range(homework_number):
        course_id = randint(1, courses_number)
        rating_cost = randint(0, 20)
        deadline = faker.future_date()
        row = "{0},{1},{2}\n".format(
            course_id,
            rating_cost,
            deadline
        )
        f_homeworks.write(row)
    f_homeworks.close()
    print("--Homeworks generated--")


def generate_tasks():
    f_task = open("src/tasks.csv", 'w')

    global faker
    for i in range(task_number):
        homework_id = randint(1, homework_number)
        code = choice(themes)
        author_id = choice(teachers)
        text = faker.sentence()
        solution = faker.sentence()
        publication_date = faker.date_of_birth()
        rating = randint(-110, 110)
        row = "{0},{1},{2},{3},{4},{5},{6}\n".format(
            homework_id,
            code,
            author_id,
            text,
            solution,
            publication_date,
            rating
        )
        f_task.write(row)
    f_task.close()
    print("--Tasks generated!--")


def generate_comments():
    f_task = open("src/comments.csv", 'w')

    global faker
    for i in range(task_number):
        author_id = choice(students)
        task_id = randint(1, task_number)
        text = faker.sentence()
        date = faker.date_of_birth()
        rating = randint(-10, 10)
        row = "{0},{1},{2},{3},{4}\n".format(
            author_id,
            task_id,
            text,
            date,
            rating
        )
        f_task.write(row)
    f_task.close()
    print("--Comments generated!--")


def generate_enrolls():
    f_enrolls = open("src/enrolls.csv", 'w')
    enrolls = []

    global faker
    for i in range(enrolls_number):
        student_id = choice(students)
        course_id = randint(1, courses_number)
        if [student_id, course_id] in enrolls:
            continue;
        enrolls.append([student_id, course_id])
        row = "{0},{1}\n".format(
            student_id,
            course_id
        )
        f_enrolls.write(row)
    f_enrolls.close()
    print("--Enrolls generated--")


def generate_data():
    print("--Generation started!--")
    start = time()
    generate_subjects()
    generate_accounts()
    generate_colleges()
    generate_themes()
    generate_courses()
    generate_homeworks()
    generate_tasks()
    generate_comments()
    generate_enrolls()
    print("--Generation took {:0.2f} seconds".format(time() - start))


generate_data()



