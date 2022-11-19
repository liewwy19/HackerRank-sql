/* Amber's conglomerate corporation just acquired some new companies. Write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code. */

-- METHOD 1
SELECT 
  DISTINCT company_code, founder, lm_count, sm_count, m_count, e_count 
FROM 
  company AS c 
  INNER JOIN (
    SELECT 
      count(DISTINCT lead_manager_code) AS lm_count, 
      company_code 
    FROM 
      lead_manager 
    GROUP by 
      company_code
  ) AS lm USING (company_code) 
  INNER JOIN (
    SELECT 
      count(DISTINCT senior_manager_code) AS sm_count, 
      company_code 
    FROM 
      senior_manager 
    GROUP by 
      company_code
  ) AS sm USING (company_code) 
  INNER JOIN (
    SELECT 
      count(DISTINCT manager_code) AS m_count, 
      company_code 
    FROM 
      manager 
    GROUP by 
      company_code
  ) AS m USING (company_code) 
  INNER JOIN (
    SELECT 
      count(DISTINCT employee_code) AS e_count, 
      company_code 
    FROM 
      employee 
    GROUP by 
      company_code
  ) AS e USING (company_code) 
ORDER BY 
  company_code


-- METHOD 2
SELECT  company_code, founder,
        (SELECT COUNT(DISTINCT lead_manager_code) FROM lead_manager WHERE company_code = C.company_code),
        (SELECT COUNT(DISTINCT senior_manager_code) FROM senior_manager WHERE company_code = C.company_code),
        (SELECT COUNT(DISTINCT manager_code) FROM MANAGER WHERE company_code = C.company_code),
        (SELECT COUNT(DISTINCT employee_code) FROM employee WHERE company_code = C.company_code)
FROM    company C
ORDER BY company_code;


-- METHOD 3
SELECT 
  c.company_code, 
  c.founder, 
  count(distinct l.lead_manager_code), 
  count(distinct s.senior_manager_code), 
  count(distinct m.manager_code), 
  count(distinct e.employee_code) 
FROM 
  Company as c 
  JOIN Lead_Manager as l on c.company_code = l.company_code 
  JOIN Senior_Manager as s on l.lead_manager_code = s.lead_manager_code 
  JOIN Manager as m on m.senior_manager_code = s.senior_manager_code 
  JOIN Employee as e on e.manager_code = m.manager_code 
GROUP BY 
  c.company_code, 
  c.founder 
ORDER BY 
  c.company_code;
