/* You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table. If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed. Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project. */

-- METHOD 1
WITH tmptable AS(
SELECT  p1.task_id, p1.start_date, p1.end_date, 
        CASE
            WHEN    Start_Date = (Select min(Start_Date) from projects) THEN 0
            WHEN    Start_Date = (Select p2.end_date from projects as p2 WHERE p2.end_date = p1.start_date) THEN 1
            ELSE    0
        END as isContinue
FROM    projects p1
ORDER BY p1.start_date
)
SELECT   min(start_date), max(end_date)
FROM
    (SELECT     task_id, start_date, end_date, isContinue,
            CASE
                WHEN isContinue = 0 THEN @startID := task_id
                ELSE    @startID
            END as startID
    FROM       tmptable as t1, (SELECT @startID := 0) as tmp
    ) as tmptable2
GROUP BY startID
ORDER BY COUNT(startID), 1


-- METHOD 2
SELECT 
  p.start_date, 
  (
    SELECT  min(p1.end_date) 
    FROM    projects p1 
    WHERE 
            p1.end_date not in (
                    SELECT  start_date 
                    FROM    projects
            ) 
            and p1.end_date > p.start_date
  ) as project_end_date 
FROM    projects p 
WHERE 
  p.start_date not in (
    SELECT  end_date 
    FROM    projects
  ) 
ORDER BY 
  project_end_date - p.start_date asc, 
  p.start_date asc
