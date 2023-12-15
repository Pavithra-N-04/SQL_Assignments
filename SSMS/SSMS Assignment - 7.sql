
--> Assignment - 7  SALES TABLE:

	CREATE TABLE Salesman(
	Sid INT PRIMARY KEY,
	SName VARCHAR(50),
	Location VARCHAR(50)
	)

	CREATE TABLE Product(
	Pid INT PRIMARY KEY,
	Pdesc VARCHAR(50),
	Price Money,
	Category VARCHAR(50),
	Discount Money
	)

	CREATE TABLE Sale(
	SaleID INT PRIMARY KEY,
	Sid INT FOREIGN KEY REFERENCES Salesman(Sid),
	SDate DATETIME,
	Amount Money
	)

	CREATE TABLE SaleDetail(
	SaleID INT FOREIGN KEY REFERENCES Sale(SaleID),
	Pid INT FOREIGN KEY REFERENCES Product(Pid),
	Quantity INT
	)

--> Inserting values to Salesman table:

	INSERT INTO Salesman VALUES(100, 'ARJUN', 'Mysore');
	INSERT INTO Salesman VALUES(101, 'BHUVAN', 'Bangalore');
	INSERT INTO Salesman VALUES(102, 'CHIRU', 'Udupi');
	INSERT INTO Salesman VALUES(103, 'DHANUSH', 'Hyderabad');
	INSERT INTO Salesman VALUES(104, 'RAVI', 'Chennai');
	INSERT INTO Salesman VALUES(105, 'TARUN', 'Mumbai');

--> Inserting values to Product table:

	INSERT INTO Product VALUES(1000, 'Fridge', 40000, 'Electronics', 10);
	INSERT INTO Product VALUES(1002, 'T-Shirt', 3000, 'Cloths', 15);
	INSERT INTO Product VALUES(1003, 'Laptop', 45000, 'Electronics', 10);
	INSERT INTO Product VALUES(1004, 'Cooker', 5000, 'Home appliances', 20);
	INSERT INTO Product VALUES(1005, 'Grains', 40000, 'Food Item', 5);
	
--> Inserting values to Sale Table:

	INSERT INTO Sale VALUES(1, 100, '04-25-2022', 15000);
	INSERT INTO Sale VALUES(2, 101, '06-15-2015', 18000);
	INSERT INTO Sale VALUES(3, 102, '02-28-2022', 26000);
	INSERT INTO Sale VALUES(4, 103, '10-30-2020', 35000);
	INSERT INTO Sale VALUES(5, 104, '08-18-2021', 60000);
	INSERT INTO Sale VALUES(6, 104, '08-18-2021', 60000);
	INSERT INTO Sale VALUES(7, 104, '05-22-2022', 30000);


--> Inserting values to SaleDEtail table:

	INSERT INTO SaleDetail VALUES(1, 1000, 1);
	INSERT INTO SaleDetail VALUES(2, 1002, 2);
	INSERT INTO SaleDetail VALUES(3, 1003, 1);
	INSERT INTO SaleDetail VALUES(4, 1004, 2);
	INSERT INTO SaleDetail VALUES(5, 1005, 1);

	SELECT * FROM Salesman
	SELECT * FROM Product
	SELECT * FROM Sale
	SELECT * FROM SaleDetail
 
--Write queries for following: 
 
--> 1. Display the sale id and date for most recent sale. 

	SELECT TOP 1 SaleID, SDate
	FROM Sale
	ORDER BY SDate desc

	SET STATISTICS TIME ON

--> 2. Display the names of salesmen who have made at least 2 sales. 

	SELECT SName
	FROM Salesman
	WHERE Sid IN ( SELECT Sid 
	FROM Sale
	GROUP BY Sid
	HAVING COUNT(Sid) >= 2)

--> 3. Display the product id and description of those products which are sold in minimum total quantity. 

	SELECT Pid, Pdesc
	FROM Product 
	WHERE Pid IN (SELECT TOP 1 WITH TIES Pid
	FROM SaleDetail
	GROUP BY Pid
	ORDER BY SUM(Quantity))
	
--> 4. Display SId, SName and Location of those salesmen who have total sales amount greater than average 
-----sales amount of all the sales made. Amount can be calculated from Price and Discount of Product and Quantity sold. 

	SELECT S.Sid, SName, SM.Location
	FROM Salesman SM
	INNER JOIN Sale S ON SM.Sid = S.Sid
	GROUP BY S.Sid, SName, SM.Location
	HAVING SUM(Amount) > ( SELECT AVG(Amount)
	FROM Sale)
 
--Corelated Subquery

--> 5. Display the product id, category, description and price for those products whose price is maximum in each category. 

	SELECT Pid, Category, Pdesc, Price
	FROM Product P1
	WHERE Price = (SELECT MAX(Price)
	FROM Product P2
	WHERE P1.Category = P2.Category
	GROUP BY Category)

	SELECT * FROM Product

--> 6. Display the names of salesmen who have not made any sales. 

	SELECT SName 
	FROM Salesman 
	WHERE Sid NOT IN ( 
	SELECT DISTINCT Sid
	FROM Sale)
	
--> 7. Display the names of salesmen who have made at least 1 sale in the month of Jun 2015.

	SELECT SName
	FROM Salesman
	WHERE Sid IN (
	SELECT Sid 
	FROM Sale
	WHERE DATENAME(MM, SDate) = 'June' AND DATENAME(YYYY, SDate) = 2015
	GROUP BY Sid
	HAVING COUNT(Sid) >= 1)
	
--> 8. Display SId, SName and Location of those salesmen who have total sales amount greater than average total sales amount of 
--their location calculated per salesman. Amount can be calculated from Price and Discount of Product and Quantity sold. 
	
	SELECT SM.Sid, SName, Location
	FROM Salesman SM
	INNER JOIN Sale S ON SM.Sid = S.Sid
	GROUP BY SM.Sid, SName, Location
	HAVING SUM(Amount) > (SELECT AVG(Amount)
	FROM Salesman SM2
	INNER JOIN Sale S ON SM2.Sid = S.Sid
	WHERE SM2.Location = SM.Location)

	UPDATE Sale
	SET Amount = Amt
	FROM ( SELECT S.Saleid, S.Sid, SUM((P.Price - P.Discount) * SD.Quantity) Amt
	FROM Sale S
	INNER JOIN SaleDetail SD ON S.Saleid = SD.Saleid
	INNER JOIN Product P ON P.Pid = SD.Pid
	GROUP BY S.Saleid, S.Sid) AS OpTbl
	WHERE Sale.Saleid = OpTbl.Saleid

	select * from salesman
	select * from sale

	


	);


