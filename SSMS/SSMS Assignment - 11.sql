
--Assignment - 11

--> CREATE USER TABLE:

	CREATE TABLE Users(
	UserID VARCHAR(50) PRIMARY KEY,
	UserName VARCHAR(50) NOT NULL,
	Password VARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	Gender CHAR(1),
	EmailID VARCHAR(50) UNIQUE,
	PhoneNumber NUMERIC(10) NOT NULL
	)

--> CREATE BOOKING DETAILS TABLE:

	CREATE TABLE BookingDetails(
	BookingID VARCHAR(50),
	UserID VARCHAR(50),
	ShowID INT,
	NoOfTickets INT,
	TotalAmt DECIMAL(6, 2)
	)

--> CREATE SHOW DETAILS TABLE:

	CREATE TABLE ShowDetails(
	ShowID INT,
	TheaterID INT,
	ShowTime TIME,
	ShowDate DATE,
	MovieName VARCHAR(50),
	TicketCost DECIMAL(6, 2),
	TicketsAvailable INT
	)

--> CREATE TABLE THEATER DETAILS

	CREATE TABLE TheaterDetails(OfTickets
	TheaterID INT,
	TheaterName VARCHAR(50),
	Location VARCHAR(50)
	)

--> INSERTING VALUES TO USERS TABLE:

	INSERT INTO Users VALUES('mary_potter', 'Marry Potter', 'mary@123', 25, 'F', 'mary_p@gmail.com', 9786543211);	
	INSERT INTO Users VALUES('jack_sparrow', 'Jack Sparrow', 'Spar78!jack', 28, 'M','jack_spa@yahoo.com', 7865432102);

--> INSERTING VALUES TO BOOKING TABLE:

	INSERT INTO BookingDetails VALUES('B1001', 'jack_sparrow', 1001, 2, 500.00);
	INSERT INTO BookingDetails VALUES('B1002', 'mary_potter', 1002, 5, 1000.00);

--> INSERTING VALUES TO SHOW DETAILS TABLE:

	INSERT INTO ShowDetails VALUES(1001, 1, '14:30:00', '2023-11-28', 'Avengers', 250.00, 100);
	INSERT INTO ShowDetails VALUES(1002, 2, '17:30:00','2023-11-26', 'Hitman', 200.00, 150);

--< INSERTING VALUES TO THEATER DETAILS TABLE:

	INSERT INTO TheaterDetails VALUES(1, 'PVR', 'Mysuru');
	INSERT INTO TheaterDetails VALUES(2, 'INOX', 'Bengaluru');


	1. Stored Procedure: usp_BookTheTicket
	Create a stored procedure named usp_BookTheTicket to insert values into the BookingDetails table. 
	Implement appropriate exception handling.
	Input Parameters:
	UserId
	ShowId
	NoOfTickets
	Functionality:
	Check if UserId is present in Users table
	Check if ShowId is present in ShowDetails table
	Check if NoOfTickets is a positive value and is less than or equal to TicketsAvailable value for the particular ShowId
	If all the validations are successful, insert the data by generating the BookingId and calculate the total amount 
	based on the TicketCost
	Return Values:
	1, in case of successful insertion
	-1,if UserId is invalid
	-2,if ShowId is invalid
	-3,if NoOfTickets is less than zero
	-4,if NoOfTickets is greater than TicketsAvailable
	-99,in case of any exception

	CREATE OR ALTER PROCEDURE usp_BookTheTicket
	@UserID VARCHAR(50),
	@ShowID INT,
	@NoOfTickets INT
	AS
	BEGIN
		IF NOT EXISTS (SELECT 1
					   FROM Users
					   WHERE UserID = @UserID)
			BEGIN
				PRINT 'Invalid User ID'
				RETURN -1
			END
		IF NOT EXISTS (SELECT 1
						FROM ShowDetails
						WHERE ShowID = @ShowID)
			BEGIN
				PRINT 'Invalid Show ID'
				RETURN -2
			END
		IF @NoOfTickets <= 0
			BEGIN
				PRINT 'Invalid Number of Tickets'
				RETURN -3
			END
		IF @NoOfTickets > (SELECT TicketsAvailable
							FROM ShowDetails
							WHERE ShowID = @ShowID)
			BEGIN
				PRINT 'Tickets Unavailable'
				RETURN -4
			END

		BEGIN TRY
			BEGIN TRANSACTION
			DECLARE @MaxID VARCHAR(10), @Price MONEY

			SELECT @MaxID = 'B' + CAST(RIGHT(MAX([BookingID]), 4) + 1 AS VARCHAR)
			FROM BookingDetails

			SELECT @Price = TicketCost
			FROM ShowDetails
			WHERE ShowID = @ShowID

			INSERT INTO BookingDetails(BookingID, UserID, ShowID, NoOfTickets, TotalAmt) 
			VALUES(@MaxID, @UserID, @ShowID, @NoOfTickets, @Price * @NoOfTickets)

			UPDATE ShowDetails
			SET TicketsAvailable = TicketsAvailable - @NoOfTickets
			WHERE ShowID = @ShowID

			COMMIT TRANSACTION
			RETURN 1
		END TRY

		BEGIN CATCH
			ROLLBACK
			PRINT 'Other Exception'
			RETURN -99
		END CATCH
	END

	EXEC usp_BookTheTicket 'jack_sparrow', 1001, 3

	SELECT * FROM Users
	SELECT * FROM ShowDetails
	SELECT * FROM BookingDetails
	SELECT * FROM TheaterDetails


	2. Function: ufn_GetMovieShowtimes
	Create a function ufn_GetMovieShowtimes to get the show details based on the MovieName 
	and Location
	Input Parameter:
	MovieName
	Location
	Functionality:
	Fetch the details of the shows available for a given MovieName in a location
	Return Value:
	A table containing following fields:
	MovieName	ShowDate	ShowTime	TheatreName	TicketCost

	CREATE FUNCTION ufn_GetMovieShowtimes(@MovieName VARCHAR(50), @Location VARCHAR(50))
	RETURNS TABLE AS 
	RETURN
		SELECT MovieName, ShowDate,	ShowTime, TheaterName, TicketCost
		FROM ShowDetails SD
		INNER JOIN TheaterDetails TD ON SD.TheaterID = TD.TheaterID
		WHERE MovieName = @MovieName AND Location = @Location 

	SELECT * FROM dbo.ufn_GetMovieShowtimes('Hitman', 'Bengaluru')


 	3. Function: ufn_BookedDetails
	Create a function ufn_BookedDetails to get the booking details based on the BookingId
	Input Parameter:
	⦁	BookingId
	Functionality:
	⦁	Fetch the details of the ticket purchased based on the BookingId
	Return Value:
	A table containing following fields:
	BookingId	UserName	MovieName	TheatreName	ShowDate	ShowTime	NoOfTickets	TotalAmt

	CREATE OR ALTER FUNCTION ufn_BookedDetails(@BookingID VARCHAR(50))
	RETURNS TABLE AS
	RETURN
		SELECT BookingId, UserName,	MovieName, TheaterName,	ShowDate, ShowTime, 
		NoOfTickets, TotalAmt
		FROM BookingDetails B
		INNER JOIN Users U ON B.UserID = U.UserID
		INNER JOIN ShowDetails S ON B.ShowID = S.ShowID
		INNER JOIN TheaterDetails T ON S.TheaterID = T.TheaterID
		WHERE BookingID = @BookingID

	SELECT * FROM dbo.ufn_BookedDetails('B1002')
