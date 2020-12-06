-- Пользовательская агрегратная функция CLR
-- Получить средний рейтинг, максимальный и минимальный
-- рейтинг комментариев конкретного студента

CREATE OR REPLACE FUNCTION get_average_rating(id_ INT) 
RETURNS TABLE(name VARCHAR, average FLOAT, min FLOAT, max FLOAT)
AS $$
student_ratings = plpy.execute('SELECT s.id, c.rating FROM students s JOIN commentary c ON s.id = c.author_id')
name_ = plpy.execute('SELECT name FROM students s JOIN accounts a ON s.id = a.id WHERE a.id = ' + str(id_))[0]['name']

student_ratings_ = filter(lambda value: row['id'] == id_, student_ratings)

max_rating = max(student_ratings_, key=lambda row_: row_['rating'])
min_rating = min(student_ratings_, key=lambda row_: row_['rating'])
cnt = len(student_ratings_)
average_rating = 0 if cnt == 0 else sum(students_ratings_) / cnt

value_dict = {'name' : student_ratings[0], 'average': average_rating, 'min': min_rating, 'max': max_rating}
return [value_dict]
$$ LANGUAGE plpython3u;
			
SELECT * FROM get_average_rating(6609);
