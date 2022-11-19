/* Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of challenges in which the hacker earned a full score. If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id. */

-- METHOD 1
SELECT      h.hacker_id, h.name
FROM        Submissions s, Challenges c, Difficulty d, Hackers h
WHERE       s.challenge_id = c.challenge_id
            AND c.difficulty_level = d.difficulty_level
            AND s.score = d.score
            AND s.hacker_id = h.hacker_id
GROUP by    s.hacker_id, h.name
HAVING      count(*) > 1
ORDER by    count(*) desc, s.hacker_id asc
