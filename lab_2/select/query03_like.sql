-- Выбрать все "высшие школы" с проходным баллом 90+
SELECT college_name, passing_grade FROM colleges
WHERE college_name LIKE 'Higher school%' AND passing_grade >= 90