	
--  08-12-2023
--> PGSQL Assessment:

--> Script to create Users table:

	CREATE TABLE tblUsers(
	UserID INT PRIMARY KEY,
	UserName VARCHAR(50),
	Email VARCHAR(50)
	)
	
--> Script to create Category table:

	CREATE TABLE tblCategory(
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
	CategoryID INT REFERENCES tblCategory(CategoryID)
	)
	
--> Script to create Sales table:

	CREATE TABLE tblSales(
	SaleID INT PRIMARY KEY,
	SalesUserID INT REFERENCES tblUsers(UserID),
	ProductID INT REFERENCES tblProducts(ProductID)
	)
	
--> Inserting values to User Table:

	INSERT INTO tblUsers VALUES(1001,'Akash','akash@gmail.com'); 
	INSERT INTO tblUsers VALUES(1002,'Arvind','arvind123@gmail.com');
	INSERT INTO tblUsers VALUES(1003,'Sakshi','sakshimys12@gmail.com');
	INSERT INTO tblUsers VALUES(1004,'Kumar','kumar987@gmail.com');
	
--> Inserting values to Category Table:

	INSERT INTO tblCategory VALUES(201,'Electronics','One stop for electronic items'); 
	INSERT INTO tblCategory VALUES(202,'Apparel','Apparel is the next destination for fashion'); 
	INSERT INTO tblCategory VALUES(203,'Grocery','All needs in one place');
	
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
	INSERT INTO tblSales VALUES(508,1003,1); 
	INSERT INTO tblSales VALUES(509,1001,7); 
	INSERT INTO tblSales VALUES(510,1001,8);
	
	SELECT * FROM tblUsers;
	SELECT * FROM tblCategory;
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
	
	CREATE OR REPLACE FUNCTION udf_ProductDetails(F_SaleID INT)
	RETURNS TABLE(
		ProductName VARCHAR(50), 
		CategoryName VARCHAR(50), 
		UserName VARCHAR(50),
		ProductPrice INT
	)
	LANGUAGE plpgsql
	AS
	$$
	DECLARE 
		ProductCost INT;
	BEGIN
		SELECT P.ProductName, C.CategoryName, U.UserName, P.ProductPrice
		INTO ProductName, CategoryName, UserName, ProductPrice
		FROM tblSales S
		INNER JOIN tblProducts P ON S.ProductID = P.ProductID
		INNER JOIN tblUsers U ON S.SalesUserID = U.UserID
		INNER JOIN tblCategory C ON P.CategoryID = C.CategoryID
		WHERE S.SaleID = F_SaleID;
		
		SELECT P.ProductPrice INTO ProductCost
		FROM tblProducts P
		INNER JOIN tblSales S USING (ProductID)
		WHERE S.SaleID = F_SaleID;
		
		IF ProductCost > 2000 THEN
				RAISE NOTICE 'The product has gained profit';
	
		ELSIF ProductCost BETWEEN 500 AND 1000 THEN
				RAISE NOTICE  'The product has occured loss';
				 	
		ELSIF ProductCost < 500 THEN
				RAISE NOTICE 'No profit No loss';
		END IF;
		RETURN NEXT;
		RETURN;
	END;
	$$;
		
		SELECT * FROM udf_ProductDetails(504);
		
			
	2. Write a procedure to update the name of the category from 'Electronics' to 'Modern Gadgets' and 
		also  fetch the category and product names when the userid is passed as the input parameter. 

		CREATE OR REPLACE  PROCEDURE C_UPDATE( IN U_ID INT,
			INOUT C_NAME VARCHAR(30) DEFAULT NULL,
			INOUT P_NAME VARCHAR(30) DEFAULT NULL
		)
		LANGUAGE PLPGSQL
		AS $$
		BEGIN
		UPDATE  tblcategory
		SET CategoryName = 'Modern Gadgets'
		WHERE CategoryName = 'Electronics';

			SELECT
			P.ProductName, C.CategoryName
			FROM
			tblSales s INNER JOIN tblProducts p USING(ProductId)
			INNER JOIN tblCategory c USING(CategoryId)
			WHERE s.Salesuserid = U_ID INTO P_NAME, C_NAME;

			RAISE NOTICE '%''%', P_NAME, C_NAME;
		END;
		$$;

		CALL C_UPDATE(1004);


		
