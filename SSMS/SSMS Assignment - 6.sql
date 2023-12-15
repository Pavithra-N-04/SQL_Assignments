

	CREATE DATABASE BANK

	USE BANK

	--> Assignment - 6 Bank Transaction 

	CREATE TABLE TransactionType(
	  TransType int primary key,
	  TransName varchar(50)
	);

	CREATE TABLE AccountType(
	  AccType int primary key,
	  AccountName varchar(30)
	);

	CREATE TABLE CustomerDetails(
	  AccNo int primary key,
	  CustName varchar(50),
	  Address varchar(50),
	  AccType int FOREIGN KEY REFERENCES AccountType(AccType)
	);

	CREATE TABLE AccountTransaction(
	  Tid int primary key,
	  AccNo int FOREIGN KEY REFERENCES CustomerDetails(AccNo),
	  Amount money,
	  DateOfTransaction DATETIME,
	  TransType int FOREIGN KEY REFERENCES TransactionType(TransType)
	);

--> Inserting values into Transaction type:

	INSERT INTO TransactionType VALUES(1, 'Deposit');
	INSERT INTO TransactionType VALUES(2, 'Withdrawal');

--> Inserting values into Account type:

	INSERT INTO AccountType VALUES(10, 'Savings');
	INSERT INTO AccountType VALUES(20, 'Current');
	INSERT INTO AccountType VALUES(30, 'Fixed Deposit');

--> Inserting values into Customer Details:

	INSERT INTO CustomerDetails VALUES(1001, 'VIRAT KOHLI', 'Delhi', 10);
	INSERT INTO CustomerDetails VALUES(1002, 'ADAM SMITH', 'Australia', 20);
	INSERT INTO CustomerDetails VALUES(1003, 'JOHN ROCK', 'England', 10);
	INSERT INTO CustomerDetails VALUES(1004, 'DAVID MILLER', 'South Africa', 30);
	INSERT INTO CustomerDetails VALUES(1005, 'ALLAN', 'New York', 20);
	INSERT INTO CustomerDetails VALUES(1006, 'SACHIN', 'Mysore', 20);
	INSERT INTO CustomerDetails VALUES(1007, 'RAHUL', 'Mysore', 10);
	INSERT INTO CustomerDetails VALUES(1008, 'KHUSHI', 'Bangalore', 20);
	INSERT INTO CustomerDetails VALUES(1009, 'KHUSHAL', 'Bangalore', 20);

--> Inserting values into Account Transaction:

	INSERT INTO AccountTransaction VALUES(101, 1001, 10000, '10-05-2000', 1);
	INSERT INTO AccountTransaction VALUES(102, 1002, 25000, '01-25-2002', 2);
	INSERT INTO AccountTransaction VALUES(103, 1003, 100000, '02-15-2005', 1);
	INSERT INTO AccountTransaction VALUES(104, 1004, 150000, '09-28-2020', 2);
	INSERT INTO AccountTransaction VALUES(105, 1005, 70000, '05-17-2022', 2);
	INSERT INTO AccountTransaction VALUES(106, 1006, 85000, '03-18-2022', 1);
	INSERT INTO AccountTransaction VALUES(107, 1007, 8000, '08-24-2020', 1);
	INSERT INTO AccountTransaction VALUES(108, 1008, 20000, '10-29-2023', 2);
	INSERT INTO AccountTransaction VALUES(110, 1009, '10-29-2023', 2);


	SELECT * FROM TransactionType
	SELECT * FROM AccountType
	SELECT * FROM CustomerDetails
	SELECT * FROM AccountTransaction
	SELECT SUM(Amount) FROM AccountTransaction
	SELECT SUM(Amount) FROM AccountTransaction
	SELECT COUNT(Tid) FROM AccountTransaction


--> 1. List the Customer with transaction details who has done third lowest transaction. 

	SELECT TOP 1 WITH TIES *
	--SELECT DISTINCT TOP 1 WITH TIES CustName, Amount, Tid, DateOfTransaction, C.AccNo
	FROM AccountTransaction A
	INNER JOIN CustomerDetails C ON A.AccNo = C.AccNo
	WHERE Amount NOT IN (SELECT DISTINCT TOP 2 Amount 
	FROM AccountTransaction 
	ORDER BY Amount) 
	ORDER BY Amount

	SELECT *
	FROM CustomerDetails C
	INNER JOIN AccountTransaction AT ON C.AccNo = AT.AccNo
	WHERE Amount = (SELECT MAX(Amount)
	FROM AccountTransaction AT 
	WHERE DATENAME(MM, DateOfTransaction) = 'March')

--> 2. List the customers who has done more transactions than average number of  transaction. 

	SELECT CustName
	FROM CustomerDetails C
	INNER JOIN AccountTransaction A ON C.AccNo = A.AccNo
	GROUP BY CustName
	HAVING COUNT(Tid) >= (SELECT AVG([NumberOfTransaction])
	FROM (SELECT COUNT(Tid) [NumberOfTransaction]
	FROM AccountTransaction 
	GROUP BY AccNo) AS [AvgTrans])
	ORDER BY CustName

--> 3. List the total transactions under each account type/account name. 

	SELECT A.AccType, COUNT(Tid) AS 'Total Transaction'--, --, AccountName,  --, SUM(Amount) AS 'Total Amount'
	FROM AccountType A
	INNER JOIN CustomerDetails C ON A.AccType = C.AccType
	INNER JOIN AccountTransaction T ON C.AccNo = T.AccNo
	GROUP BY A.AccType--, AccountName

	  ------OR

	SELECT AT.AccType, COUNT(Tid) AS 'Total Transaction'
	FROM CustomerDetails C
	LEFT OUTER JOIN AccountTransaction A ON C.AccNo = A.AccNo
	INNER JOIN AccountType AT ON C.AccType = AT.AccType
	GROUP BY AT.AccType

--> 4. List the total amount of transaction under each account type.
	
	SELECT SUM(Amount) AS 'Total Amount of Transaction', AT.AccType
	FROM CustomerDetails C 
	INNER JOIN AccountType AT ON C.AccType = AT.AccType
	INNER JOIN AccountTransaction A ON C.AccNo = A.AccNo
	GROUP BY AT.AccType

--> 5. List the total transactions along with the total amount on a Sunday.

	SELECT COUNT(Tid) AS 'Total Transactions', SUM(Amount) AS 'Total Amount'
	FROM AccountTransaction 
	WHERE DATENAME(DW, DateOfTransaction) = 'Sunday'

--> 6. List the name, address, account type and total deposit from each customer account. 

	SELECT CustName, Address, AccType, SUM(Amount) AS 'Total Deposit'
	FROM AccountTransaction A
	INNER JOIN CustomerDetails C ON C.AccNo = A.AccNo
	RIGHT OUTER JOIN TransactionType T ON A.TransType = T.TransType
	WHERE T.TransType = 1
	GROUP BY CustName, Address, AccType

--> 7. List the total amount of transactions of Mysore customers. 

	SELECT SUM(Amount) AS 'Total Amount of Transaction'
	FROM AccountTransaction A
	INNER JOIN CustomerDetails C ON A.AccNo = C.AccNo
	WHERE Address = 'Mysore'

	SELECT SUM(Amount) AS 'Total Transaction'
	FROM  AccountTransaction  AT
	INNER JOIN CustomerDetails C ON AT.AccNo = C.AccNo 
	WHERE DATENAME(MM, DateOfTransaction) = 'October' AND DATENAME(YYYY, DateOfTransaction) = 2023

--> 8. List the name, account type and the number of transactions performed by each customer. 

	SELECT CustName, AT.AccType, COUNT(Tid) AS 'Number of Transactions'
	FROM CustomerDetails C
	LEFT OUTER JOIN AccountTransaction A ON C.AccNo = A.AccNo
	INNER JOIN AccountType AT ON C.AccType = AT.AccType
	GROUP BY CustName, AT.AccType

--> 9. List the amount of transaction from each Location.

	SELECT SUM(Amount) AS 'Total Transaction', Address
	FROM AccountTransaction A
	INNER JOIN CustomerDetails C ON A.AccNo = C.AccNo
	GROUP BY Address

--> 10. Find out the number of customers  Under Each Account Type.

	SELECT A.AccType, COUNT(A.AccType) AS 'Number of Customers'
	FROM CustomerDetails C
	LEFT OUTER JOIN AccountType A ON C.AccType = A.AccType
	GROUP BY A.AccType

	SELECT Tid, AT.AccNo, DateOfTransaction, Amount, CustName 
	FROM AccountTransaction AT 
	INNER JOIN CustomerDetails C ON AT.AccNo = C.AccNo 

	SELECT TOP 1 WITH TIES CustName, AT.AccNo, Amount
	FROM AccountTransaction AT 
	INNER JOIN CustomerDetails C ON AT.AccNo = C.AccNo
	WHERE Amount NOT IN (SELECT DISTINCT TOP 3 Amount
	FROM AccountTransaction AT 
	ORDER BY Amount desc)
	ORDER BY Amount

	SELECT Tid, AT.AccNo, dateOfTransaction, CustName, Amount 
	FROM AccountTransaction AT 
	INNER JOIN CustomerDetails C ON AT.AccNo = C.AccNo 

	SELECT CustName
	FROM CustomerDetails C
	WHERE NOT EXISTS (SELECT AccNo 
	FROM AccountTransaction AT 
	WHERE C.AccNo = AT.AccNo)



	
