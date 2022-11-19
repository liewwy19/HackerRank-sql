/* Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result. */

-- METHOD 1
WITH tmpTable AS (
SELECT hacker_id, name, count(challenge_id) AS total_number
FROM    Hackers
JOIN    Challenges 
USING (hacker_id)
GROUP BY hacker_id, name
)
SELECT  t.hacker_id, t.name, t.total_number
FROM    tmpTable t, (SELECT @max_number := max(t2.total_number) FROM tmpTable t2) AS tmp
WHERE   NOT EXISTS (    SELECT  t3.hacker_id
                        FROM    tmpTable AS t3
                        WHERE   t3.total_number = t.total_number
                                AND t3.hacker_id <> t.hacker_id
                                AND t3.total_number <> @max_number
        )
ORDER BY 3 desc, 1 asc


-- METHOD 2
SELECT H.hacker_id, 
       H.name, 
       COUNT(C.challenge_id) AS C_COUNT
FROM HACKERS H
JOIN CHALLENGES C ON C.hacker_id = H.hacker_id
GROUP BY H.hacker_id, H.name
HAVING C_COUNT = 
    (SELECT COUNT(C2.challenge_id) AS C_MAX
     FROM CHALLENGES AS C2
     GROUP BY C2.hacker_id 
     ORDER BY C_MAX DESC LIMIT 1)
OR C_COUNT IN 
    (SELECT DISTINCT C_COMPARE AS C_UNIQUE
     FROM (SELECT H2.hacker_id, 
                  H2.name, 
                  COUNT(challenge_id) AS C_COMPARE
           FROM HACKERS H2
           JOIN CHALLENGES C ON C.hacker_id = H2.hacker_id
           GROUP BY H2.hacker_id, H2.NAME) COUNTS
     GROUP BY C_COMPARE
     HAVING COUNT(C_COMPARE) = 1)
ORDER BY C_COUNT DESC, H.hacker_id;
