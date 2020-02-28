--THESE ARE THE CHALLENGE QUERIES
--rename the to_date in titles to to_date_title to enable final mentor clean file
--extracts unduplicated count of employees using most recent title only as part of the select query
--enables the analyst to avoid the use of partitioning to remove duplicates
--seemed less invasive and quicker
--I refer the analyst to: https://www.postgresqltutorial.com/postgresql-rename-column/
ALTER TABLE titles
RENAME to_date TO to_date_title;

--Number of titles retiring
SELECT ei.emp_no,
	ei.first_name,
	ei.last_name,
	ei.salary,
	ti.title,
	ti.to_date_title,
	ti.from_date
INTO titles_retiring
FROM emp_info AS ei
INNER JOIN titles AS ti
ON (ei.emp_no = ti.emp_no)
WHERE ti.to_date_title = ('9999-01-01');

--titles by employee count per title
SELECT COUNT(ti.emp_no), ti.title
INTO  count_by_title
FROM titles_retiring as ti
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY ti.title
ORDER BY ti.title;

--final mentor list
SELECT ei.emp_no,
	ei.last_name,
	ei.first_name,
	ei.birth_date,
	ti.title,
	de.to_date
INTO mentees
FROM employees AS ei
INNER JOIN titles AS ti
ON (ei.emp_no = ti.emp_no)
INNER JOIN dept_employee AS de
ON (ei.emp_no = de.emp_no)
WHERE de.to_date = ('9999-01-01')
AND ti.to_date_title = ('9999-01-01')
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY ei.last_name;


--series of selects to examine data for counts, layout etc.
SELECT * FROM mentees;
SELECT * FROM count_by_title;
SELECT * FROM titles_retiring;