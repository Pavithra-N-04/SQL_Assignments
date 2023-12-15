
--> Assignment - 2 

	USE Payroll

--> Create table with Department details:

	CREATE TABLE tblDepartmentDtl(
	DepartmentID INT PRIMARY KEY,
	DepartmentName VARCHAR(50) NOT NULL,
	[Location] VARCHAR(50) NOT NULL
	);

--> Create table with employee details:

	CREATE TABLE tblEmployeeDtl(
	EmployeeID INT PRIMARY KEY,
	EmployeeName VARCHAR(50) NOT NULL,
	Designation VARCHAR(50) NOT NULL,
	JoiningDate DATETIME NOT NULL DEFAULT GETDATE(),
	EmailID VARCHAR(50) NOT NULL UNIQUE,
	PhoneNO VARCHAR(10) NOT NULL,
	Salary INT NOT NULL,  
	CHECK(Salary>15000),
	CHECK(LEN(PhoneNO)=10),
	DepartmentID INT FOREIGN KEY REFERENCES tblDepartmentDtl(DepartmentID)
	);

	DROP TABLE tblEmployeeDtl(

--> Inserting values to the table Department:

	INSERT INTO tblDepartmentDtl values(10, 'DATABASE', 'MYSORE');
	INSERT INTO tblDepartmentDtl values(11, 'ACCOUNTS AND FINANCE', 'BANGALORE');
	INSERT INTO tblDepartmentDtl values(12, 'DEVELOPMENT', 'MYSORE');
	INSERT INTO tblDepartmentDtl values(13, 'QUALITY ASSURANCE', 'HYDERABAD');
	INSERT INTO tblDepartmentDtl values(14, 'TESTING', 'NOIDA');
	INSERT INTO tblDepartmentDtl values(15, 'HUMAN RESOURCE', 'MYSORE');
	INSERT INTO tblDepartmentDtl values(16, 'RESEARCH AND DEVELOPMENT', 'NOIDA');
	INSERT INTO tblDepartmentDtl values(17, 'SALES AND MARKETING', 'BANGALORE');
	INSERT INTO tblDepartmentDtl values(18, 'TECHNICAL SUPPORT', 'MYSORE');
	INSERT INTO tblDepartmentDtl values(19, 'ADMINISTRATION', 'HYDERABAD');

--> Inserting values to the table Employee:

	INSERT INTO tblEmployeeDtl values
	(100, 'PAVITHRA N', 'TRAINEE SOFTWARE ENGINEER', '2023-10-16', 'pavithra.n@excelindia.com', 9876543210, 16000, 10),
	(200, 'PRAJWAL Y P', 'SOFTWARE ENGINEER', '2023-10-18', 'prajwal.yp@excelindia.com', 9876543211, 18000, 12),
	(300, 'POOJA GOWDA', 'ACCOUNTANT', '2022-05-16', 'pooja.g@excelindia.com', 9876543212, 19000, 11),
	(400, 'BHOOMIKA', 'QUALITY ANALYST', '2020-12-15', 'bhoomoka.n@excelindia.com', 9876543212, 20000, 13),
	(500, 'ANJALI', 'SOFTWARE TESTER', '2021-08-16', 'anjali.n@excelindia.com', 9876543213, 17000, 14),
	(600, 'MANU', 'HR RECRUITER', '2022-10-14', 'manu.n@excelindia.com', 9876543215, 16000, 15),
	(700, 'MANJUNATH', 'RESEARCH ENGINEER', '2023-10-25', 'manjunath.n@excelindia.com', 9876543216, 19000, 16),
	(800, 'AKASH', 'SALES MANAGER', '2020-10-05', 'akash.n@excelindia.com', 9876543217, 25000, 17),
	(900, 'SUSHIL', 'SUPPORT ENGINEER', '2019-04-30', 'sushil.n@excelindia.com', 9876543218, 30000, 18),
	(1000, 'KARTHIK', 'ADMINISTRATOR', '2020-10-15', 'karthik.n@excelindia.com', 9876543219, 22000, 19),
	(1001, NULL, 'QA ENGINEER', '2020-10-15', 'karthika.n@excelindia.com', 9876543219, 22000, 20);
	INSERT INTO tblEmployeeDtl values(100001, 'KARTHIK K', 'TRAINEE', '2021-10-05', 'kaarthikk.n@excelindia.com', 9876543200, 22000, 15);

	select * from tblDepartmentDtl
	select* from tblEmployeeDtl

--> Create table for subject:

	CREATE TABLE tblSubjectDtl(
	SubjectID INT PRIMARY KEY,
	SubjectName VARCHAR(50) NOT NULL,
	);

--> Create table for student:
	  CREATE TABLE tblStudentDtl(
	  StudentID INT PRIMARY KEY,
	  StudentName VARCHAR(50) NOT NULL,
	  );

--> Create table for student sub-marks:

	 CREATE TABLE tblStudentSubMarksDtl(
	 StudentID INT FOREIGN KEY REFERENCES tblStudentDtl (StudentID),
	 SubjectID INT FOREIGN KEY REFERENCES tblSubjectDtl (SubjectID),
	 Marks DECIMAL NOT NULL,
	 CONSTRAINT PK_StudentSubject PRIMARY KEY (StudentID, SubjectID),
	 );

 --> Inserting values to subject table:

 INSERT INTO tblSubjectDtl values(10, 'SQL');
 INSERT INTO tblSubjectDtl values(20, 'JAVA');
 INSERT INTO tblSubjectDtl values(30, 'C');
 INSERT INTO tblSubjectDtl values(40, 'PYTHON');
 INSERT INTO tblSubjectDtl values(50, 'WEB');
 INSERT INTO tblSubjectDtl values(60, 'C#');
 INSERT INTO tblSubjectDtl values(70, '.NET');
 INSERT INTO tblSubjectDtl values(80, 'C++');
 INSERT INTO tblSubjectDtl values(90, 'J2EE');
 INSERT INTO tblSubjectDtl values(100, 'RUBY');

 --> Inserting values to student table:

 INSERT INTO tblStudentDtl values(1001, 'ANIL');
 INSERT INTO tblStudentDtl values(1002, 'ANUSHA');
 INSERT INTO tblStudentDtl values(1003, 'BHUVAN');
 INSERT INTO tblStudentDtl values(1004, 'DEEPIKA');
 INSERT INTO tblStudentDtl values(1005, 'CHARAN');
 INSERT INTO tblStudentDtl values(1006, 'JYOTHI');
 INSERT INTO tblStudentDtl values(1007, 'RAHUL');
 INSERT INTO tblStudentDtl values(1008, 'SANJANA');
 INSERT INTO tblStudentDtl values(1009, 'TARUN');
 INSERT INTO tblStudentDtl values(1010, 'VIDYA');

 --> Inserting values to student marks table:

 INSERT INTO tblStudentSubMarksDtl values(1001, 10, 75);
 INSERT INTO tblStudentSubMarksDtl values(1001, 20, 95);
 INSERT INTO tblStudentSubMarksDtl values(1002, 20, 60);
 INSERT INTO tblStudentSubMarksDtl values(1003, 30, 72);
 INSERT INTO tblStudentSubMarksDtl values(1004, 40, 88);
 INSERT INTO tblStudentSubMarksDtl values(1005, 50, 90);
 INSERT INTO tblStudentSubMarksDtl values(1006, 60, 65);
 INSERT INTO tblStudentSubMarksDtl values(1007, 70, 78);
 INSERT INTO tblStudentSubMarksDtl values(1008, 80, 92);
 INSERT INTO tblStudentSubMarksDtl values(1009, 90, 84);
 INSERT INTO tblStudentSubMarksDtl values(1010, 100, 70);

 select * from tblStudentDtl;
 select * from tblSubjectDtl; 
 select * from tblStudentSubMarksDtl;

 delete from tblSubjectDtl;
 delete from tblStudentDtl;
 delete from tblStudentSubMarksDtl;

 --> Dis-associate the trainees from the department in the employee table
 
	UPDATE tblEmployeeDtl
	SET DepartmentID = NULL
	WHERE Designation = 'TRAINEE'; 

	SELECT * from tblEmployeeDtl;
 
 --> Give bonus of Rs. 10000 for employees who have more than 2 years experience. add separate columan as bonus in employee table

	ALTER TABLE tblEmployeeDtl
	ADD Bonus int;
	
	UPDATE tblEmployeeDtl
	SET Bonus = 10000
	WHERE DATEDIFF(YEAR, JoiningDate, GETDATE()) > 2;
	
	SELECT *, Salary + COALESCE(Bonus, 0) as [Total Salary]
	FROM tblEmployeeDtl;
 
	SELECT *, Salary + ISNULL(Bonus,0) as [Total Salary]
	FROM tblEmployeeDtl;

	SELECT Designation, COUNT(*)
	FROM tblEmployeeDtl
	GROUP BY Designation
	ORDER BY Designation DESC
