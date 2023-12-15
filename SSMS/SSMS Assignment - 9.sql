	
	--> Assignment - 9
	--> Stored procedure:

	1. What are types of Variables and mention the difference between them

		Types of Variables are:
		1. Local Variables: local variables starts with single @. These variables are accessible in a particular session.
		2. Global Variables: global variables starts with double @@. These variables are accessible in any sessions.

	2. Declare a variable with name [SQLData] which can store a string datatype 
		and assign a value to using SELECT option and specify an alias name for the same

		DECLARE @SQLData VARCHAR(10)
		SELECT @SQLData = 'Database' 
		SELECT @SQLData AS 'MSSQL'

	3. What is used to define a SQL variable to put a value in a variable?
		a. SET @id = 6;
		b. SET id = 6;
		c. Id = 6;
		d. SET #id = 6;
	Select the correct option
		a. SET @id = 6;

	4. Compare Local and Global Temporary tables with an Example

		Local variables:
		DECLARE @Var INT
		SELECT @Var = 10
		PRINT @Var

		Global variables:
		DECLARE @@Var INT
		SELECT @@Var = 20
		PRINT @@Var

	5. Create a table with an IDENTITY column whose Seed value is 2 and Increment value of 100

		CREATE TABLE [dbo].[City](
		[Name] VARCHAR(50),
		[Country] VARCHAR(50),
		[ID] INT IDENTITY(2, 100)
		)

		SELECT * FROM [dbo].[City]

	6. What is the difference between SCOPE_IDENTITY() and @@IDENTITY. Explain with an Example.

		SCOPE_IDENTITY: It returns values inserted only within the current scope.
		Example: 

		INSERT INTO [dbo].[City](
		[Name], [Country]) VALUES('Mysore', 'India')
		SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]

		@@IDENTITY: It is not limited to a specific scope
		Both return last identity values that are generated in any table in the current session.
		Example:

		INSERT INTO [dbo].[City](
		[Name], [Country]) VALUES('Bangalore', 'India')
		SELECT @@IDENTITY AS IdentityValue

	7.	
		--Assignment Questions 
	CREATE TABLE tblProject
	(
	   ProjectId BIGINT PRIMARY KEY,
	   Name VARCHAR(100) NOT NULL,
	   Code NVARCHAR(50) NOT NULL,
	   ExamYear SMALLINT NOT NULL
	);

	CREATE TABLE tblExamCentre 
	(
	  ExamCentreId BIGINT PRIMARY KEY,
	  Code VARCHAR(100) NULL,
	  Name VARCHAR(100)  NULL
	);

	CREATE TABLE tblProjectExamCentre
	(
	   ProjectExamCentreId BIGINT PRIMARY KEY,
	   ExamCentreId BIGINT NOT NULL FOREIGN KEY REFERENCES tblExamCentre(ExamCentreId),
	   ProjectId BIGINT FOREIGN KEY REFERENCES tblProject(ProjectId)
	);

	INSERT INTO tblProject(ProjectId,Name,Code,ExamYear) VALUES
	(1,	'8808-01-CW-YE-GCEA-2022',	'PJ0001',	2022),
	(2,	'6128-02-CW-YE-GCENT-2022',	'PJ0002',	2022),
	(3, '7055-02-CW-YE-GCENA-2022','PJ0003',	2022),
	(4,	'8882-01-CW-YE-GCEA-2022','	PJ0004',	2022),
	(5,'7062-02-CW-YE-GCENT-2022',	'PJ0005',	2022),
	(8,	'6128-02-CW-YE-GCENT-1000',	'PJ0008',	1000),
	(9,	'7062-02-CW-YE-GCENT-5000',	'PJ0009',	5000),
	(10,'8808-01-CW-YE-GCEA-2023',	'PJ0010',	2023),
	(11,'8808-01-CW-YE-GCEA-2196',	'PJ0011',	2196),
	(15,'6073-02-CW-YE-GCENA-2022',	'PJ0015',	2022),
	(16,'8808-01-CW-YE-GCE0-2022',	'PJ0016',	2022);


	INSERT INTO tblExamCentre(ExamCentreId,Name,Code) VALUES
	(112,'VICTORIA SCHOOL-GCENA-S','2711'),
	(185,'NORTHBROOKS SECONDARY SCHOOL-GCENA-S','2746'),
	(227,'YIO CHU KANG SECONDARY SCHOOL-GCENA-S','2721'),
	(302,'CATHOLIC JUNIOR COLLEGE','9066'),
	(303,'ANGLO-CHINESE JUNIOR COLLEGE','9067'),
	(304,'ST. ANDREW''S JUNIOR COLLEGE','9068'),
	(305,'NANYANG JUNIOR COLLEGE','9069'),
	(306,'HWA CHONG INSTITUTION','9070'),
	(1,NULL,'2011'),
	(2,'NORTHBROOKS SECONDARY SCHOOL-GCENA-S',NULL);


	INSERT INTO tblProjectExamCentre(ProjectExamCentreId,ProjectId,ExamCentreId) VALUES
	(44,1,112),
	(45,1,227),
	(46,1,185),
	(47,2,112),
	(48,2,227),
	(49,2,185),
	(50,3,112),
	(51,3,227),
	(52,3,185),
	(69,4,112);

	select * from tblProject
	select * from tblExamCentre
	select * from tblProjectExamCentre

	--1. Write a procedure to fetch the ProjectId, ProjectName, ProjectCode, ExamCentreName and ExamCentreCode from the tables tblProject and 
	--tblExamCentre based on the ProjectId and ExamCentreId passed as input parameters.
	
	CREATE PROCEDURE usp_project
	@ProjectID BIGINT,
	@ExamCentreID BIGINT
	AS 
	BEGIN
		SELECT tp.ProjectID, TP.Name, TP.Code, E.Name, E.Code
		FROM tblProject TP
		INNER JOIN tblProjectExamCentre EC ON TP.ProjectID = EC.ProjectID
		INNER JOIN tblExamCentre  E ON EC.ExamCentreId= E.ExamCentreId
		WHERE TP.ProjectId IN (@ProjectID) AND E.ExamCentreID IN (@ExamCentreID)
	END
	GO

	2. Write a procedure to insert values into the table tblProject when the data for the ProjectId 
	which is being inserted does not exist in the table.

	ALTER PROCEDURE usp_project(
	@ProjectID INT,
	@Name VARCHAR(50),
	@Code NVARCHAR(50),
	@ExamYear SMALLINT
	)
	AS
	BEGIN
		IF @ProjectID NOT IN (SELECT [ProjectId] FROM tblProject)
		BEGIN
			INSERT INTO tblProject VALUES(@ProjectID, @Name, @Code, @ExamYear)
		END				
	END
	SELECT * FROM tblProject
	EXEC usp_project 17, 'Pearson', 'PJ0017', 2023

	3. Write a procedure to update the columns-Code and Name in tblExamCentre when either of the Code or 
	the Name column is NULL and also delete the records from the table tblProjectExamCentre when ProjectId IS 4.

	CREATE PROCEDURE update_project
	@ProjectID BIGINT
	AS
	BEGIN
		UPDATE tblExamCentre
		SET Name = 'VICTORIA SCHOOL-GCENA-S',
			Code = '2711'
		WHERE Name IS NULL OR Code IS NULL  

		DELETE tblProjectExamCentre
		WHERE ProjectId = 4
	END
	SELECT * FROM tblProject
	SELECT * FROM tblProjectExamCentre

	EXEC update_project 4

	4. Write a procedure to fetch the total count of records present in the table tblProject based on 
	the ProjectId AS OUTPUT parameter.and also sort the records in ascending order based on the ProjectName.

	CREATE PROCEDURE count_records
	@Count INT OUTPUT
	AS
	BEGIN
		SET NOCOUNT ON
		SELECT @Count = COUNT(ProjectID)
		FROM tblProject
		
		SELECT *
		FROM tblProject

		ORDER BY Name
	END

	SELECT * FROM tblProject
	DECLARE @ANSWER INT  
	EXEC count_records @ANSWER OUTPUT
	PRINT @ANSWER

	5. Write a procedure to create a Temp table named Students with columns- StudentId,StudentName and Marks where the 
	column StudentId is generated automatically and insert data into the table and also retrieve the data.

	CREATE PROCEDURE temp_students
	AS
	BEGIN
		CREATE TABLE #Students(
		StudentId INT IDENTITY,
		StudentName VARCHAR(50),
		Marks INT
		)
		INSERT INTO #Students VALUES('ANUSHA', 80)
		INSERT INTO #Students VALUES('RAVI', 85)
		INSERT INTO #Students VALUES('MANASA', 90)
		INSERT INTO #Students VALUES('ANIL', 75)

		SELECT * FROM #Students 

	END
	EXEC temp_students

	6. Write a procedure to perform the following DML operations on the column - ProjectName in tblProject 
	table by using a varibale. 
	Declare a local variable and initialize it to value 0, 
	1. When the value of the variable is equal to 2, then insert another record into the table tblProject.
	2. When the value of the variable is equal to 10, then change the ProjectName to 'Project_New' for input @ProjectId

	In the next part of the stored procedure, return all the fields of the table tblProject(ProjectId, ProjectName,
	Code and Examyear) based on the ProjectId and for the column ExamYear display it as given using CASE statement.
	1.If the ExamYear is greater than or equal to 2022 then display 'New'
	2.If the ExamYear is lesser than or equal to 2022 then display 'Old'

	CREATE PROCEDURE dml_project
	@var INT = 0,
	@ProjectID BIGINT,
	@Name VARCHAR(50) = 'NA',
	@Code NVARCHAR(50) = 'NA',
	@ExamYear SMALLINT = -1,   -----DEFAULT VALUES
	@OpProjectID BIGINT OUTPUT,
	@OpName VARCHAR(50) OUTPUT,
	@OpCode VARCHAR(50) OUTPUT,
	@OpExamYear VARCHAR(50) OUTPUT
	AS
	BEGIN 
		IF @var = 2
			BEGIN
				INSERT INTO tblProject VALUES(@ProjectID, @Name, @Code, @ExamYear)
			END
		IF @var = 10
		BEGIN
			UPDATE tblProject
			SET Name = @Name
			WHERE ProjectID IN (@ProjectID)
		END
		SELECT @OpProjectID = ProjectID, @OpName = Name, @OpCode = Code, @OpExamYear = (
			CASE
				WHEN ExamYear >= 2022 THEN 'NEW'
				ELSE 'OLD'
			END)
		FROM tblProject
		WHERE ProjectID IN (@ProjectID)
	END

	DECLARE @OpProjectID BIGINT, @OpName VARCHAR(50), @OpCode NVARCHAR(50), @OpExamYear VARCHAR(5)

	EXEC dml_project @var = 10, @ProjectID = 8, @Name = '6128-02-CW-YE-GCENT-2022', @OpProjectID = @OpProjectID OUTPUT, 
		@OpName = @OpName OUTPUT, @OpCode = @OpCode OUTPUT, @OpExamYear = @OpExamYear OUTPUT

	PRINT @OpProjectID
	PRINT @OpName
	PRINT @OpCode
	PRINT @OpExamYear
	PRINT 'Completed'

	










