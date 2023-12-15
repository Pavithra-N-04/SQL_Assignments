
	--> ASSIGNMENT - 1

	--> 1. Create Employee table.

	use payroll;
	create table tblEmployee
	(
	EmployeeId int,
	EmployeeName varchar(50),
	Designation varchar(50),
	JoinedDate datetime,
	EmailId varchar(50),
	Salary money,
	EmployeeLocation varchar(50),
	DepartmentId int
	);

	drop table tblEmployee;

	insert into tblEmployee values
	(100, 'Pavithra_', 'Trainee Software Engineer', '10/16/2023', 'pavithra.n@excelindia.com', 15000, 'Mysuru', 10);
	insert into tblEmployee values
	(101, 'Bhoomika M R', 'Trainee Software Engineer', '10/16/2023', 'bhoomika.n@excelindia.com', 15000, 'Mysuru', 10);
	insert into tblemployee values
	(202, 'Pooja', 'Software Engineer', '01/16/2022', 'pooja.n@excelindia.com', 25000, 'Bangalore', 20);
	insert into tblemployee values
	(403, 'Anjali', 'Associate Software Engineer', '12/16/2021', 'anjali.n@excelindia.com', 50000, 'Hyderabad', 30);
	insert into tblEmployee values
	(500, 'Prajwal', 'Manager', '05/25/2023', 'prajwal.n@excelindia.com', 35000, 'Noida', 30);
	insert into tblEmployee values
	(105, 'Sagar', 'Business Analyst', '10/18/2022', 'Sagar.n@excelindia.com', 20000, 'Mysuru', 50);
	insert into tblemployee values
	(108, 'Manu', 'DB Administrator', '08/16/2016', 'Manu.n@excelindia.com', 60000, 'Mysuru', 60);
	insert into tblemployee values
	(106, 'Nishanth', 'HR Manager', '02/16/2020', 'Nishant.n@excelindia.com', 40000, 'Mysuru', 70);
	insert into tblemployee values
	(108, 'Vathsala', 'Senior Manager', '08/16/2016', 'Vathsala.n@excelindia.com', 60000, 'Mysuru', 60);
	insert into tblemployee values
	(106, 'Subbu', 'HR Associate', '02/16/2020', 'Subbu.n@excelindia.com', 40000, 'Mysuru', 70);
	insert into tblemployee values
	(106, 'Subbu', 'HR Associate', '02/01/2020', 'Subbu.n@excelindia.com', 40000, 'Mysuru', 70);
	insert into tblemployee values
	(106, 'Subbu K', 'HR Associate', '02/01/2020', 'Subbu.n@excelindia.com', 40000, 'Mysuru', 70);
		
	--> 2. Display table information.
	SELECT *
	FROM tblEmployee;
 
	EXEC sp_help tblEmployee;

	--> 3. Display Employees name,  EmployeeId, departmentId  from tblEmployee. 
	SELECT EmployeeName, EmployeeId, DepartmentID
	FROM tblEmployee;

	--> 4. Display Employees name,  EmployeeId, departmentId  of department 20 and 40. 
	SELECT EmployeeName, EmployeeId, DepartmentId
	FROM tblEmployee
	WHERE DepartmentId IN (20,40);

	--> 5. Display information about all 'Trainee Software Engineer'  having salary less than 20000. 
	SELECT *
	FROM tblEmployee
	WHERE Designation = 'Trainee Software Engineer' AND Salary < 20000;

	--> 6. Display information about all employees of department 30 having salary greater than 20000.
	SELECT *
	FROM tblEmployee
	WHERE DepartmentId = 30 AND Salary > 20000;

	--> 7. Display list of employees who are not allocated with Department. 
	SELECT *
	FROM tblEmployee
	WHERE DepartmentID IS NULL;

	--> 8. Display name and department of all ‘ Business Analysts’. 
	SELECT EmployeeName, DepartmentId
	FROM tblEmployee
	WHERE Designation = 'Business Analyst';

	--> 9.	Display name, Designation and salary of all the employees of department 30 who earn 
	--		more than 20000 and less than 40000. 
	SELECT EmployeeName, Designation, Salary
	FROM tblEmployee
	WHERE DepartmentId = 30 AND Salary BETWEEN 20001 AND 39999;

	--> 10.Display unique job of tblEmployee. 
	SELECT DISTINCT Designation
	FROM tblEmployee
	ORDER BY Designation;

	--> 11. Display list of employees who earn more than 20000 every year of department 20 and 30. 
	SELECT *
	FROM tblEmployee
	WHERE Salary>20000 AND DepartmentID IN (20,30);

	--> 12.  List Designation, department no and Joined date in the format of Day, Month, and Year of 
	--		department 20. 
	SELECT Designation, DepartmentId, Day(JoinedDate) AS 'Day', MONTH(JoinedDate) AS 'Month', YEAR(JoinedDate) AS 'Year'
	FROM tblEmployee
	WHERE DepartmentId = 20;

	SELECT Designation, DepartmentId, FORMAT(GETDATE(), 'dd-MM-yyyy') 
	FROM tblEmployee
	WHERE DepartmentId = 20;

	--> 13. Display employees whose name starts with an vowel 
	SELECT *
	FROM tblEmployee
	--WHERE EmployeeName LIKE 'a%' OR EmployeeName LIKE 'e%' OR EmployeeName LIKE 'i%' OR EmployeeName LIKE 'o%' OR EmployeeName LIKE 'u%' OR EmployeeName LIKE 'A%' OR EmployeeName LIKE 'E%' OR EmployeeName LIKE 'I%' OR EmployeeName LIKE 'O%' OR EmployeeName LIKE 'U%';
	WHERE EmployeeName LIKE '[aeiouAEIOU]%';

	--> 14. Display employees whose name is less than 10 characters 
	SELECT *
	FROM tblEmployee
	WHERE LEN(EmployeeName) < 10;

	--> 15. Display employees who have ‘N’ in their name 
	SELECT *
	FROM tblEmployee	
	WHERE EmployeeName LIKE 'N%';

	--> 16. Display the employees with more than three years of experience 
	SELECT *
	FROM tblEmployee
	WHERE DATEDIFF(year,JoinedDate,GETDATE())>3;

	--> 17. Display employees who joined on Monday 
	SELECT *
	FROM tblEmployee
	WHERE DATENAME(dw,JoinedDate) IN ('Monday');

	-- 18. Display employees who joined on 1st. 
	SELECT *, EmployeeName
	FROM tblEmployee
	--WHERE DAY(JoiningDate)=1;
	WHERE DATEPART(DD, JoinedDate) = 1;

	--> 19. Display all Employees joined in January 
	SELECT *
	FROM tblEmployee
	WHERE MONTH(JoinedDate) IN (01);

	--> 20. Display Employees with their Initials. 
	SELECT *
	FROM tblEmployee
	WHERE EmployeeName LIKE '% _%';

