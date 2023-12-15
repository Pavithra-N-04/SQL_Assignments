 
 --> Assignment - 1
  
	CREATE TABLE tblDirectors( 
	DirectorId SERIAL PRIMARY KEY, 
	FirstName VARCHAR(150) NOT NULL, 
	LastName VARCHAR(150) NOT NULL); 

	CREATE TABLE tblmovies( 
	MovieId SERIAL PRIMARY KEY, 
	MovieName VARCHAR(100) NOT NULL, 
	MovieLength INTEGER NOT NULL, 
	MovieLanguage VARCHAR(20) NOT NULL, 
	MovieCertificate VARCHAR(3) NOT NULL, 
	ReleaseDate DATE NOT NULL, 
	--DirectorId INTEGER REFERENCES tblDirectors(DirectorId)
	CONSTRAINTS DirectorID REFERENCES tblDirectors(DirectorId)); 

	CREATE TABLE tblActors( 
	ActorId SERIAL PRIMARY KEY, 
	FirstName VARCHAR(150) NOT NULL, 
	LastName VARCHAR(150) NOT NULL, 
	Gender CHAR(1) NULL, 
	DateOfBirth DATE NOT NULL, 
	MovieId INTEGER REFERENCES tblMovies(MovieId)); 

	INSERT INTO tblDirectors(FirstName, LastName) 
	VALUES 
	('Hemanth','Rao'), 
	('Maneesh','Sharma'), 
	('P','Vasu'), 
	('Rakesh','Kadri'), 
	('Devan','Jayakumar'), 
	('Yograj','Bhat'); 

	INSERT INTO tblMovies(MovieName, MovieLength, MovieLanguage, 
	MovieCertificate, ReleaseDate, DirectorId) 
	VALUES 
	('Sapta Saagaradaache', 180, 'Kannada', 'UA', '2011-01-01', 2), 
	('Tiger 3', 180, 'Hindi', 'A', '2023-11-23', 3), 
	('AptaRakshaka', 190, 'Kannada', 'U', '2015-03-17', 3), 
	('Girgit', 170, 'Tulu', 'U', '2019-06-13', 4), 
	('Valatty', 175, 'Malyalam', 'U', '2023-03-29', 5); 

	INSERT INTO tblActors(FirstName,LastName,Gender,DateOfBirth,MovieId) 
	VALUES 
	('Vishnu','Vardhan','M','1980-05-26',3), 
	('Vimala','Raman','F','1982-03-08',3), 
	('Rakshit','Shetty','M','1974-04-27',1), 
	('Rukmini','Vasant','F','1997-11-07',1), 
	('Salman','Khan','M','1968-04-18',2), 
	('Kathrina','Kaif','F','1979-10-28',2), 
	('Roopesh','Shetty','M','1991-10-14',4), 
	('Ruhani','Shetty','F','1993-08-24',4), 
	('Roshan','Mathew','M','1991-08-02',5), 
	('Raveena','Ravi','f','1993-12-24',5); 
	
	SELECT * FROM tblDirectors;
	SELECT * FROM tblMovies;
	SELECT * FROM tblActors;
	
	1. Display Movie name, movie language and release date from movies table.
	
		SELECT MovieName, MovieLanguage, ReleaseDate
		FROM tblMovies;
		
	2. Display only 'Kannada' movies from movies table. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE MovieLanguage = 'Kannada';
		
	3. Display movies released before 1st Jan 2011. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE ReleaseDate < '2011-01-01';
		
	4. Display Hindi movies with movie duration more than 150 minutes. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE MovieLanguage = 'Hindi' AND MovieLength > 150;
		
	5. Display movies of director id 3 or Kannada language. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE DirectorID = 3 OR MovieLanguage = 'Kannada';
		
	6. Display movies released in the year 2023. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE EXTRACT(YEAR FROM ReleaseDate) = 2023;
		
		SELECT MovieName
		FROM tblMovies
		WHERE EXTRACT(DAY FROM ReleaseDate) = 23 AND 
		EXTRACT(YEAR FROM ReleaseDate) = 2023 AND 
		EXTRACT(MONTH FROM ReleaseDate) = 11;
		
	7. Display movies that can be watched below 15 years. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE MovieCertificate = 'U';
		
	8. Display movies that are released after the year 2015 and directed by directorid 3.
	
		SELECT MovieName
		FROM tblMovies
		WHERE ReleaseDate > '2015-12-31' AND DirectorID = 3;
		
	9. Display all other language movies except Hindi language. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE MovieLanguage != 'Hindi';
		
	10. Display movies whose language name ends with 'u'. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE MovieLanguage LIKE '%u';
		
	11. Display movies whose language starts with 'm'. 
		
		SELECT MovieName
		FROM tblMovies
		WHERE MovieLanguage LIKE 'M%';
		
	12. Display movies with language name that has only 5 characters. 
	
		SELECT MovieName
		FROM tblMovies
		WHERE LENGTH(MovieLanguage) = 5;
		
	13. Display the actors who were born before the year 1980. 
	
		SELECT FirstName, DateOfBirth
		FROM tblActors
		WHERE DateOfBirth < '1980-12-31';
		
	14. Display the youngest actor from the actors table. 
	
		SELECT FirstName, DateOfBirth
		FROM tblActors
		ORDER BY DateOfBirth DESC LIMIT 1;
		
		SELECT FirstName, MIN(DateOfBirth)
		FROM tblActors
		GROUP BY FirstName, DateOfBirth
		ORDER BY DateOfBirth DESC LIMIT 1;
		
		SELECT *
		FROM tblActors
		ORDER BY DateOfBirth DESC
		OFFSET 0 ROWS
		FETCH FIRST 1 ROW WITH TIES;
		
	15. Display the oldest actor from the actors table. 
	
		SELECT FirstName
		FROM tblActors
		ORDER BY DateOfBirth LIMIT 1;
		
		SELECT FirstName,DateOfBirth
		FROM tblActors
		oRDER BY DateOfBirth LIMIT 1;
		
		SELECT *
		FROM tblActors
		ORDER BY DateOfBirth 
		OFFSET 0 ROWS
		FETCH FIRST 1 ROW WITH TIES;
	
	16. Display all the female actresses whose ages are between 30 and 35. 
	
		SELECT FirstName
		FROM tblActors
		WHERE Gender = 'F' AND EXTRACT(YEAR FROM AGE(NOW(), DateOfBirth)) BETWEEN 30 AND 35;
		
	17. Display the actors whose movie ids are in 1 to 5. 
	
		SELECT FirstName
		FROM tblActors
		WHERE MovieID BETWEEN 1 AND 5;
	
	18. Display the longest duration movie from movies table. 
	
		SELECT MovieName, MovieLength
		FROM tblMovies
		ORDER BY MovieLength DESC LIMIT 1;
		
		SELECT MovieName, MovieLength
		FROM tblMovies
		ORDER BY MovieLength DESC
		OFFSET 0 ROWS
		FETCH FIRST 1 ROW WITH TIES;
	
	19. Display the shortest duration movie from movies table. 
	
		SELECT MovieName, MovieLength
		FROM tblMovies
		GROUP BY MovieName, MovieLength
		ORDER BY MovieLength LIMIT 1;
		
		SELECT MovieName, MovieLength
		FROM tblMovies
		ORDER BY MovieLength
		OFFSET 0 ROWS
		FETCH FIRST 1 ROW WITH TIES;
	
	20. Display the actors whose name starts with vowels. 
	
		SELECT FirstName
		FROM tblActors
		WHERE FirstName ~ '^[AEIOUaeiou].*$';
		
		^ - caret
		--> This metacharacter matches the beginning of the string.
		*
		--> This metacharacter matches zero or more instances of the preceding character 
		----or character pattern.
		$
		--> This metacharacter matches the end of the string.	
		
	21. Display all the records from tblactors by sorting the data based on the first_name
		in the ascending order and date of birth in the descending order. 
	
		SELECT FirstName, DateOfBirth
		FROM tblActors
		ORDER BY FirstName, DateOfBirth DESC;
	
	22. Write a query to  return the data related to movies by arranging the data in 
		ascending order based on the movie_id and also fetch the data from the fifth value 
		to the twentieth value.
	
		SELECT *
		FROM tblMovies
		ORDER BY MovieID
		OFFSET 4 ROWS
		FETCH FIRST 15 ROWS ONLY;
	
	--> Assignment - 2
	
	CREATE TABLE departments 
	(department_id NUMERIC PRIMARY KEY, 
	department_name VARCHAR(20));

	CREATE TABLE employees 
	( employee_id NUMERIC PRIMARY KEY, 
	 department_id NUMERIC REFERENCES departments,
	first_name VARCHAR(20) NOT NULL,  
	last_name VARCHAR(20) NOT NULL, 
	email_id VARCHAR(20) UNIQUE,  
	phonenumber VARCHAR(20), 
	hire_date DATE DEFAULT CURRENT_DATE, 
	job_id VARCHAR(20), 
	salary NUMERIC CHECK (salary > 0),  
	manager_id NUMERIC REFERENCES employees  
	ON DELETE SET NULL ON UPDATE SET NULL, 
	commission_pct numeric(2,2) 
	); 

	CREATE TABLE job_history 
	( employee_id NUMERIC, 
	start_date DATE, 
	end_date DATE, 
	job_id VARCHAR(20), 
	department_id NUMERIC REFERENCES departments  
	ON DELETE SET NULL ON UPDATE SET NULL, 
	CONSTRAINT emp_date PRIMARY KEY (employee_id,start_date),  
	CONSTRAINT empid_fk foreign key (employee_id) references employees 
	ON DELETE SET NULL ON UPDATE SET NULL, 
	CONSTRAINT job_hist_date CHECK (start_date < end_date) 
	); 
	
	INSERT INTO departments VALUES(10, 'Training Academy');
	INSERT INTO departments VALUES(20, 'IT');
	INSERT INTO departments VALUES(30, 'Human Resource');
	INSERT INTO departments VALUES(40, 'Support');
	INSERT INTO departments VALUES(50, 'R&D');
	
	INSERT INTO employees VALUES(100, 10, 'Adam', 'Smith', 'adamsmith@gmail.com', 9988776655,
								 '1990-05-25', 2000, 50000, NULL, NULL);
	INSERT INTO employees VALUES(101, 10, 'Baby', 'Sona', 'babysona@gmail.com', 9988776644,
								'1985-08-20', 2001, 60000, 100, NULL);
	INSERT INTO employees VALUES(102, 20, 'Faf', 'Duplessis', 'faf@gmail.com', 9988776633,
								'2000-01-28', 2002, 40000, NULL, NULL);
	INSERT INTO employees VALUES(103, 20, 'Pat', 'Cummins', 'cummins@gmail.com', 9988776622,
								'2005-09-18', 2003, 50000, 102, NULL);
	INSERT INTO employees VALUES(104, 20,'Alex', 'King', 'alex@gmail.com', 9988776611,
								'2010-06-24', 2004, 35000, 102, NULL);
	INSERT INTO employees VALUES(105, 30,'Reena', 'John', 'reena@gmail.com', 9988776600,
								'2020-02-15', 2005, 25000, NULL, NULL);
	INSERT INTO employees VALUES(106, 30, 'Anil', 'Kumar', 'anil@gmail.com', 9988776511,
								'2022-05-30', 2006, 20000, 105, NULL);
	INSERT INTO employees VALUES(107, 40, 'Tanu', 'Gowda', 'tanu@gmail.com', 9988776001,
								'2023-10-18', 2007, 18000, NULL, NULL);
	INSERT INTO employees VALUES(108, 40, 'Uday', 'Shetty', 'uday@gmail.com', 9988776002,
								'2023-10-30', 2008, 16000, 107, NULL);
	INSERT INTO employees VALUES(109, 50, 'Sheena', 'Almeda', 'sheena@gmail.com', 99887766003,
								'2023-11-15', 2009, 15000, NULL, NULL);
								
	INSERT INTO job_history VALUES(100, '1990-05-25', NULL, 2000, 10);
	INSERT INTO job_history VALUES(101, '1985-08-20', NULL, 2001, 10);
	INSERT INTO job_history VALUES(102, '2003-01-28', NULL, 2002, 20);
	INSERT INTO job_history VALUES(103, '2005-09-18', NULL, 2003, 20);
	INSERT INTO job_history VALUES(104, '2010-06-24', NULL, 2004, 20);
	INSERT INTO job_history VALUES(105, '2020-02-15', NULL, 2005, 30);
	INSERT INTO job_history VALUES(106, '2022-05-30', NULL, 2006, 30);
	INSERT INTO job_history VALUES(107, '2023-10-18', NULL, 2007, 40);
	INSERT INTO job_history VALUES(108, '2023-10-30', NULL, 2008, 40);
	INSERT INTO job_history VALUES(109, '2023-11-15', NULL, 2009, 50);
	
	SELECT * FROM departments;
	SELECT * FROM employees;
	SELECT * FROM job_history;	

	1. Retrieve the information of all the employees working in the organization. 
		
		SELECT * 
		FROM employees;
		
	2. fetch the specific details like employee_id, first_name, email_id and salary from the 
		employees table. 
	
		SELECT employee_id, first_name, email_id, salary
		FROM employees;

	3. Display the department numbers in which employees are present. If the 
		department_id is present more than once then, only one value should be retrieved. 
	
		SELECT DISTINCT department_id
		FROM employees
		WHERE employee_id IS NOT NULL;

	4. Display different job roles that are available in the company. 
	
		SELECT DISTINCT job_id
		FROM job_history;

	5. Display the department data  in the ascending order and salary must be in descending order. 
	
		SELECT *
		FROM employees
		ORDER BY department_id, salary DESC;

	6. retrieve the details of all the employees working in 10th department. 
	
		SELECT * 
		FROM employees
		WHERE department_id = 10;

	7. details of the employees working in 10th department along with the employee 
		details whose earning is more than 40000. 
	
		SELECT *
		FROM employees
		WHERE department_id = 10 AND salary > 40000;

	8. display the last name and the job title of the employees who were not allocated to 
		the manager.
	
		SELECT last_name, job_id
		FROM employees
		WHERE manager_id IS NULL;

	9. Generate a report for the employees whose salary ranges from 5000 to 12000 and 
		they should either belongs to department 20 or department 50. Display the last name and 
		the salary of the employee.  
	
		SELECT last_name AS "Employee", salary AS "Monthly Salary"
		FROM employees
		WHERE salary BETWEEN 5000 AND 12000 AND department_id IN (20, 50);

	Note: Rename the column name as Employee instead of lastname  and Monthly Salary 
	instead of salary respectively. 

	10. the employees details who had joined in the year 2003 
	
		SELECT * 
		FROM employees
		WHERE EXTRACT(YEAR FROM hire_date) = 2003;	

	11. Write a query to display the last_name and number of  months for which the 
		employee have worked rounding the months_worked column to its nearest whole number.
	
	Hint: No of months should be calculated from the date of joining of an employee to 
	till date. 
	
		SELECT last_name, EXTRACT(YEAR FROM AGE(NOW(), Hire_Date)) * 12 + 
							EXTRACT(MONTH FROM AGE(NOW(), Hire_Date)) AS "Number of Months"
							FROM employees;
							
	12. calculate their spendings designation-wise from each department.
	
		SELECT department_id, job_id, SUM(salary) AS "Total Spending"
		FROM employees
		GROUP BY department_id, job_id;

	13. calculate the following details of the employees using aggregate function in a 
	department. 
	∙Employee with highest salary 
	∙Employee with lowest salary 
	∙Total salary of all the employees in the department  
	∙Average salary of the department 
	Write a query to display the output  rounding the resultant values to its nearest whole 
	number. 
	
	SELECT department_id, MAX(salary) AS "Highest Salary", MIN(salary) AS "Lowest Salary", 
			ROUND(SUM(Salary)) AS "Total Salary", ROUND(AVG(Salary)) AS "Average Salary"
	FROM employees
	GROUP BY department_id;
	
============================================================================================================	
	
	SELECT First_Name, Salary
	FROM employees
	WHERE Salary = ( SELECT MAX(Salary) FROM employees);
	
	SELECT First_Name, Salary
	FROM employees
	WHERE Salary = ( SELECT MIN(Salary) FROM employees);
	
	SELECT Department_ID, SUM(Salary)
	FROM employees
	GROUP BY Department_id;
	
	SELECT Department_ID, AVG(Salary)
	FROM employees
	GROUP BY Department_id;
	
	SELECT department_id,
	ROUND(MAX(Salary)) AS "Highest Salary",
	ROUND(MIN(Salary)) AS "Lowest Salary",
	ROUND(SUM(Salary)) AS "Total Salary",
	ROUND(AVG(Salary)) AS "Average Salary"
	FROM employees
	GROUP BY Department_id;

	14. Modify the result obtained in the previous exercise to display the minimum, 
	maximum, total and average salary for each job type. 
	
		SELECT MIN(Salary) AS "Lowest Salary", MAX(Salary) AS "Highest Salary", 
				SUM(Salary) AS "Total Salary", AVG(Salary) AS "Average Salary"
		FROM employees
		GROUP BY job_id;

	15. fetch the details of the departments having less than 3 employees and are working in 
	the department whose department_id is greater than 10.
	
		SELECT *
		FROM departments
		WHERE department_id > 10 AND department_id IN ( SELECT department_id
													    FROM employees
													    GROUP BY department_id
													    HAVING COUNT(*) < 3 );
		
	16. fetch the manager_id and the minimum salary of the employee reporting to him. 
	Arrange the result in descending order of the salaries excluding the details given below: 
	∙Exclude the employee whose manager is not mapped / not known. 
	∙Exclude the details if the minimum salary is less than or equal to 6000. 
	
		SELECT manager_id, MIN(Salary) AS "Minimum Salary"
		FROM employees
		WHERE manager_id IS NOT NULL
		GROUP BY manager_id
		HAVING MIN(Salary) <= 6000
		ORDER BY MIN(Salary) DESC;

	17. details of the employees who have never changed their job role in the company. 
	
		SELECT *
		FROM employees E
		WHERE NOT EXISTS (SELECT Employee_ID
						 FROM job_history J
						 WHERE J.employee_id = E.employee_id
						 GROUP BY J.employee_id
						 HAVING COUNT(DISTINCT J.job_id) > 1);							 								 

	18. fetch the employee names and their departments in which they are working.
	
		SELECT E.first_name, d.department_name
		FROM employees E
		INNER JOIN Departments D ON E.department_id = D.department_id;
		
	19. retrieve all the department information with their corresponding employee names 
		along with the newly added departments. 
	
		SELECT D.*, E.first_name
		FROM Departments D
		LEFT OUTER JOIN employees E ON D.department_id = E.department_id;

	20. details of the employee along with their managers. 
	
		SELECT E1.employee_id, E1.first_name, E2.manager_id, E2.first_name AS "Manager Name"
		FROM employees E1
		INNER JOIN employees E2 ON E1.manager_id = E2.manager_id;

	21. employee details who are reporting to the same manager as Maria reports to.
	
		SELECT *
		FROM employees
		WHERE manager_id = (SELECT manager_id
		                    FROM employees
							WHERE first_name = 'Maria');

	22. fetch the details of the employees working in the Executive department. 
	
		SELECT *
		FROM employees E
		INNER JOIN departments D ON E.Department_id = D.department_id 
		WHERE department_name = 'Executive';
		
	23. fetch the details of employee whose salary is greater than the average salary of all 
	the employees. 
	
		SELECT *
		FROM employees
		WHERE Salary > (SELECT AVG(Salary)
						FROM employees);
	
	24. Write a query which displays all Ellens colleague's names. Label the name as "Ellen's 
	colleague".  
	Hint: If an employee is Ellen's colleague then their department_id will be same. 
	
		SELECT first_name AS Ellen's Collegue
		FROM employees
		WHERE department_id = ( SELECT department_id 
							  FROM employees
							  WHERE first_name = 'Ellen') AND first_name != 'Ellen'; 
		
	25. which employees from adminstration team is/are earning less than all the 
	employees.
		
		SELECT * 
		FROM departments D
		INNER JOIN employees E ON D.department_id = E.department_id
		WHERE department_name = 'Administration' AND Salary < ( SELECT MIN(Salary)
															    FROM employees);	
	
	26.  Write a query to display the last name and salary of those who reports to King. 
	
		SELECT last_name, Salary
		FROM employees
		WHERE manager_id = (SELECT employee_id
						    FROM employees
						    WHERE last_name = 'Duplessis');
	
	27. Write a query to display the below requirement.   
		Fetch employee id and first name of who work in a department with the employees having 
		‘u’ in the  last_name.  
	
		SELECT employee_id, first_name, last_name
		FROM employees
		WHERE last_name LIKE '%u%';
		
	28.the employee who is getting highest pay in the specific department. 
	
		SELECT first_name
		FROM employees E
		WHERE (department_id, Salary) = ( SELECT department_id, MAX(Salary)
					     				  FROM employees
										  WHERE department_id = 10
					     				  GROUP BY department_id );
				
	29. the details of different employees who have atleast one person reporting to them.
	
		SELECT *
		FROM employees
		WHERE employee_id IN (SELECT DISTINCT manager_id
							   FROM employees);
		
	30. the departments which was formed but it does not have employees working in 
	them currently. 
	
		SELECT department_name
		FROM departments 
		WHERE department_id NOT IN (SELECT DISTINCT department_id
								     FROM employees);
	
	31. Grouping Sets: number of employees present in each department and for every job role. 
	32. RollUp: collect the count of the total employees in their company along with the 
				count of employees in each department based on their job_id. 
	33. Cube: identify the number of employees present in their company. They also need a 
				report which states the count for each department_id, job_id along with the number of 
				employees present in the department according to their job role.  


	1. List the different languages of movies.
	
		SELECT DISTINCT MovieLanguage
		FROM tblMovies;
 
	2. Display the unique first names of all directors in ascending order by their first name and 
		then for each group of duplicates, keep the first row in the returned result set.
	
		SELECT DISTINCT firstname
		FROM tbldirectors
		ORDER BY firstName;
	  
	3.  write a query to retrieve 4 records starting from the fourth one, to display the actor ID, 
		name (first_name, last_name) and date of birth, and arrange the result as Bottom N rows 
		from the actors table according to their date of birth.  

		SELECT ActorID, FirstName, LastName, dateofbirth
		FROM tblactors
		ORDER BY dateofbirth DESC
		OFFSET 3 ROWS
		LIMIT 4;

	4. Write a query to get the first names of the directors who holds the letter 'S' or 'J' in the 
		first name.    

		SELECT firstname
		FROM tbldirectors
		WHERE FirstName LIKE '%S%' OR FirstName LIKE '%J%';

-- 5. Write a query to find the movie name and language of the movie of all the movies where the 
		director name is Joshna.

		SELECT MovieName, movielanguage
		FROM tblmovies
		WHERE FirstName = 'Joshna';

	6. Write a query to find the number of directors available in the movies table.

		SELECT COUNT(DISTINCT FirstName) AS "Number of Directors"
		FROM tblDirectors;

	7.  Write a query to find the total length of the movies available in the movies table.

		SELECT SUM(MovieLength) AS "Total Length of all the Movies"
		FROM tblMovies;

	8. Write a query to get the average of movie length for all the directors who are working 
		for more than 1 movie.
		
		SELECT D.DirectorID, COUNT(MovieID) AS "Number of Movies", AVG(MovieLength)
		FROM tblDirectors D
		INNER JOIN tblMovies M ON D.DirectorID = M.DirectorID
		GROUP BY D.DirectorID
		HAVING COUNT(*) > 1;

-- 9. Write a query to find the age of the actor vijay for the year 2001-04-10.

		SELECT DateOfBirth, AGE('2001-04-10', DateOfBirth) AS Age
		FROM tblActors
		WHERE FirstName = 'Rakshit';

	10. Write a query to fetch the week of this release date 2020-10-10 13:00:10.

		SELECT DATE_PART('WEEK', DATE '2020-10-10 13:00:10') AS ReleaseWeek;

	11. Write a query to fetch the day of the week and year for this release date 2020-10-10 13:00:10.    
		
		SELECT TO_CHAR(DATE '2020-10-10 13:00:10', 'DAY') AS "Day Name", 
				EXTRACT(YEAR FROM DATE '2020-10-10 13:00:10') AS "Year";

	12. Write a query to convert the given string '20201114' into date and time.
		
		SELECT TO_TIMESTAMP('20201114', 'YYYYMMDD');
		
		------SELECT TO_DATE('20201114', 'YYYYMMDD');------Displays only date
		
		SELECT TO_TIMESTAMP('14112020', 'DDMMYYYY');

	13. Display Todays date.

		SELECT CURRENT_DATE AS "Todays Date";

	14. Display Todays date with time.

		SELECT NOW() AS "Todays Date with Time";

	15. Write a query to add 10 Days 1 Hour 15 Minutes to the current date.

		SELECT CURRENT_DATE + INTERVAL '10 DAY 1 HOUR 15 MINUTES';

	16. Write a query to find the details of those actors who contain eight or more characters 
		in their first name.

		SELECT * 
		FROM tblactors
		WHERE LENGTH(firstname) >= 8;

	 17. Write a query to join the text 'movie' with the movie_name column.

		SELECT CONCAT('Movie ', MovieName) 
		FROM tblMovies;

	18. Write a query to get the actor id, first name and birthday month of an actor.

		SELECT ActorID, FirstName, EXTRACT(MONTH FROM DateOfBirth) AS MONTH
		FROM tblActors;

	19. Write a query to get the actor id, last name to discard the last three characters.

		SELECT ActorID, LEFT(LastName, LENGTH(LastName) - 3)
		FROM tblActors;

	20. Write a query that displays the first name and the character length of the first name 
		for all directors whose name starts with the letters 'A', 'J' or 'V'. Give each column an 
		appropriate label. Sort the results by the directors first names.

		SELECT FirstName, LENGTH(FirstName)
		FROM tblDirectors
		WHERE FirstName LIKE 'A%' OR FirstName LIKE 'J%' OR FirstName LIKE 'V%' 
		ORDER BY FirstName;

	21. Write a query to display the first word in the movie name if the movie name contains more 
		than one words.

		SELECT SUBSTRING(MovieName, 1, POSITION(' ' IN MovieName)) AS "First Word of the Movie"
		FROM tblMovies
		WHERE MovieName ILIKE '% %';

	Module 9: 

	22. Write a query to display the actors name with movie name.   
	
		SELECT A.FirstName, MovieName
		FROM tblActors A
		LEFT OUTER JOIN tblMovies M ON A.MovieID = M.MovieID;

	23. Write a query to make a join with three tables movies, actors, and 
		directors to display the movie name, director name, and actors date of birth. 
		
		SELECT MovieName, D.FirstName, DateOfBirth
		FROM tblMovies M
		INNER JOIN tblActors A ON M.MovieID = A.MovieID
		INNER JOIN tblDirectors D ON M.DirectorID = D.DirectorID;

	24. Write a query to make a join with two tables directors and movies to 
		display the status of directors who is currently working for the movies above 1. 
 
 		SELECT D.DirectorID, COUNT(MovieID) AS "Status"
		FROM tblDirectors D
		INNER JOIN tblMovies M ON D.DirectorID = M.DirectorID
		GROUP BY D.DirectorID
		HAVING COUNT(*) > 1;
		
	25. Write a query to make a join with two tables movies and actors to get 
		the movie name and number of actors working in each movie. 
 		
		SELECT MovieName, COUNT(A.ActorID)
		FROM tblMovies M
		INNER JOIN tblActors A ON M.MovieID = A.MovieID
		GROUP BY M.MovieID;
		
	26. Write a query to display actor id, actors name (first_name, last_name) and movie name to 
		match ALL records from the movies table with each record from the actors table.   
		
		SELECT ActorID, FirstName, LastName, MovieName
		FROM tblMovies 
		CROSS JOIN tblActors;

--> CTE: A Common Table Expression (CTE) is the result set of a query which exists temporarily 
		and for use only within the context of a larger query. Much like a derived table, 
		the result of a CTE is not stored and exists only for the duration of the query.
		
		CTE stands for common table expression. A CTE allows you to define a temporary named result set 
		that available temporarily in the execution scope of a statement such as SELECT, INSERT, 
		UPDATE, DELETE, or MERGE.
		
--> SQL Script to create tblEmployee table:

	CREATE TABLE tblEmp(
	 EmpId INT Primary Key,
	 EmpName varchar(30),
	 Gender varchar(10),
	 DeptId INT
	)
	
--> SQL Script to create tblDepartment table:

	CREATE TABLE tblDept(
	DeptId INT Primary Key,
	DeptName varchar(20)
	)
	
--> Insert data into tblDepartment table:

	Insert into tblDept values (1,'IT');
	Insert into tblDept values (2,'Payroll');
	Insert into tblDept values (3,'HR');
	Insert into tblDept values (4,'Admin');
	
--> Insert data into tblEmployee table:

	Insert into tblEmp values (1,'John', 'Male', 3);
	Insert into tblEmp values (2,'Mike', 'Male', 2);
	Insert into tblEmp values (3,'Pam', 'Female', 1); 
	Insert into tblEmp values (4,'Todd', 'Male', 4);
	Insert into tblEmp values (5,'Sara', 'Female', 1);
	Insert into tblEmp values (6,'Ben', 'Male', 3);
 
	SELECT * FROM tblEmp;

	SELECT * FROM tblDept;

	--> syntax for creating a CTE.:

	WITH cte_name (Column1, Column2, ..)
	AS
	( CTE_query )

--> SQL query using CTE:

	With EmployeeCount(DeptId, TotalEmployees)
	as
	(
		Select E.DeptId, COUNT(*) as TotalEmployees
		from tblEmp E
		group by E.DeptId
	)
	
	Select DeptName, TotalEmployees
	from tblDept D
	join EmployeeCount EC
	on D.DeptId = EC.DeptId
	order by TotalEmployees
	
	---> Using CTE:

	With EmployeeCount(DeptName, DeptId, TotalEmployees)
	as
	(
		Select DeptName, D.DeptId, COUNT(*) as TotalEmployees
		from tblEmp E
		join tblDept D
		on E.DeptId = D.DeptId
		group by DeptName, D.DeptId
	)
	
	Select DeptName, DeptId, TotalEmployees
	from EmployeeCount
	where TotalEmployees >= 2
	
	--> UPDATE JOHNs gender from Male to Female, using the Employees_Name_Gender CTE 
	
	With Employees_Name_Gender
	as
	(
	Select EmpId, EmpName, Gender from tblEmp
	)
	Update Employees_Name_Gender 
	Set Gender = 'Female' 
	where EmpId = 1

--> update this CTE. Let's change JOHN's Gender from Female to Male. Here, the CTE is based on 2 tables, but the UPDATE statement 
	affects only one base table tblEmployee. So the UPDATE succeeds. So, if a CTE is based on more than one table, and if the 
	UPDATE affects only one base table, then the UPDATE is allowed. 

	With EmployeesByDepartment
	as
	(
	Select EmpId, EmpName, Gender, DeptName 
	from tblEmp E
	join tblDept D
	on D.DeptId = E.DeptId
	)
	Update EmployeesByDepartment 
	SET Gender = 'Male' 
	WHERE EmpId = 1

--> UPDATE the CTE, in such a way, that the update affects both the 
	tables - tblEmployee and tblDepartment. This UPDATE statement changes 
	Gender from tblEmployee table and DeptName from tblDepartment table. When 
	you execute this UPDATE, you get an error stating - 'View or function 
	EmployeesByDepartment is not updatable because the modification affects multiple 
	base tables'. So, if a CTE is based on multiple tables, and if the UPDATE statement 
	affects more than 1 base table, then the UPDATE is not allowed.
 
	With EmployeesByDepartment
	as
	(
	Select EmpId, EmpName, Gender, DeptName 
	from tblEmp E
	join tblDept D
	on D.DeptId = E.DeptId
	)
	Update EmployeesByDepartment set 
	Gender = 'Female', DeptName = 'IT'
	where EmpId = 1 

--> CTE, that returns Employees by Department

	With EmployeesByDepartment
	as
	(
	Select EmpId, EmpName, Gender, DeptName 
	from tblEmp E
	join tblDept D
	on D.DeptId = E.DeptId
	)
	Select * from EmployeesByDepartment 
 
 
--> UPDATE just the DeptName. Let's change JOHN's DeptName from HR to IT. Before, you execute the UPDATE statement, 
	notice that BEN is also currently in HR department.

	With EmployeesByDepartment
	as
	(
	Select EmpId, EmpName, Gender, DeptName 
	from tblEmp E
	join tblDept D
	on D.DeptId = E.DeptId
	)
	Update EmployeesByDepartment 
	set DeptName = 'IT'
	where EmpId = 1
	
	After you execute the UPDATE. Select data from the CTE, and you will see that 
	BENs DeptName is also changed to IT. 
	
	WITH CTE AS(
		SELECT Empid, gender
		FROM tblEmp
		WHERE EmpID = 2)
		
	UPDATE tblEmp
	SET GENDER = 'FEMALE'
	FROM CTE
	WHERE tblEmp.EmpID = CTE.EmpID
	
	SELECT * FROM tblEmp;
	
--> How are CTEs helpful?
	1. Needing to reference a derived table multiple times in a single query.
	2. An alternative to creating a view in the database.
	3. Performing the same calculation multiple times over across multiple query components.
	
--> Why use CTE instead of temp table?
	1. CTEs are typically held in memory, which means that they can be accessed and manipulated quickly. 
	2. Temporary tables, on the other hand, are usually written to disk, which can cause a performance 
	overhead. 
	3. Usage : CTEs are usually used for smaller data sets that require more complex manipulation.

--> Why use CTE vs subquery?
	A CTE can be used many times within a query, whereas a subquery can only be used once. 
	This can make the query definition much shorter, but it won't necessarily result in improved 
	performance. Subqueries can be used in a WHERE clause in conjunction with the keywords 
	IN or EXISTS , but you can't do this with CTEs.

--> What is a CTE in SQL and why would you use it how does it improve query readability and 
	maintainability?
	It is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE 
	statement in SQL. CTEs are a valuable SQL feature that allows you to simplify complex queries, 
	break them into smaller, more manageable parts, and improve the readability and maintainability 
	of your SQL code.
	
--> What is the advantage of SQL CTE?
	SQL CTEs: Usage, Advantages, and Drawbacks - Unlike subqueries, CTEs can be used multiple times 
	within the same query, simplifying complex queries and improving query performance. 
	By breaking up queries into smaller, logical pieces, SQL CTEs can also enhance readability, 
	making code easier to understand and maintain.
	
--> recursive CTE:

	Declare @RowNo int =1;
	with ROWCTE as  
	   (  
		  SELECT @RowNo as ROWNO    
	UNION ALL  
		  SELECT  ROWNO+1  
	  FROM  ROWCTE  
	  WHERE RowNo < 10
		)  

	SELECT * FROM ROWCTE 


	A CTE that references itself is called as recursive CTE. Recursive CTEs can be of great help 
	when displaying hierarchical data. Example, displaying employees in an organization hierarchy.
	
	Let's create tblEmployee table, which holds the data, that's in the organization chart.
	
	CREATE TABLE tblEmp
	(
	  EmpId int Primary key,
	  EmpName varchar(20),
	  ManagerId int
	)

	Insert into tblEmp values (1, 'Tom', 2)
	Insert into tblEmp values (2, 'Josh', null)
	Insert into tblEmp values (3, 'Mike', 2)
	Insert into tblEmp values (4, 'John', 3)
	Insert into tblEmp values (5, 'Pam', 1)
	Insert into tblEmp values (6, 'Mary', 3)
	Insert into tblEmp values (7, 'James', 1)
	Insert into tblEmp values (8, 'Sam', 5)
	Insert into tblEmp values (9, 'Simon', 1)

	
	A recursive common table expression (CTE) is a CTE that references itself. By doing so, the CTE repeatedly executes, returns subsets of data, until it returns the complete result set.

	A recursive CTE is useful in querying hierarchical data such as organization charts where one employee reports to a manager or multi-level bill of materials when a product consists of many components, and each component itself also consists of many other components.

	The following shows the syntax of a recursive CTE:

	WITH expression_name (column_list)
	AS
	(
		-- Anchor member
		initial_query  
		UNION ALL
		-- Recursive member that references expression_name.
		recursive_query  
	)
	-- references expression name
	SELECT *
	FROM   expression_name
	Code language: SQL (Structured Query Language) (sql)
	In general, a recursive CTE has three parts:

	An initial query that returns the base result set of the CTE. The initial query is called an 
	anchor member.
	A recursive query that references the common table expression, therefore, it is called the 
	recursive member. The recursive member is union-ed with the anchor member using the UNION ALL 
	operator.
	A termination condition specified in the recursive member that terminates the execution of the 
	recursive member.
	The execution order of a recursive CTE is as follows:

	First, execute the anchor member to form the base result set (R0), use this result for the next 
	iteration.
	Second, execute the recursive member with the input result set from the previous iteration (Ri-1) 
	and return a sub-result set (Ri) until the termination condition is met.
	Third, combine all result sets R0, R1, … Rn using UNION ALL operator to produce the final result set.

	A) Simple SQL Server recursive CTE example
	This example uses a recursive CTE to returns weekdays from Monday to Saturday:

	WITH cte_numbers(n, weekday) 
	AS (
		SELECT 
			0, 
			DATENAME(DW, 0)
		UNION ALL
		SELECT    
			n + 1, 
			DATENAME(DW, n + 1)
		FROM    
			cte_numbers
		WHERE n < 6
	)
	SELECT 
		weekday
	FROM 
		cte_numbers;
		
-> Along with Employee and their Manager name, we also want to display their level in the organization.
		
  (
    Select EmpId, EmpName, ManagerId, 1
    from tblEmployee
    where ManagerId is null
    
    union all
    
    Select tblEmployee.EmployeeId, tblEmployee.Name, 
    tblEmployee.ManagerId, EmployeesCTE.[Level] + 1
    from tblEmployee
    join EmployeesCTE
    on tblEmployee.ManagerID = EmployeesCTE.EmployeeId
  )
	Select EmpCTE.Name as Employee, Isnull(MgrCTE.Name, 'Super Boss') as Manager, 
	EmpCTE.[Level] 
	from EmployeesCTE EmpCTE
	left join EmployeesCTE MgrCTE
	on EmpCTE.ManagerId = MgrCTE.EmployeeId
	
--1.  Create a stored procedure that updates a user's email and logs the change in a transaction

	CREATE OR REPLACE PROCEDURE update_user_email(user_id INT, new_email VARCHAR) 
	AS $$ 
	DECLARE 
		-- Variables for transaction and exception handling 
		is_error BOOLEAN DEFAULT FALSE; 
	BEGIN 
		-- Start the transaction 
		BEGIN 
			-- Update the user's email 
			UPDATE users SET email = new_email WHERE id = user_id; 

			-- Log the change 
			INSERT INTO user_log(user_id, action, timestamp) 
			VALUES (user_id, 'Email updated', NOW()); 

		EXCEPTION 
			-- Handle exceptions 
			WHEN OTHERS THEN 
				-- Set the error flag to true 
				is_error := TRUE; 

				-- Log the exception 
				INSERT INTO error_log(message, timestamp) 
				VALUES ('Error updating email for user ' || user_id || ': ' || SQLERRM, NOW()); 
		END; 

		-- Check if an error occurred during the transaction 
		IF is_error THEN 
			-- Rollback the transaction 
			ROLLBACK; 
			RAISE EXCEPTION 'Transaction failed. Please check the error logs.'; 
		ELSE 
			-- Commit the transaction 
			COMMIT; 
		END IF; 
	END; 
	$$ 
	LANGUAGE plpgsql; 

-- 2. Create a stored procedure that calculates total salary for a department and updates budget 

	CREATE OR REPLACE PROCEDURE calculate_department_salary(department_id INT) 
	AS $$ 
	DECLARE 
		total_salary DECIMAL; 
	BEGIN 
		-- Start the transaction 
		BEGIN 
			-- Calculate total salary for the department 
			SELECT SUM(salary) INTO total_salary FROM employees WHERE department_id = department_id; 

			-- Update the department's budget 
			UPDATE departments SET budget = budget - total_salary WHERE id = department_id; 

			-- Log the transaction 
			INSERT INTO transaction_log(description, timestamp) 
			VALUES ('Total salary calculated and budget updated for department ' || department_id, 
					NOW()); 

		EXCEPTION 
			-- Handle exceptions 
			WHEN OTHERS THEN 
				-- Log the exception 
				INSERT INTO error_log(message, timestamp) 
				VALUES ('Error calculating salary for department ' || department_id || ': ' || SQLERRM, 
						NOW()); 

				-- Rollback the transaction 
				ROLLBACK; 

				-- Raise an exception 
				RAISE EXCEPTION 'Transaction failed. Please check the error logs.'; 
		END; 
		-- Commit the transaction 
		COMMIT; 
	END; 
	$$ 
	LANGUAGE plpgsql; 
	
--> Assignment - 13 PSQL

	CREATE TABLE departments
  (
   department_id INT PRIMARY KEY,
   department_name VARCHAR(100)
  );

	CREATE TABLE students
	(
	  student_id INT PRIMARY KEY,
	  student_name VARCHAR(100),
	  department_id INT REFERENCES department(department_id),
	  stipend INT
	);

	INSERT INTO department VALUES
	(1, 'Science'),
	(2, 'Commerce'),
	(3, 'Bio-Chemistry'),
	(4, 'Bio-Medical'),
	(5, 'Fine Arts'),
	(6, 'Literature'),
	(7, 'Animation'),
	(8, 'Marketing');

	select student_id, student_name,student_department,stipend
	from students order by student_id limit 20

	INSERT INTO Students VALUES
	(1, 'Hadria', 7, 2000),
	(2, 'Trumann', 2, 2000),
	(3, 'Earlie', 3, 2000),
	(4, 'Monika', 4, 2000),
	(5, 'Aila', 5, 2000),
	(6, 'Trina', 5, 2000),
	(7, 'Esteban', 3, 2000),
	(8, 'Camilla', 1, 2000),
	(9, 'Georgina', 4, 2000),
	(10, 'Reed', 6, 16000),
	(11, 'Northrup', 7, 2000),
	(12, 'Tina', 2, 2000),
	(13, 'Jonathan', 2, 2000),
	(14, 'Renae', 7, 2000),
	(15, 'Sophi', 6, 16000),
	(16, 'Rayner', 3, 2000),
	(17, 'Mona', 6, 16000),
	(18, 'Aloin', 5, 2000),
	(19, 'Florance', 5, 2000),
	(20, 'Elsie', 5, 2000);
	
	SELECT * FROM department;
	SELECT * FROM Students;

--> stored procedures:
	
	1. Write a stored procedure to insert values into the student table and also update the 
		student_department/department_id to 7 when the student_id is between 400 and 700.
		
		CREATE OR REPLACE PROCEDURE usp_StudentInsertUpdate(P_student_id INT, p_student_name VARCHAR(50), 
															p_department_id INT, p_stipend INT)
		LANGUAGE plpgsql
		AS $$
		BEGIN
			INSERT INTO Students(student_id, student_name, department_id, stipend)
			VALUES(p_student_id, p_student_name , p_department_id, p_stipend);
			
				UPDATE Students
				SET department_id = 7
				WHERE student_id BETWEEN 400 AND 700;
		END; $$
		
		CALL usp_StudentInsertUpdate (450, 'Anil', 5, 4000);

	2. Write a procedure to update the department name to 'Animation' when the department id is 7. 
		This command has to be committed.
		Write another statement to delete the record from the students table based on the studentid 
		passed as the input parameter.This statement should not be committed.
		
		CREATE OR REPLACE PROCEDURE usp_UpdateDepartment(p_student_id INT)
		LANGUAGE plpgsql
		AS $$
		BEGIN
			UPDATE department
			SET department_name = 'Animation'
			WHERE department_id = 7;
			COMMIT;
			
			DELETE FROM students
			WHERE student_id = p_student_id;
			ROLLBACK;
		END; $$
		
		CALL usp_UpdateDepartment(8);
		
		SELECT * FROM department;
			
	3. Write a procedure to display the sum, average, minimum and maximum values of the column stipend 
		from the students table.
		
		CREATE OR REPLACE PROCEDURE usp_StudentStipend(
		INOUT "SUM" INT = 0,
		INOUT "AVG" INT = 0,
		INOUT "MIN" INT = 0,
		INOUT "MAX" INT = 0
		)
		LANGUAGE plpgsql
		AS $$
		BEGIN
			SELECT SUM(stipend), AVG(stipend),  MIN(stipend),  MAX(stipend) 
			INTO "SUM", "AVG", "MIN", "MAX"
			FROM students;	
		END; $$
		
		CALL usp_StudentStipend();
			
	=====================================================================================================

--> subqueries:
	
	1. Fetch all the records from the table students where the stipend is more than 'Florance'
	
		SELECT *
		FROM Students
		WHERE stipend > ( SELECT stipend
						  FROM students
						  WHERE student_name = 'Florance');
						  
	2. Return all the records from the students table who get more than the minimum stipend for the 
		department 'FineArts'.
		
		SELECT *
		FROM students
		WHERE stipend > ( SELECT MIN(stipend)
						  FROM students
						  WHERE department_id = ( SELECT department_id
												  FROM department
												  WHERE department_name = 'Fine Arts'));
												  
		SELECT *
		FROM students
		WHERE stipend > ( SELECT MIN(stipend)
						  FROM students S
						  INNER JOIN department D ON S.department_id = D.department_id
						  WHERE department_name = 'Fine Arts');
							  
	=====================================================================================================
	
--> Questions based on the employee table:
	
	1. Using a subquery, list the name of the employees, paid more than 'Fred Costner' from employees.
	
		SELECT First_name
		FROM employees
		WHERE Salary > ( SELECT Salary
					     FROM employees
					     WHERE First_name = 'Fred');

	2. Find all employees who earn more than the average salary in their department.
	
		SELECT First_name, Salary
		FROM employees E
		WHERE Salary > ( SELECT AVG(Salary) AS "Average Salary"
					     FROM employees
						 WHERE department_id = E.department_id
					     GROUP BY department_id);

	3. Write a query to select those employees who does not work in those department where the managers 
		of ID between 100 and 200 works.
		
		SELECT First_name
		FROM employees
		WHERE department_id NOT IN ( SELECT department_id
							    	 FROM employees 
							    	 WHERE manager_id BETWEEN 100 AND 200);

	4. Find employees who have at least one person reporting to them.
	
		SELECT First_name, employee_id
		FROM employees
		WHERE employee_id IN ( SELECT DISTINCT manager_id
						       FROM employees
							   WHERE manager_id IS NOT NULL);
							   
		SELECT First_name, employee_id
		FROM employees
		WHERE employee_id IN ( SELECT DISTINCT manager_id
							   FROM employees
							   GROUP BY manager_id
							   HAVING COUNT(employee_id) >= 1);
							   
	============================================================================================
	
	CTE assignment:
	
	1. Write a query to fetch the student_name,stipend and department_name from the students and 
		departments table where the student_id is between 1 to 5 AND stipend is in the range of 
		2000 to 4000.
		
		WITH StudentDetails(student_name, stipend, department_name)
		AS
		(
			SELECT student_name, stipend, department_name
			FROM students S
			INNER JOIN department D ON S.department_id = D.department_id
			WHERE student_id BETWEEN 1 AND 5 AND stipend BETWEEN 2000 AND 4000
		)
		
		SELECT student_name, stipend, department_name
		FROM StudentDetails;
		
	2. Write a query to fetch the sum value of the stipend from the students table based on the 
		department_id where the departments 'Animation' and 'Marketing' should not be included and the 
		sum value should be less than 4000.
		
		WITH StudentStipendSum(department_id, department_name, stipend)
		AS
		(
			SELECT D.department_id, D.department_name, SUM(Stipend) AS "Sum Value of Stipend"
			FROM students S
			INNER JOIN department D ON S.department_id = D.department_id
			WHERE department_name NOT IN ('Animation', 'Marketing') 
			GROUP BY D.department_id
			HAVING SUM(Stipend) < 4000
		)
		
		SELECT SUM(stipend) AS "Sum Value of Stipend"
		FROM StudentStipendSum;
		
	3. Using the concept of multiple cte, fetch the maximum value, minimm value, average and sum of 
		the stipend based on the department and return all the values.
		
		WITH MaxStipend(department_id, MaxStipend)
		AS
		(
			SELECT department_id, MAX(Stipend)
			FROM students 
			GROUP BY department_id
		),
		MinStipend(department_id, MinStipend)
		AS
		(
			SELECT department_id, MIN(Stipend)
			FROM students 
			GROUP BY department_id
		),
		AvgStipend(department_id, AvgStipend)
		AS
		(
			SELECT department_id, AVG(Stipend)
			FROM students 
			GROUP BY department_id
		),
		SumStipend(department_id, SumStipend)
		AS
		(
			SELECT department_id, SUM(Stipend)
			FROM students 
			GROUP BY department_id
		)
		
		SELECT Mx.department_id, MaxStipend, MinStipend, AvgStipend, SumStipend
		FROM MaxStipend Mx
		INNER JOIN MinStipend Mn ON Mx.department_id = Mn.department_id
		INNER JOIN AvgStipend A ON Mn.department_id = A.department_id
		INNER JOIN SumStipend S ON A.department_id = S.department_id;
	
	===============================================================================================
	
---> USER DEFINED FUNCTION(UDF) 
 
	PostgreSQL allows the users to extend the database functionality with the help 
	of various procedural language elements such as user-defined functions and 
	stored procedures.  
	The major difference between stored procedure and user-defined function is 
	that the function returns a result set whereas the stored procedure does not 
	return any result set. 

	A user defined PostgreSQL function is a group of arbitrary SQL statements 
	designated to perform some task. It is possible to perform select, insert, 
	update, delete operations within a function.       

	User-defined functions are created using the following syntax : 

	CREATE FUNCTION function_name(p1 type, p2 type) 
	RETURNS type AS 
	BEGIN 
	 -- logic 
	END; 
	LANGUAGE language_name; 

	Here,  
	function_name denotes the name of the function which is being created. 
	parameter_name is the name of the parameter which is passed to the function 
	and the corresponding datatype is assigned to it. The parameter name is 
	optional. 
	The return type is mentioned after the parameter list to signify the datatype of 
	the result which is returned after the function has been executed.  
	Next the BEGIN and END keywords are used to place the logic of the 
	function which is created. Operations like arithmetic calculations, data 
	modifications etc can be written within the code block. 
	Finally, after the logic of the entire function is completed, the language_name 
	is specified . Here it is plpgsql. 
	
	Example: 
	we will develop a very simple function named inc that increases an integer by 1 and 
	returns the result.
	
	CREATE FUNCTION inc(val integer)  
	RETURNS integer AS $$ 
	BEGIN 
	RETURN val + 1; 
	END; $$ 
	LANGUAGE PLPGSQL; 

	You can call the inc function like any built-in functions as follows: 
	SELECT inc(20); 
	SELECT inc(inc(20)); 

	Example for creating a user-defined function without parameter: 
	
		CREATE FUNCTION get_student_count()
		RETURNS INT
		LANGUAGE plpgsql
		AS
		$$
		DECLARE
			student_count INT;
		BEGIN
			SELECT COUNT(*)
			INTO student_count
			FROM students;
			
			RETURN student_count;
			
		END;
		$$;
		
		SELECT get_student_count();
		SELECT * FROM students;

	Here, an user-defined function get_student_count() is created without any parameters. The 
	table students has 2 records and the role of the function get_student_count() is to fetch the 
	count of the students present and store it in a variable and then the variable is obtained in 
	the result using the RETURN keyword. 
	User-defined functions with parameters/arguments can also be created.
	
	An example for parameterized function is: 
	
		CREATE FUNCTION fetch_details(age_val INT)
		RETURNS INT
		LANGUAGE plpgsql
		AS
		$$
		DECLARE 
			final_count INT;
		BEGIN
			SELECT COUNT(*) INTO final_count
			FROM students
			WHERE age = age_val;
			
			RETURN final_count;
			
		END;
		$$;
		
		SELECT fetch_details(23);
		
		ALTER TABLE students
		ADD Age INT;
		
		SELECT * FROM students;
			
	Here, only the count of the students whose age matches with the input parameter 
	has been returned to the function. In the above example the records having age as 
	27 is returned.
	Creating a function using pgAdmin:
	
		SELECT inc(10, 20); 
		
	Calling a user-defined function: 
	PostgreSQL provides you with three ways to call a user-defined function: 
	1. Using positional notation 
	2. Using named notation 
	3. Using the mixed notation. 
	
	1)Using positional notation:
	
		select inc(10, 20);
	
	2)Using named notation: 
	
		select inc( 
			i => 10,  
			val => 20 
		); 

		select inc( 
			i := 10,  
			val := 20 
		);

	3)Using the mixed notation: 
	
		select inc(10, val => 20); 







 
 
 
                    
 
 
		
		
		
	



