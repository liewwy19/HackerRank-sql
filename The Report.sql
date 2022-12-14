/* You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks. Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who received a grade lower than 8. The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their name and list them by their grades in descending order. If there is more than one student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order. Write a query to help Eve. */

-- METHOD 1
WITH student_grade AS(
  SELECT 
    CASE WHEN grade >= 8 THEN name END AS name, 
    marks, grade 
  FROM students 
    INNER JOIN grades 
    ON marks BETWEEN min_mark AND max_mark
) 
SELECT 
  name, grade, marks 
FROM 
  student_grade 
ORDER BY 
  grade desc, 
  name asc, 
  marks asc
  

-- METHOD 2
SELECT Name,Grade,Marks FROM Students,Grades WHERE Marks BETWEEN Min_Mark AND Max_Mark and Grade>=8 ORDER BY Grade desc,Name;
SELECT null,Grade,Marks FROM Students,Grades WHERE Marks BETWEEN Min_Mark AND Max_Mark and Grade<8 ORDER BY Grade desc,Marks;
