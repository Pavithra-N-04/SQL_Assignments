
-->Assignment - 8 T-SQL

--> 1. Write T-SQL block to generate Fibonacci series.

	DECLARE @Num1 BIGINT = 0, @Num2 BIGINT = 1, @Num3 BIGINT, @Count BIGINT = 2
	PRINT @Num1 
	PRINT @Num2
	WHILE @Count < 50
	BEGIN
		SET @Num3 = @Num1 + @Num2
		PRINT @Num3
		SET @Num1 = @Num2
		SET @Num2 = @Num3
		SET @Count += 1
	END

--> 2. Create student and result table and perform the following: 

	USE Payroll
	SELECT * FROM tblStudentSubMarksDtl
	SELECT * FROM tblStudentDtl
	
--> 3. Write query to find the grade of a student, if he scores above 90 its 'A’, above 80 'B', above 70 ‘C’, 
--- above 60 ‘D’, above 50 ‘F’ or else print failed.(Hint: Use Case ) 

	SELECT tblStudentSubMarksDtl.*,
		CASE
			WHEN Marks > 90 THEN 'A'
			WHEN Marks > 80 THEN 'B'
			WHEN Marks > 70 THEN 'C'
			WHEN Marks > 60 THEN 'D'
			ELSE 'F'
		END
	AS Grade FROM tblStudentSubMarksDtl
						
--> 4. Display month on which the employee is born. Use case statement.

	SELECT * FROM tblEmployee
	SELECT EmployeeName, JoiningDate,
		CASE
			WHEN DATEPART(MONTH, JoiningDate) = 1 THEN 'January'
			WHEN DATEPART(MONTH, JoiningDate) = 2 THEN 'February'
			WHEN DATEPART(MONTH, JoiningDate) = 3 THEN 'March'
			WHEN DATEPART(MONTH, JoiningDate) = 4 THEN 'April'
			WHEN DATEPART(MONTH, JoiningDate) = 5 THEN 'May'
			WHEN DATEPART(MONTH, JoiningDate) = 6 THEN 'June'
			WHEN DATEPART(MONTH, JoiningDate) = 7 THEN 'July'
			WHEN DATEPART(MONTH, JoiningDate) = 8 THEN 'August'
			WHEN DATEPART(MONTH, JoiningDate) = 9 THEN 'September'
			WHEN DATEPART(MONTH, JoiningDate) = 10 THEN 'January'
			WHEN DATEPART(MONTH, JoiningDate) = 11 THEN 'October'
		ELSE 'December'
	END
	AS Month
	FROM tblEmployeeDtl
			
	
--> 5. Write T-SQL statements to generate 10 prime numbers greater than 1000. 

	DECLARE @Num INT = 1001 , @Count INT = 1
	WHILE @Count <= 10
	BEGIN
		DECLARE @Num2 INT = 2, @Prime BIT = 1
		WHILE @Num2 <= SQRT(@Num)
		BEGIN 
			IF @Num % @Num2 = 0
			BEGIN 
				SET @Prime = 0
				BREAK
			END
			SET @Num2 += 1
		END
		
		IF @Prime = 1
		BEGIN 
			PRINT @Num
			SET @Count += 1
		END
		
		SET @Num += 1
	END
		
--> 6. Consider HR Database and generate bonus to employees as below: 
---A) one month salary  if Experience > 10 years  
---B) 50% of salary  if experience between 5 and 10 years  
---C) Rs. 5000  if Eexperience less than 5 years 

	SELECT E.*,
	(CASE 
		WHEN DATEDIFF(YYYY, JoiningDate, GETDATE()) > 10 THEN Salary
		WHEN DATEDIFF(YYYY, JoiningDate, GETDATE()) BETWEEN 5 AND 10 THEN Salary * 0.5
	ELSE
		5000
	END)
	AS NewBonus
	FROM Employees E
	INNER JOIN tblDepartmentDtl D ON E.DepartmentID = D.DepartmentID
	WHERE DepartmentName IN ('HUMAN RESOURCE')

--> 7. Consider Banking database and Create a procedure to list the customers with more than the specified 
----minimum balance as on the given date. 

	CREATE OR ALTER PROCEDURE usp_Bank(
	@Given_date DATETIME, 
	@Min_balance MONEY
	)
	AS
	BEGIN
		DECLARE @ans DATETIME;
		SELECT *
		FROM [CustomerDetails] [C1]
		WHERE EXISTS(SELECT 1
					 FROM(SELECT TOP 1 *
						  FROM [Passbook] [P2]
						  WHERE [P2].[AccNo]=[C1].[AccNo] AND CAST([TransDate] AS DATE) <= @Given_date
						  ORDER BY [TransDate] DESC) AS [Required]
						  WHERE [Required].[Balance] > @Min_balance
					)
	END

	EXEC usp_Bank '2023-10-19', 5000

	USE BANK
	SELECT * FROM CustomerDetails
	SELECT * FROM AccountTransaction
	SELECT * FROM AccountType
	SELECT * FROM TransactionType

--> 8. Based on balance categorize the customers as below: 
---a. if the balance is greater than minimum balance declare them as ‘Premium Customer' 
---b. if the balance is less than 0, 'Overdue Customer' 
---c. Else 'NON Premium Customer' 

	USE [Bank];

	SELECT * FROM [CustomerDetails]

	DECLARE @minBal MONEY = 1000;
	SELECT P.AccNo, C.CustName, P.Balance,
		(CASE
			WHEN P.Balance > @minBal THEN 'Premium Customer'
			WHEN P.Balance < 0 THEN 'Overdue Customer'
			ELSE 'NON Premium Customer'
		END) AS StatusMessage
	FROM Passbook P INNER JOIN CustomerDetails C ON P.AccNo = C.AccNo
	WHERE P.TransId IN (SELECT MAX(TransId) FROM PassBook P1 WHERE P1.AccNo = P.AccNo )

--> 9. ADD Rs. 10000 as bonus to all the employees if the month is november

	USE [Payroll];

	DECLARE @Today VARCHAR(15)
	SET @Today = DATENAME(MM, GETDATE())
	IF @Today = 'November'
	BEGIN
		SELECT [Employee_FirstName], [Salary], [Salary] + 10000 AS [New Salary]
		FROM [Employees]
	END
	ELSE

	PRINT 'This month is ' + @Today + ', not November'
