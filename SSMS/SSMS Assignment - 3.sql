
---> Assignment - 3

	select* from tblEmployeeDtl

	select* from Employees

	select * from tblDepartmentDtl

--> 1. Display all the employees data by sorting the date of joining in the ascending order and then by name in descending order.

	SELECT * 
	FROM tblEmployeeDtl
	ORDER BY JoiningDate, EmployeeName DESC
	
--> 2. Modify the column name EmployeeName to Employee_FirstName and also add another column Employee_LastName  

	EXEC sp_rename 'Employees.EmployeeName', 'Employee_FirstName', 'COLUMN'

	ALTER TABLE Employees
	ADD Employee_LastName VARCHAR(50)

--> 3. Write a query to change the table name to Employees. 
	
	EXEC sp_rename 'tblEmployeeDtl', 'Employees'

--> 4. Write a query to update the salary of those employees whose location is ‘Mysore’ to 35000. 

	UPDATE Employees
	SET Salary = 35000
	WHERE DepartmentID IN (SELECT DepartmentID
								FROM tblDepartmentDtl
								WHERE [Location] = 'Mysore')

--> 5. Write a query to disassociate all trainees from their department

	UPDATE Employees
	SET DepartmentID = NULL
	WHERE Designation LIKE '%TRAINEE%'; 

--> 6. Write a query which adds another column ‘Bonus’ to the table Employees where the bonus is equal to the salary multiplied by ten. Update 
--    the value only when the experience is two years or above.

	ALTER TABLE Employees
	ADD Bonus int;

	UPDATE Employees
	SET Bonus = Salary * 10
	WHERE DATEDIFF(YYYY, JoiningDate, GETDATE()) > 2;

--> 7. Display name and salary of top 5 salaried employees from Mysore and Hyderabad. 

	SELECT TOP 5 Employee_FirstName, Salary
	FROM Employees
	WHERE DepartmentID IN (SELECT DepartmentID
						   FROM tblDepartmentDtl
						   WHERE [Location] IN ('Mysore', 'Hyderabad'))

--> 8. Display name and salary of top 3 salaried employees(Include employees with tie)  

	SELECT TOP 3 with ties Employee_FirstName, Salary
	FROM Employees
	ORDER BY Salary DESC

--> 9. Display top 1% salaried employees from Noida and Bangalore 

	SELECT TOP 1 percent *
	FROM Employees
	WHERE DepartmentID IN (SELECT DepartmentID
						   FROM tblDepartmentDtl
						   WHERE [Location] IN ('Noida', 'Bangalore'))

--> 10. Find average and total salary for each job.

	SELECT AVG(Salary) AS 'Average Salary', SUM(Salary) AS 'Total Salary'
	FROM Employees
	GROUP BY Designation

--> 11. Find highest salary of all departments. 

	SELECT MAX(Salary)
	FROM Employees
	GROUP BY DepartmentID

--> 12. Find minimum salary of all departments. 

	SELECT MIN(Salary)
	FROM Employees
	GROUP BY DepartmentID 

--> 13. Find difference in highest and lowest salary for all departments.

	SELECT MAX(Salary) - MIN(Salary)
	FROM Employees
	GROUP BY DepartmentID

--> 14.  Find average and total salary for trainees 

	SELECT AVG(Salary), SUM(Salary)
	FROM Employees
	WHERE Designation = 'TRAINEE'

--> 15.  Count total different jobs held by dept no 30 

	SELECT COUNT(DISTINCT[Designation])
	FROM Employees
	WHERE DepartmentID = 30

--> 16. Find highest and lowest salary for non-managerial job 

	SELECT Designation,MAX(Salary), MIN(Salary)
	FROM Employees
	WHERE Designation NOT LIKE '%Manager%'
	GROUP BY Designation

--> 17. Count employees and  average annual salary of each department.

	 SELECT COUNT(*) AS 'Number of Employees' , AVG(Salary * 12) AS 'Annual Salary'
	 FROM Employees
	 GROUP BY DepartmentID

--> 18. Display the number of employees sharing same joining date. 

	SELECT COUNT(*)
	FROM Employees
	GROUP BY JoiningDate
	HAVING COUNT(*) > 1
	
--> 19. Display number of employees with same experience 

	SELECT COUNT(*)
	FROM Employees
	GROUP BY JoiningDate
	HAVING COUNT(*) > 1
	
--> 20. Display total number of employees in each department with same salary 

	SELECT DepartmentID, COUNT(*)
	FROM Employees
	GROUP BY DepartmentID, Salary

--> 21. Display the  number of Employees above 35 years in each department 

	SELECT DepartmentId, COUNT(*) AS 'Number of Employees'
	FROM Employees
	GROUP BY DepartmentID, JoiningDate
	HAVING DATEDIFF(YY, [JoiningDate], GETDATE()) >= 35


	UPDATE Employees
	SET JoiningDate = '10-01-1980'
	WHERE DepartmentID = 15


	select* from tblEmployeeDtl
	select* from Employees
	select * from tblDepartmentDtl



