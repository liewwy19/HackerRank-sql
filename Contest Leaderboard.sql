/* You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too! The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of  from your result. */

-- METHOD 1
SELECT      Hackers.hacker_id, name, sum(max_score) as total_score
FROM        Hackers
            JOIN  (
                    SELECT  hacker_id, challenge_id, max(score) as max_score
                    FROM    submissions
                    GROUP BY hacker_id, challenge_id
            ) as tmpTable
            USING (hacker_id)
GROUP BY    hacker_id, name
HAVING      sum(max_score) > 0
ORDER BY    total_score desc, Hackers.hacker_id asc


-- METHOD 2
SELECT    X.hacker_id, 
          (SELECT H.NAME FROM HACKERS H WHERE H.HACKER_ID = X.HACKER_ID) as NAME, 
          SUM(X.SCORE) as TOTAL_SCORE 
FROM      (
              SELECT HACKER_ID, MAX(SCORE) SCORE FROM SUBMISSIONS S GROUP BY 1, S.CHALLENGE_ID
          ) as X 
GROUP BY 1
HAVING TOTAL_SCORE > 0
ORDER BY TOTAL_SCORE DESC, HACKER_ID;
