
--> Assignment - 4

-- Two table Join Questions:
--> 1. Display All employees with their Department Names(Exclude the employees not allocated with department)

	SELECT tblEmployeeDtl.*, DepartmentName
	FROM tblEmployeeDtl
	INNER JOIN tblDepartmentDtl ON tblEmployeeDtl.DepartmentID = tblDepartmentDtl.DepartmentID

--> 2. Display employees joined in the year 2020 with their Department Names

	SELECT tblEmployeeDtl.*, DepartmentName
	FROM tblEmployeeDtl
	INNER JOIN tblDepartmentDtl ON tblEmployeeDtl.DepartmentID = tblDepartmentDtl.DepartmentID
	WHERE DATENAME(YYYY, JoiningDate) = 2020

--> 3. Display employees who work in their hometown  with their Department Names(Exclude the employees not allocated with department)
	
	SELECT tblEmployeeDtl.*, DepartmentName
	FROM  tblEmployeeDtl
	INNER JOIN tblDepartmentDtl ON tblEmployeeDtl.DepartmentID = tblDepartmentDtl.DepartmentID
	WHERE tblEmployeeDtl.[Location] = tblDepartmentDtl.[Location]

--> 4. Display All Departments with their employees(Include departments without Employees too)

   SELECT * FROM tblDepartmentDtl


	SELECT tblDepartmentDtl.*, EmployeeName
	FROM tblDepartmentDtl
	LEFT JOIN tblEmployeeDtl ON tblEmployeeDtl.DepartmentID = tblDepartmentDtl.DepartmentID

--> 5. Display all employees with their department locations(Include employees who are not allocated with department)

	SELECT tblEmployeeDtl.*, tblDepartmentDtl.[Location]
	FROM tblDepartmentDtl
	LEFT JOIN tblEmployeeDtl ON tblEmployeeDtl.DepartmentID = tblDepartmentDtl.DepartmentID
