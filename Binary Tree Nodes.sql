/* You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N. */

-- METHOD 1
CREATE VIEW temp AS
SELECT  n, 
        CASE
            WHEN (select count(*) from bst as b2 where b2.p = b1.n group by p limit 1)=2 THEN 1
            ELSE 0
        END AS isInner
FROM    bst as b1;

SELECT   n,
        CASE
            WHEN ISNULL(bst.p) = 1 then 'Root'
            WHEN temp.isInner = 1 then 'Inner'   
            ELSE 'Leaf'
        END AS node_type
FROM    bst 
INNER JOIN temp
USING (n)
ORDER BY n;


-- METHOD 2
WITH temp AS (
SELECT  n, 
        CASE
            WHEN (select count(*) from bst as b2 where b2.p = b1.n group by p limit 1)=2 THEN 1
            ELSE 0
        END AS isInner
FROM    bst as b1)

SELECT   n,
        CASE
            WHEN ISNULL(bst.p) = 1 then 'Root'
            WHEN temp.isInner = 1 then 'Inner'   
            ELSE 'Leaf'
        END AS node_type
FROM    bst 
INNER JOIN temp
USING (n)
ORDER BY n;


-- METHOD 3
SELECT N, 
        CASE WHEN P IS NULL THEN 'Root' 
        WHEN(SELECT COUNT(*) FROM BST WHERE P = b.N) > 0 THEN 'Inner'
        ELSE 'Leaf'
    END
FROM bst b 
ORDER BY N;


-- METHOD 4
SELECT b.N,
       (CASE WHEN b.P IS NULL THEN 'Root' 
             WHEN EXISTS (SELECT 1 FROM BST b2 WHERE b2.P = b.N) THEN 'Inner'
             ELSE 'Leaf'
        END)
FROM bst b 
ORDER BY N;
