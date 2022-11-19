/*
A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
*/

-- METHOD 1
SELECT  ROUND(lat_n,4)
FROM    (
            SELECT  lat_n, rank() over (order by lat_n) AS tmpRank
            FROM    station
        ) AS tmpTable
WHERE   tmpRank IN (SELECT ROUND(count(*)/2) as median_rank FROM station)


-- METHOD 2
WITH temp AS
(
select count(*) as total_records  
from    station 
)

SELECT  ROUND(lat_n,4)
FROM    (
            SELECT  lat_n, @rownum := @rownum +1 AS tmpRank
            FROM    station, (SELECT @rownum := 0) as tmpTR
            order by lat_n
        ) AS tmpTable
        , (SELECT @tr := ROUND(total_records/2) FROM temp) AS tmpTR
WHERE   tmpRank = @tr


-- METHOD 3
SELECT  ROUND(s.lat_n,4) 
FROM    station AS s 
WHERE   (SELECT count(lat_n) FROM station where lat_n < s.lat_n) = (SELECT count(lat_n) FROM station WHERE lat_n > s.lat_n);


-- METHOD 4
SELECT  ROUND(s1.lat_n, 4) 
FROM    STATION AS s1 
WHERE   (SELECT ROUND(COUNT(s1.ID)/2) FROM STATION) = (SELECT COUNT(s2.ID) FROM STATION AS s2 WHERE s2.lat_n >= s1.lat_n);
