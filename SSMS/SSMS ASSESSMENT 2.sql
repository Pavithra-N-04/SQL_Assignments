
	
	--08-12-2023
--> SQL Assessment - 2:

--> Script to create Users table:

	CREATE TABLE tblUsers(
	UserID INT PRIMARY KEY,
	UserName VARCHAR(50),
	Email VARCHAR(50)
	)
	
--> Script to create Category table:

	CREATE TABLE tblCategories(
	CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(50),
	Discription VARCHAR(50)
	)
	
--> Script to create Products table:

	CREATE TABLE tblProducts(
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(50),
	Quantity INT,
	ProductPrice INT,
	CategoryID INT FOREIGN KEY REFERENCES tblCategories(CategoryID)
	)
	
--> Script to create Sales table:

	CREATE TABLE tblSales(
	SaleID INT PRIMARY KEY,
	SalesUserID INT FOREIGN KEY REFERENCES tblUsers(UserID),
	ProductID INT FOREIGN KEY REFERENCES tblProducts(ProductID)
	)
	
--> Inserting values to User Table:

	INSERT INTO tblUsers VALUES(1001,'Akash','akash@gmail.com'); 
	INSERT INTO tblUsers VALUES(1002,'Arvind','arvind123@gmail.com');
	INSERT INTO tblUsers VALUES(1003,'Sakshi','sakshimys12@gmail.com');
	INSERT INTO tblUsers VALUES(1004,'Kumar','kumar987@gmail.com');
	
--> Inserting values to Category Table:

	INSERT INTO tblCategories VALUES(201,'Electronics','One stop for electronic items'); 
	INSERT INTO tblCategories VALUES(202,'Apparel','Apparel is the next destination for fashion'); 
	INSERT INTO tblCategories VALUES(203,'Grocery','All needs in one place');
	
--> Inserting values to Product Table:

	INSERT INTO tblProducts VALUES(1,'Mobile Phone',1000,15000,201);
	INSERT INTO tblProducts VALUES(2,'Television',500,40000,201); 
	INSERT INTO tblProducts VALUES(3,'Denims',2000,700,202); 
	INSERT INTO tblProducts VALUES(4,'Vegetables',4000,40,203); 
	INSERT INTO tblProducts VALUES(5,'Ethnic Wear',300,1500,202); 
	INSERT INTO tblProducts VALUES(6,'Wireless Earphone',5000,2500,201); 
	INSERT INTO tblProducts VALUES(7,'Lounge Wear',200,1600,202); 
	INSERT INTO tblProducts VALUES(8,'Refrigerator',50,30000,201); 
	INSERT INTO tblProducts VALUES(9,'Pulses',60,150,202); 
	INSERT INTO tblProducts VALUES(10,'Fruits',100,250,203);
	
--> Inserting values to Sales Table:

	INSERT INTO tblSales VALUES(500,1001,1); 
	INSERT INTO tblSales VALUES(501,1002,1); 
	INSERT INTO tblSales VALUES(502,1003,2); 
	INSERT INTO tblSales VALUES(504,1004,3); 
	INSERT INTO tblSales VALUES(505,1004,1); 
	INSERT INTO tblSales VALUES(506,1004,1); 
	INSERT INTO tblSales VALUES(507,1002,2); 
	INSERT INTO tblSales VALUES(508,1003,8); 
	INSERT INTO tblSales VALUES(509,1001,10); 
	INSERT INTO tblSales VALUES(510,1001,9);
	
	SELECT * FROM tblUsers;
	SELECT * FROM tblCategories;
	SELECT * FROM tblProducts;
	SELECT * FROM tblSales;
	
	Questions:
 
	1. Write a function to fetch the names of the product,category and users along with the cost for 
		each product sold depending on the sales_id. 
		Also if the cost for each product is more than 2000, then display a message stating 
		that 'The product has gained profit'.  
		If the product cost is between 500 and 1000, then raise a message stating that 
		'The product has occured loss'.  
		If the product cost is less than 500, then raise an exception stating 'No profit no loss'. 

		CREATE OR ALTER FUNCTION udf_ProductDetails(@SaleID INT)
		RETURNS TABLE
		AS 
		RETURN
		(
			SELECT P.ProductName, C.CategoryName, U.UserName, P.ProductPrice,
				CASE 
					WHEN P.ProductPrice > 2000 THEN 'The product has gained profit'
					WHEN P.ProductPrice BETWEEN 500 AND 1000 THEN 'The product has occurred loss'
					WHEN P.ProductPrice < 500 THEN 'No profit No loss' 
				END AS Profit_Loss_Status
			FROM tblSales S
			INNER JOIN tblProducts P ON S.ProductID = P.ProductID
			INNER JOIN tblUsers U ON S.SalesUserID = U.UserID
			INNER JOIN tblCategories C ON P.CategoryID = C.CategoryID
			WHERE S.SaleID = @SaleID
		);

		SELECT * FROM dbo.udf_ProductDetails(503);

			
	2. Write a procedure to update the name of the category from 'Electronics' to 'Modern Gadgets' and 
		also  fetch the category and product names when the userid is passed as the input parameter. 

		CREATE OR ALTER PROCEDURE usp_UpdateCategory(
		@UserID INT
		)
		AS 
		BEGIN
			IF NOT EXISTS ( SELECT 1
							FROM tblUsers                                                                                                                                                                   
							WHERE UserID = @UserID )
				BEGIN
					RAISERROR('Invalid User ID', 16, 1)  
					RETURN
				END
			BEGIN TRY
				BEGIN TRAN
					UPDATE tblcategories
					SET CategoryName = 'Modern Gadgets'
					WHERE CategoryName = 'Electronics';

					SELECT P.ProductName, C.CategoryName, COUNT(P.ProductID) AS 'Total Number of Products'
					FROM tblSales S
					INNER JOIN tblProducts P ON S.ProductID = P.ProductId
					INNER JOIN tblCategories C ON P.CategoryID = C.CategoryID
					WHERE S.SalesUserID = @UserID
					GROUP BY P.ProductName, C.CategoryName, P.ProductID
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK
			END CATCH
		END

		EXEC usp_UpdateCategory 1001

		SELECT * FROM tblCategories;

		
