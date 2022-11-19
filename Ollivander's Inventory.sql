/* Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age. */

-- METHOD 1
SELECT  (SELECT id FROM wands tmp WHERE tmp.code = tmpTable.code AND tmp.coins_needed = tmpTable.min_coins) as id, 
        age,  min_coins, power
FROM
    (
    SELECT  w.code, w.age, w2.power, count(*), min(w2.coins_needed) as min_coins
    FROM    wands_property w
    INNER JOIN  wands w2
    USING (code) 
    WHERE   w.is_evil = 0
    GROUP BY w2.power, w.age, w.code
    ) as tmpTable
ORDER BY power desc, age desc


-- METHOD 2
SELECT W.ID, P.age, W.COINS_NEEDED, W.power 
FROM wands AS W
JOIN wands_property AS P
ON (W.code = P.code) 
WHERE P.IS_EVIL = 0 AND W.COINS_NEEDED = (SELECT MIN(COINS_NEEDED) 
                                          FROM wands AS X
                                          JOIN wands_property AS Y 
                                          ON (X.code = Y.code) 
                                          WHERE X.power = W.power AND Y.age = P.age) 
ORDER BY W.power DESC, P.age DESC;
