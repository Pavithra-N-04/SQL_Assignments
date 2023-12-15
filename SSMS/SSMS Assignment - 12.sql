
--> Assignment - 12

--> Creating tables:

	CREATE TABLE tblDepartment
	(
		DepartmentId INT PRIMARY KEY,
		DepartmentName VARCHAR(50)
	)

	CREATE TABLE tblSubjects
	(	
		SubId INT PRIMARY KEY,
		Subject VARCHAR(50)
	)

	CREATE TABLE tblDepartmentSubjects
	(
		SlNo INT PRIMARY KEY,
		DepartmentId INT FOREIGN KEY REFERENCES tblDepartment(DepartmentID),
		SubId INT FOREIGN KEY REFERENCES tblSubjects(SubId)
	)

	CREATE TABLE tblStudentMaster
	(
		ID INT PRIMARY KEY,
		Name VARCHAR(50),
		DateOfJoin DATE,
		DepartMent INT FOREIGN KEY REFERENCES tblDepartment(DepartmentID)
	)

	CREATE TABLE tblMarks
	(
		Id INT IDENTITY(1,1),
		StudentID INT FOREIGN KEY REFERENCES tblStudentMaster(ID),
		SubjectID INT FOREIGN KEY REFERENCES tblSubjects(SubId),
		DoE DATE,
		Scores INT,
		CONSTRAINT Pk_stusub PRIMARY KEY(StudentId,SubjectId)
	)

--> Inserting values:

	INSERT INTO tblDepartment
	VALUES
	(1, 'CSE'),(2, 'ECE'),(3, 'ME'),(4, 'IS')

	INSERT INTO tblSubjects
	VALUES
	(1001, 'C Program'),
	(1002, 'Python'),
	(1003, 'Computer Networks'),
	(1004, 'DBMS'),
	(1005, 'Web Technology'),
	(1006, 'Data Mining'),
	(1007, 'Big Data Analytics'),
	(1008, 'Arduino Programming'),
	(1009, 'Digital Electronics'),
	(1010, 'Computer Fundamentals'),
	(1011, 'Basic Electronics'),
	(1012, 'Thermodynamics'),
	(1013, 'Kinametics'),
	(1014, 'Dynametics'),
	(1015, 'MOM')

	INSERT INTO tblDepartmentSubjects
	VALUES
	(1, 1, 1001),(2, 1, 1002),(3, 1, 1003),(4, 1, 1004),(5, 1, 1005),
	(6, 4, 1006),(7, 4, 1007),(8, 4, 1001),(9, 4, 1002),(10, 4, 1005),
	(11, 3, 1012),(12, 3, 1013),(13, 3, 1014),(14, 3, 1015),(15, 3, 1001),
	(16, 2, 1008),(17, 2, 1009),(18, 2, 1010),(19, 2, 1011),(20, 2, 1001)

	INSERT INTO tblStudentMaster
	VALUES
	(101, 'Sathish', '05-15-2020', 1),
	(102, 'Balraju', '10-5-2020', 2),
	(103, 'Chethan', '1-15-2020', 3),
	(104, 'Prathibha', '10-22-2020', 4),
	(105, 'Vasanth', '12-20-2020', 1),
	(106, 'Santhosh', '08-15-2020', 2),
	(107, 'Mahesh', '07-15-2020', 3),
	(108, 'rani', '1-15-2020', 4),
	(109, 'Raju', '1-20-2020', 1),
	(110, 'Sangeetha', '10-15-2020', 2)

	INSERT INTO tblMarks
	(StudentID,SubjectID,DoE,Scores)
	VALUES
	(101, 1002, '11-19-2023', 70),
	(101, 1003, '11-19-2023', 64),
	(101, 1004, '11-19-2023', 58),
	(101, 1001, '11-19-2023', 85),

	(102, 1008, '11-19-2023', 84),
	(102, 1009, '11-19-2023', 80),
	(102, 1010, '11-19-2023', 85),
	(102, 1001, '11-19-2023', 92),

	(103, 1012, '11-19-2023', 80),
	(103, 1013, '11-19-2023', 70),
	(103, 1015, '11-19-2023', 40),
	(103, 1001, '11-19-2023', 30),

	(104, 1011, '11-19-2023', 60),
	(104, 1009, '11-19-2023', 56),
	(104, 1008, '11-19-2023', 70),
	(104, 1001, '11-19-2023', 38)

	INSERT INTO tblStudentMaster
	VALUES
	(101, 'Sathish', '05-15-2020', 1),
	(102, 'Balraju', '10-5-2020', 2),
	(103, 'Chethan', '1-15-2020', 3),
	(104, 'Prathibha', '1-15-2020', 4)

	SELECT * FROM tblDepartment
	SELECT * FROM tblSubjects
	SELECT * FROM tblDepartmentSubjects
	SELECT * FROM tblStudentMaster
	SELECT * FROM tblMarks
	
	1.	Each department has only five Subjects
	2.	Some subjects can be a common subject between the departments
	3.	Student can take test/assessment on the subjects as per his department
	4.	Student can attempt only once in each subject
	5.	The Pass marks is variable, a student must pass in all subjects  to Pass
	6.	Grades are based on the percentage of scores, those above 79% would be graded as distinction
		Those with 60 and above percentage would be graded as first class and those who score above 50% are graded as second class, 
		the remaining are classified as Just passed Grades are awarded only to those who pass in all subjects

	1, Create a function to List the details as shown below for the students of a given department and given pass marks
	Student ID	Name	Total Marks	Percentage	No of Subjects Passed	No of Subjects attempted	Result	Grade

	CREATE OR ALTER FUNCTION dbo.GetStudentResultsByDepartment
	(
	  @DepartmentId INT,
      @PassMarks INT
	)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT
			SM.ID AS 'Student ID',
			SM.Name,
			SUM(M.Scores) AS 'Total Marks',
			CONVERT(DECIMAL(5, 2), AVG(M.Scores)) AS 'Percentage',
			SUM(CASE WHEN M.Scores >= @PassMarks THEN 1 ELSE 0 END) AS 'No of Subjects Passed',
			COUNT(M.SubjectID) AS 'No of Subjects Attempted',
			CASE
				WHEN COUNT(M.SubjectID) = SUM(CASE WHEN M.Scores >= @PassMarks THEN 1 ELSE 0 END)
				THEN 'Fail'
			ELSE 'Pass'
		END AS 'Result',
			CASE
				WHEN  AVG(M.Scores) >= 80 THEN 'Distinction'
				WHEN  AVG(M.Scores) >= 60 THEN 'First Class'
				WHEN  AVG(M.Scores) >= 50 THEN 'Second Class'
				WHEN  AVG(M.Scores) < 50 THEN 'FAIL'
			ELSE 'Not Attended'
		END AS 'Grade'
		FROM tblStudentMaster SM
		LEFT JOIN tblMarks M ON SM.ID = M.StudentID
		WHERE SM.DepartMent = @DepartmentId
		GROUP BY SM.ID, SM.Name
	);
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	SELECT * FROM dbo.udf_GetStudentDetails(2, 35);
	
	



	=========================================================================================================

	CREATE OR ALTER FUNCTION udf_GetStudentDetails(@Dept INT ,@Marks INT)
	RETURNS @reports table
	(
		Id INT,
		Name varchar(50),
		TotalMarks INT,
		Percentage INT,
		NoOfSubjectsPassed INT,
		NoOfSubjectsAttended INT,
		Result varchar(50),
		Grade Varchar(50)
	)
	AS
	BEGIN
	INSERT INTO @reports(Id, Name, TotalMarks, Percentage, NoOfSubjectsPassed, NoOfSubjectsAttended, Result, Grade)
	SELECT
		StuScore.StudentId as ID,
		StuScore.Studentname as Name,
		COUNT(Stuscore.Marks) * 100 AS TotalMarks,
		SUM(Stuscore.marks) * 100 / (COUNT(Stuscore.Marks) * 100) AS Percentage,
		COUNT(Stuscore.Marks) - (COUNT(Stuscore.Marks) - COUNT(Stuscore.Result)) NoofPassed,
		COUNT(Stuscore.Marks) NoOfSubjectsAttended,
		CASE 
			WHEN COUNT(Stuscore.Marks) = COUNT(StuScore.Result) THEN 'P'
			ELSE 'F'
		END AS Result,
		CASE
			WHEN SUM(Stuscore.marks) * 100 / (COUNT(Stuscore.Marks) * 100) > 79 AND 
			COUNT(Stuscore.Marks) = COUNT(Stuscore.Result) THEN 'Distinction'
			WHEN SUM(Stuscore.marks) * 100 / (COUNT(Stuscore.Marks) * 100) BETWEEN 60 AND 79 AND 
			COUNT(Stuscore.Marks) = COUNT(Stuscore.Result) THEN 'First Class'
			WHEN SUM(Stuscore.marks) * 100/(COUNT(Stuscore.Marks) * 100) BETWEEN 50 AND 60 AND 
			COUNT(Stuscore.Marks) = COUNT(Stuscore.Result) THEN 'Secod Class'
			WHEN SUM(Stuscore.marks) * 100 / (COUNT(Stuscore.Marks) * 100) BETWEEN 30 AND 50 AND 
			COUNT(Stuscore.Marks) = COUNT(Stuscore.Result) THEN 'Just Pass'
			ELSE 'FAIL'
			END AS Grade
		FROM (SELECT 
		SM.Id StudentId, SM.Name StudentName, M.Scores Marks, SM.DepartMent Department,
		CASE
			WHEN M.Scores >= @Marks THEN M.Scores
		ELSE null
		END AS Result
		FROM tblStudentMaster SM 
		INNER JOIN tblMarks M ON SM.ID = M.StudentID) StuScore
		WHERE StuScore.Department = @Dept
		GROUP BY StuScore.StudentId,StuScore.StudentName
		RETURN
	END

	SELECT * FROM dbo.udf_GetStudentDetails(4, 35);

	=======================================================================================================
