/* Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively. */

-- METHOD 1
SELECT MAX(DOCTOR_NAMES), MIN(PROFESSOR_NAMES), MIN(SINGER_NAMES), MIN(ACTOR_NAMES)
FROM
  (
    SELECT
      CASE WHEN occupation = 'Doctor' THEN name END AS DOCTOR_NAMES,
      CASE WHEN occupation = 'Professor' THEN name END AS PROFESSOR_NAMES,
      CASE WHEN occupation = 'Singer' THEN name END AS SINGER_NAMES,
      CASE WHEN occupation = 'Actor' THEN name END AS ACTOR_NAMES,
      CASE
        WHEN occupation = 'Doctor' THEN (@d := @d + 1)
        WHEN occupation = 'Professor' THEN (@p := @p + 1)
        WHEN occupation = 'Singer' THEN (@s := @s + 1)
        WHEN occupation = 'Actor' THEN (@a := @a + 1)
      END AS ROW_NUM
    FROM OCCUPATIONS, (select @d :=0) as tmpD, (select @p :=0) as tmpP, (select @s :=0) as tmpS, (select @a :=0) as tmpA 
    ORDER BY name
  ) AS tmpTable
GROUP BY ROW_NUM;


-- METHOD 2
SELECT
    Doctor, Professor, Singer, Actor
FROM (
    SELECT
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    FROM (
            SELECT
                Occupation, Name,
                rank() over(partition by Occupation order by Name ASC) as NameOrder
            FROM Occupations
         ) as NameLists
    GROUP BY NameOrder
    ) as Names
    
    
-- METHOD 3
SET @r1=0, @r2=0, @r3=0, @r4=0;
SELECT MIN(DOCTOR), MIN(PROFESSOR), MIN(SINGER), MIN(ACTOR)
FROM(
  SELECT CASE WHEN Occupation = 'Doctor' THEN (@r1:=@r1+1)
              WHEN Occupation = 'Professor' THEN (@r2:=@r2+1)
              WHEN Occupation = 'Singer' THEN (@r3:=@r3+1)
              WHEN Occupation = 'Actor' THEN (@r4:=@r4+1) 
         END AS RowNumber,
    CASE WHEN Occupation = 'Doctor' THEN name END AS Doctor,
    CASE WHEN Occupation = 'Professor' THEN name END AS Professor,
    CASE WHEN Occupation = 'Singer' THEN name END AS Singer,
    CASE WHEN Occupation = 'Actor' THEN name END AS Actor
  FROM OCCUPATIONS
  ORDER BY name
) tmpTable
GROUP BY RowNumber;


-- METHOD 4
SET @d=0, @a=0, @p=0, @s=0;
SELECT MIN(Doctor),MIN(Professor),MIN(SINGER),MIN(Actor)
FROM
(SELECT IF(Occupation='Actor',name,NULL) AS Actor,
        IF(Occupation='Doctor',name,NULL) AS Doctor,
        IF(Occupation='Professor',name,NULL) AS Professor,
        IF(Occupation='Singer',name,NULL) AS SINGER,
 CASE Occupation
    WHEN 'Actor' THEN @a:=@a+1
    WHEN 'Doctor' THEN @d:=@d+1
    WHEN 'Professor' THEN @p:=@p+1
    WHEN 'Singer' THEN @s:=@s+1
 END
AS tmpN FROM OCCUPATIONS ORDER BY name) AS tmpTable 
GROUP BY tmpTable.tmpN;
