
--> Assessment - 20-Nov-2023

	USE PAYROLL

--> SQL script to create Customer table

	CREATE TABLE tblCustomer(
	CustID VARCHAR(10) PRIMARY KEY,
	CustName VARCHAR(50)
	)

--> SQL script to create Flight table

	CREATE TABLE tblFlight(
	FlightID VARCHAR(10) PRIMARY KEY,
	FlightName VARCHAR(50),
	FlightType VARCHAR(50),
	Source VARCHAR(50),
	Destination VARCHAR(50),
	FlightCharge MONEY,
	TicketsAvailable INT,
	TravelClass VARCHAR(10)
	)

--> SQL script to create Booking table

	CREATE TABLE tblBooking(
	BookingID INT PRIMARY KEY,
	FlightID VARCHAR(10),
	CustID VARCHAR(10),
	TravelClass VARCHAR(10),
	NoOfSeats INT,
	BookingDate DATETIME,
	TotalAmt MONEY
	)

--> Insert values to Customer table:

	INSERT INTO tblCustomer VALUES('C301', 'John');	
	INSERT INTO tblCustomer VALUES('C302', 'Sam');	
	INSERT INTO tblCustomer VALUES('C303', 'Robert');
	INSERT INTO tblCustomer VALUES('C304', 'Albert');
	INSERT INTO tblCustomer VALUES('C305', 'Jack');
	INSERT INTO tblCustomer VALUES('C306', 'David');


--> Insert values to Flight table:

	INSERT INTO tblFlight VALUES('F101', 'Spice Jet Airlines', 'Domestic', 'Mumbai', 'Kolkata', 12000, 10, 'Business');
	INSERT INTO tblFlight VALUES('F102', 'Indian Airlines', 'International', 'Delhi', 'Germany', 20000, 5, 'Business');
	INSERT INTO tblFlight VALUES('F103', 'Deccan Airlines', 'Domestic', 'Chennai', 'Benagluru', 3000, 8, 'Economy');
	INSERT INTO tblFlight VALUES('F104', 'British Jet Airlines', 'International', 'London', 'Italy', 22000, 15, 'Economy');
	INSERT INTO tblFlight VALUES('F105', 'Swiss Airlines', 'International', 'Zurich', 'Spain', 30000, 20, 'Business');

--> Insert values to Booking table:

	INSERT INTO tblBooking VALUES(201, 'F101', 'C301', 'Business', 2, '2018-Mar-22', 24000);
	INSERT INTO tblBooking VALUES(202, 'F105', 'C303', 'Business', 3, '2018-May-17', 90000);
	INSERT INTO tblBooking VALUES(203, 'F103', 'C302', 'Economy', 4, '2018-Jun-23', 12000);
	INSERT INTO tblBooking VALUES(204, 'F101', 'C302', 'Business', 3, '2018-Oct-12', 36000);
	INSERT INTO tblBooking VALUES(205, 'F104', 'C303', 'Economy', 2, '2019-Jan-16', 44000);
	INSERT INTO tblBooking VALUES(206, 'F105', 'C301', 'Business', 1, '2019-Jan-22', 30000);
	INSERT INTO tblBooking VALUES(207, 'F104', 'C304', 'Economy', 3, '2019-Feb-16', 66000);
	INSERT INTO tblBooking VALUES(208, 'F101', 'C304', 'Business', 4, '2019-Sep-18', 48000);

	SELECT * FROM tblCustomer	
	SELECT * FROM tblFlight	
	SELECT * FROM tblBooking

--> Create Stored Procedure:

	CREATE OR ALTER PROCEDURE usp_BookTheTickets 
	@CustId VARCHAR(10),
	@FlightId VARCHAR(10),
	@NoOfSeats INT,
	@TicketsAvailable INT OUTPUT
	AS
	BEGIN
		IF NOT EXISTS(SELECT 1
					  FROM tblCustomer
					  WHERE CustID = @CustID)
			BEGIN
				PRINT 'Invaid Customer ID'
				RETURN -1
			END

		IF NOT EXISTS(SELECT 1
					  FROM tblFlight
					  WHERE FlightID = @FlightID)
			BEGIN
				PRINT 'Invaid Flight ID'
				RETURN -2
			END

		IF @NoOfSeats <= 0
			BEGIN
				PRINT 'Invalid Number of Seats'
				RETURN -3
			END

		IF @NoOfSeats > (SELECT TicketsAvailable
						 FROM tblFlight
						 WHERE FlightID = @FlightID)
			BEGIN
				PRINT 'Tickets Unavailable'
				RETURN -4
			END
		
		BEGIN TRY
			BEGIN TRAN
				DECLARE @BID INT, @Amt MONEY, @TravelClass VARCHAR(10)

				SELECT @BID = MAX([BookingID]) + 1 
				FROM tblBooking

				SELECT @Amt = FlightCharge, @TravelClass = TravelClass
				FROM tblFlight
				WHERE FlightID = @FlightID

				INSERT INTO tblBooking(BookingID, FlightID, CustID, TravelClass, NoOfSeats, BookingDate, TotalAmt)
				VALUES(@BID, @FlightID, @CustID, @TravelClass, @NoOfSeats, GETDATE(), @Amt * @NoOfSeats)

				UPDATE tblFlight
				SET TicketsAvailable = TicketsAvailable - @NoOfSeats
				WHERE FlightID = @FlightID
			COMMIT TRAN
			SELECT @TicketsAvailable = TicketsAvailable
			FROM tblFlight
			WHERE FlightID = @FlightID
			RETURN 1
		END TRY

		BEGIN CATCH
			ROLLBACK
			PRINT 'Other Exception'
			RETURN -99
		END CATCH
	END

	DECLARE @Status INT, @TicketsAvailable INT 
	EXEC @Status = usp_BookTheTickets 'C302', 'F103', 1, @TicketsAvailable OUTPUT
	PRINT @Status
	PRINT 'There are '+CAST(@TicketsAvailable AS VARCHAR)+' available tickets.'

	SELECT * FROM tblBooking

	SELECT * FROM tblCustomer

	SELECT * FROM tblFlight


--> Create Function:

	CREATE OR ALTER FUNCTION ufn_BookedDetails(@BookingID INT)
	RETURNS TABLE 
	AS
	RETURN
		SELECT BookingId, CustName, FlightName, Source, Destination, BookingDate, NoOfSeats, TotalAmt 
		FROM tblBooking B
		INNER JOIN tblCustomer C ON B.CustID = C.CustID
		INNER JOIN tblFlight F ON B.FlightID = F.FlightID 
		WHERE BookingID = @BookingID


	SELECT * FROM dbo.ufn_BookedDetails(201)

--> Assignment - 13

	1. Identify the customer(s) who have not booked any flight tickets or not booked any flights tickets of travel class ‘Economy’.
	   Display custid and custname of the identified customer(s). 

	   SELECT * 
	   FROM tblCustomer C
	   WHERE CustID NOT IN (SELECT DISTINCT CustID
	   FROM tblBooking B
	   WHERE B.TravelClass = 'Economy')

	2. Identify the booking(s) with flightcharge greater than the average flightcharge of all the flights booked for the same 
	   travel class. Display flightid, flightname and  custname of the identified bookings(s). 

	   SELECT DISTINCT F.FlightID, F.FlightName, C.CustName
	   FROM tblFlight F
	   INNER JOIN tblBooking B ON F.FlightID = B.FlightID
	   INNER JOIN tblCustomer C ON B.CustID = C.CustID
	   WHERE F.FlightCharge > (
							  SELECT AVG(F1.FlightCharge)
							  FROM tblFlight F1
							  WHERE F1.TravelClass = F.TravelClass)


	3. Identify the bookings done by the same customer for the same flight type and travel class. 
	   Display flightid and the flighttype of the identified bookings. 

	   SELECT DISTINCT F.FlightID, F.FlightType
	   FROM tblBooking B
	   INNER JOIN tblFlight F ON B.FlightID = F.FlightID
	   WHERE F.FlightID IN (SELECT FlighTiD
					        FROM tblBooking B1
							GROUP BY CustID, FlightID, TravelClass
						    HAVING COUNT(B1.FlightID) > 1)

	4. Identify the flight(s) for which the bookings are done to destination ‘Kolkata’, ‘Italy’ or ‘Spain’.Display flightid and 
	   flightcharge of the identified booking(s) in the increasing order of flightname and decreasing order of flightcharge. 

	   SELECT DISTINCT F.FlightID, F.FlightCharge, FlightName
	   FROM tblFlight F
	   INNER JOIN tblBooking B ON F.FlightID = B.FlightID -- AND Destination IN ('Kolkata', 'Italy', 'Spain')
	   WHERE Destination IN ('Kolkata', 'Italy', 'Spain')
	   ORDER BY FlightName, FlightCharge desc

	5. Identify the month(s) in which the maximum number of bookings are made. Display custid and custname of the customers 
	   who have booked flights tickets in the identified month(s). 

	   SELECT C.CustID, CustName
	   FROM tblCustomer C
	   INNER JOIN tblBooking B ON C.CustID = B.CustID
	   WHERE MONTH(B.BookingDate) IN (SELECT TOP 1 MONTH(BookingDate)
	                                  FROM tblBooking B1
									  GROUP BY BookingDate, B1.CustID, CustName
									  HAVING COUNT(*) > 1 
									  ORDER BY B1.BookingDate desc)


	6. Identify the booking(s) done in the year 2019 for the flights having the letter ‘u’ anywhere in their source or 
	   destination and booked by the customer having atleast 5 characters in their name. Display bookingid prefixed with ‘B’ 
	   as “BOOKINGID” ( column alias) and the numeric part of custid as “CUSTOMERID” (column alias) for the identified booking(s). 

	   SELECT 'B'+BookingID AS BOOKINGID, CAST(RIGHT(CustID, 3) AS INT) AS CUSTOMERID
	   FROM tblBooking B
	   WHERE YEAR(BookingDate) = 2019 AND ((CHARINDEX('u', Source) > 0 AND CHARINDEX('u', Destination) > 0 ) 
	         AND LEN(CustName) >= 5)

	   SELECT * 
	   FROM tblFlight

	7. Identify the customer(s) who have booked the seats of travel class ‘Business’ for maximum number of times. 
	   Display custid and custname of the identified customer(s). 

	   SELECT DISTINCT CustID, CustName
	   FROM tblCustomer 
	   WHERE CustID IN (SELECT CustID
						FROM tblBooking 
						WHERE TravelClass = 'Business'
						GROUP BY CustID
						ORDER BY COUNT(*) DESC)

	8. Identify the bookings done with the same flightcharge. For every customer who has booked the identified bookings, 
	   display custname and bookingdate as “BDATE” (column alias). Display ‘NA’ in BDATE if the customer does not have any booking 
	   or if no such booking is done by the customer. 

	9. Identify the customer(s) who have paid highest flightcharge for the travel class economy. Write a SQL query to display id, 
	   flightname and name of the identified customers. 

	   SELECT C.CustID, F.FlightName, C.CustName
	   FROM tblBooking B
	   INNER JOIN tblCustomer C ON B.CustID = C.CustID
	   INNER JOIN tblFlight F ON B.FlightID = F.FlightID
	   WHERE B.TravelClass = 'Economy'
	   ORDER BY F.FlightCharge DESC

	10. Identify the International flight(s) which are booked for the maximum number of times.
	    Write a SQL query to display id and name of the identified flights.

		SELECT F.FlightID, FlightName
		FROM tblFlight F
		INNER JOIN tblBooking B ON F.FlightID = B.FlightID
		WHERE FlightType = 'International'
		GROUP BY F.FlightID, FlightName
		ORDER BY COUNT(B.FlightID) DESC;
	
	11. Identify the customer(s) who have bookings during the months of October 2018 to January 2019 and paid overall total 
	    flightcharge less than the average flightcharge of all bookings belonging to travel class ‘Business’. 
	    Write a SQL query to display id and name of the identified customers. 

		SELECT C.CustID, CustName
		FROM tblCustomer C
		INNER JOIN tblBooking B ON C.CustID = B.CustID
		INNER JOIN tblFlight F ON B.FlightID = F.FlightID
		WHERE BookingDate BETWEEN '2018-10-01' AND '2019-01-31' 
		AND F.FlightCharge < ( SELECT AVG(F2.FlightCharge)
							   FROM tblBooking B2
							   INNER JOIN tblFlight F2 ON B2.TravelClass = F2.TravelClass
							   WHERE B2.TravelClass = 'Business')
		GROUP BY C.CustID, CustName

	12. Identify the bookings with travel class ‘Business’ for the International flights.Write a SQL query to display booking id, 
		flight id and customer id of those customer(s) not having letter ‘e’ anywhere in their name and have booked the identified flight(s).
		
		SELECT DISTINCT B.BookingID, F.FlightID, C.CustID, CustName
		FROM tblBooking B
		INNER JOIN tblFlight F ON B.FlightID = F.FlightID
		INNER JOIN tblCustomer C ON B.CustID = C.CustID
		WHERE B.TravelClass = 'Business' AND FlightType = 'International' AND CustName NOT LIKE '%e%'

	13. Identify the booking(s) which have flight charges paid is less than the average flight charge for all flight ticket 
	    bookings belonging to same flight type. Write a SQL query to display booking id, source city, destination city and 
	    booking date of the identified bookings.  

		SELECT DISTINCT B.BookingID, Source, Destination, BookingDate
		FROM tblBooking B
		INNER JOIN tblFlight F ON B.FlightID = F.FlightID
		WHERE F.FlightCharge < ( SELECT AVG(F2.FlightCharge)
							     FROM tblBooking B2
							     INNER JOIN tblFlight F2 ON B2.FlightID = F2.FlightID)
		ORDER BY B.BookingID
							    -- GROUP BY FlightType, B.BookingID, Source, Destination, BookingDate

	14. Write a SQL query to display customer’s id and name of those customers who have paid the flight charge which is more than 
	    the average flightcharge for all international flights. 

		SELECT DISTINCT C.CustID, CustName
		FROM tblCustomer C
		INNER JOIN tblBooking B ON C.CustID = B.CustID
		INNER JOIN tblFlight F ON B.FlightID = F.FlightID
		WHERE F.FlightCharge > ( SELECT AVG(F2.FlightCharge)
		                         FROM tblFlight F2
								 WHERE F2.FlightType = 'International')

	15. Identify the customer(s) who have booked tickets for all types of flights. Write a SQL query to display name of the 
	     identified customers. 

		 SELECT CustName
		 FROM tblCustomer C
		 WHERE NOT EXISTS ( SELECT DISTINCT FlightType
		                    FROM tblFlight F
							WHERE NOT EXISTS ( SELECT CustID
							                   FROM tblBooking B
											   WHERE C.CustID = B.CustID AND F.FlightID = B.FlightID))

	Note: The types of flight are not only the ones defined in the sample data. 





	
	
	
	
