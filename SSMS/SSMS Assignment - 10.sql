
--> Assignment - 10(a):

	1. Consider table tblEmployeeDtls and write a stored procedure to generate 
	bonus to employees for the given date  as below: 
	A)One month salary  if Experience > 10 years  
	B)50% of salary  if experience between 5 and 10 years  
	C)Rs. 5000  if experience is less than 5 years 
	Also, return the total bonus dispatched for the year as output parameter. 

	ALTER PROCEDURE Emp_Bonus
	@GivenDate DATETIME, 
	@TotalBonus MONEY OUTPUT
	AS 
	BEGIN 
		UPDATE tblEmployeeDtl
			SET Bonus = Salary * 1.0
			WHERE DATEDIFF(YYYY, JoiningDate, @GivenDate) > 10

		UPDATE tblEmployeeDtl
			SET Bonus = Salary * 0.5
			WHERE DATEDIFF(YYYY, JoiningDate, @GivenDate) BETWEEN 5 AND 10

		UPDATE tblEmployeeDtl
			SET Bonus = 5000
			WHERE DATEDIFF(YYYY, JoiningDate, @GivenDate) < 5

		SELECT @TotalBonus = SUM(Bonus)
		FROM tblEmployeeDtl
	END

	DECLARE @TotalBonus MONEY 
	EXEC Emp_Bonus '2023-11-10', @TotalBonus OUTPUT
	PRINT @TotalBonus

	SELECT * FROM tblEmployeeDtl	
 
	2. Create a stored procedure that returns a sales report for a given time period 
	for a given Sales Person. Write commands to invoke the procedure 

		ALTER PROCEDURE Sales_Report
		@Sid INT,
		@StartDate DATETIME,
		@EndDate DATETIME
		AS 
			BEGIN
				SELECT SName, P.Pid, Price, SDate, Amount, Quantity--*
				FROM Sale S
				INNER JOIN SalesMan SM ON S.Sid = SM.Sid
				INNER JOIN SaleDetail SD ON S.Saleid = SD.Saleid
				INNER JOIN Product P ON P.Pid = SD.Pid
				WHERE S.Sid = @Sid AND SDate BETWEEN @StartDate AND @EndDate
			END

		EXEC Sales_Report 
		@Sid = 104,
		@StartDate = '2021-05-15',
		@EndDate = '2023-08-25'

		USE BANK
		SELECT * FROM Sale
		SELECT * FROM SaleDetail
		SELECT * FROM Product
		SELECT * FROM SalesMan
		SELECT * FROM SalesMen
		use payroll
		
	3. Also generate the month and maximum ordervalue booked by the given 
	salesman(use output parameter) 
	Tables 
	SALESMAN 
	SalesmanNo, Customerno, Orderno 
	Customers 
	CustomerNo,CustomerName, SalesmanNo, OrderNo 
	Orders 
	Orderno, ProductNo, Qty, CustomerNo, OrderDate 
	Products 
	ProdctNo, ProductName, UnitPrice,Discount 

	CREATE PROCEDURE MaxOrderValue
		@Sid INT,
		@StartDate DATETIME,
		@EndDate DATETIME,
		@OrderMonth VARCHAR(10) OUTPUT,
		@MaxOrderValue INT OUTPUT
		AS 
			BEGIN
				SELECT @OrderMonth = DATENAME(MONTH, SDate), @MaxOrderValue = SUM(Price)
				FROM Sale S
				INNER JOIN SalesMan SM ON S.Sid = SM.Sid
				INNER JOIN SaleDetail SD ON S.Saleid = SD.Saleid
				INNER JOIN Product P ON P.Pid = SD.Pid
				WHERE S.Sid = @Sid AND SDate BETWEEN @StartDate AND @EndDate
				GROUP BY DATENAME(MONTH, SDate) 
				ORDER BY SUM(Price)
			END

	DECLARE @SNum INT, @OrderMonth VARCHAR(10), @MaxOrderValue INT
		EXEC MaxOrderValue 102, '2019-01-01', '2023-12-30', @OrderMonth OUTPUT , @MaxOrderValue OUTPUT
		
		PRINT @MaxOrderValue 
		PRINT @OrderMonth

	4. Consider Toy Centre database 
	Procedure Name: usp_UpdatePrice 
	Description:    This procedure is used to update the price of a given product. 
 
	Input Parameters: 
	∙ProductId 
	∙Price 
	Output Parameter 
		UpdatedPrice 
	Functionality: 
	∙Check if the product id is valid, i.e., it exists in the Products table 
	∙If all the validations are successful, update the price in the table Products appropriately 
	∙Set the output parameter to the updated price 
	∙If the update is not successful or in case of exception, undo the entire operation and set the 
	output parameter to 0 
	Return Values: 
	∙1 in case of successful update 
	∙-1 in case of any errors or exception 

	CREATE PROCEDURE usp_UpdatePrice
	@Pid INT,
	@Price MONEY,
	@UpdatedPrice MONEY OUTPUT
	AS
	BEGIN
		BEGIN TRANSACTION
			IF EXISTS(SELECT 1
					  FROM Product
					  WHERE Pid = @Pid)
				BEGIN
					UPDATE Product
					SET Price = @Price
					WHERE Pid = @Pid
					SET @UpdatedPrice = @Price
					COMMIT 
					RETURN 1
				END
			ELSE
				BEGIN 
					ROLLBACK
					RETURN -1
				END
	END
		
	DECLARE @Pid INT, @Price MONEY, @UpdatedPrice MONEY
	EXEC usp_UpdatePrice 1002, 2000, @UpdatedPrice OUTPUT

	PRINT @UpdatedPrice


	5. Procedure Name : usp_InsertPurchaseDetails 
	Description: 
	This procedure is used to insert the purchase details into the table PurchaseDetails and 
	update the available quantity of the product in the table Products by performing the 
	necessary validations based on the business requirements. 
	Input Parameters: 
	∙CustId 
	∙ToyId 
	∙QuantityPurchased 
	Output Parameter: 
		TxnID 
	Functionality: 
	∙Check if all the input parameters are not null 
	∙Check if the CustID is valid, i.e., it exists in the Customers table 
	∙Check if the ToyId is valid, i.e., it exists in the Toys table 
	∙Check if the purchased quantity is greater than 0 
	∙If all the validations are successful, insert the purchase details into the table 
	Transaction Details 
	∙Update the available quantity in the table Toys appropriately 
	∙Set the output parameter to the newly generated TxnId.If the insert or update 
	is not successful, undo the entire operation and set the output parameter to 0 
	Return Values : 
	∙1 in case of successful insertion and update 
	∙-1 if CustId is null 
	∙-2 if CustId is not valid 
	∙-3 if ToyId is null 
	∙-4 if ToyId is not valid 
	∙-5 if the QuantityPurchased is not valid or QuantityPurchased is null 
	∙-99 if there is any exception 

	CREATE OR ALTER PROCEDURE usp_InsertPurchaseDetails( 
	@CustId INT,
	@ToyId VARCHAR(10),
	@QuantityPurchased INT,
	@TxnID INT OUTPUT
	)
	AS
		BEGIN
			DECLARE @Stock INT, @AvailableStock INT, @ToyCost MONEY
			IF @CustID IS NULL
				BEGIN
					PRINT 'CustID cannot be null'
					RETURN -1
				END
			IF NOT EXISTS(SELECT 1 
						  FROM Customers
						  WHERE CustID = @CustID)
				BEGIN
					PRINT 'Invalid Customer ID'
					RETURN -2
				END
			IF @ToyID IS NULL
				BEGIN
					PRINT 'ToyID cannot be null'
					RETURN -3
				END
			IF NOT EXISTS(SELECT 1
						  FROM Toys
						  WHERE ToyID = @ToyID)
				BEGIN
					RETURN -4
				END
			IF @QuantityPurchased IS NULL 
				BEGIN
					PRINT 'Quantity cannot be null'
					RETURN -5
				END
			SELECT @ToyCost = Price
			FROM Toys
			WHERE ToyID = @ToyID
			IF @QuantityPurchased > (SELECT Stock 
									 FROM Toys
								     WHERE ToyID = @ToyID)
				BEGIN
					PRINT 'Out of Stock'
					RETURN -5
				END

				BEGIN TRY
					BEGIN TRAN
						SELECT @TxnID = MAX(TxnID) + 1
						FROM Transactions

						INSERT INTO Transactions (TxnID, CustID, ToyID, Quantity, TxnCost)
						VALUES
						(@TxnID, @CustID, @ToyID, @QuantityPurchased, @ToyCost * @QuantityPurchased)

						UPDATE Toys
						SET Stock = Stock - @QuantityPurchased
						WHERE ToyID = @ToyID
					COMMIT TRAN
					RETURN 1
				END TRY

				BEGIN CATCH
					ROLLBACK
					SELECT 'Unsuccessful Transaction'
					SELECT ERROR_MESSAGE()
					RAISERROR('SQL ERROR', 16, 1)
					RETURN -99
				END CATCH
		END

	SELECT * FROM Toys
	DECLARE @RETURNVALUE INT, @TxnID INT 
	EXEC @RETURNVALUE = usp_InsertPurchaseDetails 101, 'T1001', 10, @TxnID OUTPUT
	SELECT @RETURNVALUE, @TxnID AS 'Transaction ID'
	SELECT * FROM Toys
	SELECT * FROM Transactions
	SELECT * FROM Customers

--> Assignment - 10(b):

	CREATE DATABASE MEDIA
	USE MEDIA

	CREATE TABLE Vendors(
	VendorID INT PRIMARY KEY IDENTITY,
	Vendor VARCHAR(50)
	)

	create TABLE Category(
	CatID INT PRIMARY KEY IDENTITY(100, 1), 
	Category VARCHAR(50)
	)

	CREATE TABLE Products(
	Pid VARCHAR(5),
	PName VARCHAR(50),
	CatID INT FOREIGN KEY REFERENCES Category(CatID),
	VendorID INT FOREIGN KEY REFERENCES Vendors(VendorID),
	Price MONEY,
	AvailableQuantity INT
	)

	CREATE TABLE Customer(
	Cid VARCHAR(5),
	CName VARCHAR(50),
	Location VARCHAR(50),
	EmailID VARCHAR(50),
	Mobile VARCHAR(50)
	)

	CREATE TABLE PaymentMode(
	ModeID INT PRIMARY KEY IDENTITY,
	Mode VARCHAR(50)
	)

	CREATE TABLE Sale(
	BillNum INT,
	Cid VARCHAR(5),
	DateOfPurchase DATETIME,
	ModeOfPayment VARCHAR(50)
	)

	CREATE TABLE SaleDetails(
	BillNum INT,
	Pid VARCHAR(5),
	Quantity INT
	)

	INSERT INTO Vendors VALUES('Samsung');
	INSERT INTO Vendors VALUES('Microsoft');
	INSERT INTO Vendors VALUES('Philips');

	INSERT INTO Category VALUES('Mobile');
	INSERT INTO Category VALUES('Entertainment');
	INSERT INTO Category VALUES('Philips');

	INSERT INTO Products VALUES('P1', 'LED Television', 102, 1, 23000, 10);
	INSERT INTO Products VALUES('P2', 'X-Box', 102, 2, 34000, 7);
	INSERT INTO Products VALUES('P3', 'Grand 7', 101, 1, 17000, 23);

	INSERT INTO Customer VALUES('C1', 'Chakraborty', 'West Bengal', 'chakraborty@gmail.com', 8765456718);
	INSERT INTO Customer VALUES('C2', 'Sanjana', 'Mysore', 'sanjana@gmail.com', 9871234567);

	INSERT INTO PaymentMode VALUES('COD');
	INSERT INTO PaymentMode VALUES('Debit Card');

	INSERT INTO Sale VALUES(1, 'C1', '2018-12-3', 1);
	INSERT INTO Sale VALUES(2, 'C7', '2018-12-2', 2);
	INSERT INTO Sale VALUES(3, 'C4', '2018-12-11', 1);

	INSERT INTO SaleDetails VALUES(1, 'P1', 10);
	INSERT INTO SaleDetails VALUES(1, 'P12', 9);
	INSERT INTO SaleDetails VALUES(2, 'P6', 7);
	INSERT INTO SaleDetails VALUES(2, 'P2', 1);

	SELECT * FROM Vendors
	SELECT * FROM Category
	SELECT * FROM Products
	SELECT * FROM Customer
	SELECT * FROM PaymentMode
	SELECT * FROM Sale
	SELECT * FROM SaleDetails

	1. Create a procedure to list the sales details of the products belonging to the 
	given vendor and for the given interval 
		
		CREATE OR ALTER PROCEDURE sp_SaleDetails
		@VendorID INT,
		@StartDate DATETIME,
		@EndDate DATETIME
		AS
		BEGIN
			IF NOT EXISTS (SELECT 1 
							FROM Vendors
							WHERE VendorID = @VendorID)
				
							PRINT 'Vendor does not exists'

			IF NOT EXISTS (SELECT 1
							FROM SaleDetails SD
							INNER JOIN Sale S ON SD.BillNum = S.BillNum
							INNER JOIN Products P ON SD.Pid = P.Pid
							WHERE VendorID = @VendorID AND DateOfPurchase BETWEEN @StartDate AND @EndDate)

							PRINT 'Sale does not exists'

			ELSE
				SELECT P.Pid, PName, DateOfPurchase, Quantity, Price
				FROM SaleDetails SD
				INNER JOIN Sale S ON SD.BillNum = S.BillNum
				INNER JOIN Products P ON SD.Pid = P.Pid
				WHERE VendorID = @VendorID AND DateOfPurchase BETWEEN @StartDate AND @EndDate
		END

		DECLARE @VendorID INT, @StartDate DATETIME, @EndDate DATETIME

		EXEC sp_SaleDetails 4, '2023-01-01', '2023-12-30'

	2. Create a procedure to list the sales details of the products belonging to the 
	given vendor and for the given interval where in the total sales amount exceeds 
	the given value 

	CREATE PROCEDURE usp_SaleDetails
	@VendorID INT,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@GivenValue MONEY
	AS
	BEGIN
			SELECT P.Pid, PName, SUM(Price) AS 'Total Sales Amount', SUM(Quantity) AS 'Total Quantity'
			FROM SaleDetails SD
			INNER JOIN Sale S ON SD.BillNum = S.BillNum
			INNER JOIN Products P ON SD.Pid = P.Pid
			WHERE VendorID = @VendorID AND DateOfPurchase BETWEEN @StartDate AND @EndDate
			GROUP BY P.Pid, PName
			HAVING SUM(Price) > @GivenValue
	END	

	DECLARE @VendorID INT, @StartDate DATETIME, @EndDate DATETIME, @GivenValue MONEY

	EXEC usp_SaleDetails 2, '2018-01-01', '2018-12-30', 25000


	3.Create a procedure to list the total no of products sold and the revenue 
	earned for the given category of products within the specified interval 

	CREATE OR ALTER PROCEDURE sp_TotalNumberOfProductsSold
	@CatID INT,
	@StartDate DATETIME,
	@EndDate DATETIME
	AS
	BEGIN
		SELECT SUM((Quantity)* Price) AS 'Revenue Earned', COUNT(P.Pid) AS 'Total Number of Products Sold'
		FROM Products P
		INNER JOIN Category C ON P.CatID = C.CatID
		INNER JOIN SaleDetails SD ON P.Pid = SD.Pid
		WHERE P.CatID = @CatID 
		GROUP BY P.Pid
	END

	DECLARE @CatID INT, @StartDate DATETIME, @EndDate DATETIME

	EXEC sp_TotalNumberOfProductsSold 102, '2018-01-01', '2018-12-30'


	Triggers: 

	1 .Write a Trigger to restrict operations on Employee table 

	CREATE TRIGGER tr_EmployeeDtl
	ON tblEmployeeDtl
	FOR INSERT, UPDATE, DELETE
	AS
	BEGIN
		IF (DATENAME(DW, GETDATE()) IN ('Saturday', 'Sunday'))
			ROLLBACK
		IF (cast(getdate() AS TIME) NOT BETWEEN '09:00 AM' AND '18:30 PM')
			ROLLBACK
	END
		
	SELECT cast(getdate() AS TIME)

	2. Write a Trigger to Alert the user whenever there is an update in tblEmployeedtls table 

	CREATE OR ALTER TRIGGER tr_EmployeeDtlsUpdateAlert
	ON tblEmployeeDtl
	FOR UPDATE
	AS
	BEGIN
		DECLARE @OldEmpName NVARCHAR
	END	

	SELECT * FROM tblEmployeeDtl
