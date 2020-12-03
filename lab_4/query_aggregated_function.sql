-- Пользовательская агрегратная функция CLR
-- Получить средний рейтинг, максимальный и минимальный
-- рейтинг комментариев конкретного студента

CREATE OR REPLACE FUNCTION get_average_rating(id_ INT) 
RETURNS TABLE(name VARCHAR, average FLOAT, min FLOAT, max FLOAT)
AS $$
student_ratings = plpy.execute('SELECT s.id, c.rating FROM students s JOIN commentary c ON s.id = c.author_id')
name_ = plpy.execute('SELECT name FROM students s JOIN accounts a ON s.id = a.id WHERE a.id = ' + str(id_))[0]['name']
average_rating, max_rating, min_rating = 0, -10000, 10000
cnt = 0

for row_ in student_ratings:
	if row_['id'] == id_:
		average_rating += row_['rating'] 
		cnt += 1
		if row_['rating'] > max_rating:
			max_rating = row_['rating']
		if row_['rating'] < min_rating:
			min_rating = row_['rating']
			
average_rating = 0 if cnt == 0 else average_rating
value_dict = {'name' : student_ratings[0], 'average': average_rating, 'min': min_rating, 'max': max_rating}
return [value_dict]
$$ LANGUAGE plpython3u;
			
SELECT * FROM get_average_rating(6609);
