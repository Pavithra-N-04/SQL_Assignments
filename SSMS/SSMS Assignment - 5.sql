
--> Assigment - 5(a)

	USE Payroll

--> Patient table:

	CREATE TABLE Patient(
	PatientID VARCHAR(5) PRIMARY KEY,
	PName VARCHAR(50),
	City VARCHAR(50)
	);

--> Doctor table:

	CREATE TABLE Doctor(
	DoctorID VARCHAR(5) PRIMARY KEY,
	DName VARCHAR(50),
	Dept VARCHAR(50),
	Salary DECIMAL(7, 1)
	);

--> Consultation table:

	CREATE TABLE Consultation(
	ConsultationID INT PRIMARY KEY,
	PatientID VARCHAR(5) FOREIGN KEY REFERENCES Patient (PatientID),
	DoctorID VARCHAR(5) FOREIGN KEY REFERENCES Doctor (DoctorID),
	Fee DECIMAL(5, 1)
	);

--> Inserting values to Patient table:

	INSERT INTO Patient VALUES ('P101', 'Kevin', 'New York');
	INSERT INTO Patient VALUES ('P102', 'Merlin', 'Boston');
	INSERT INTO Patient VALUES ('P103', 'Eliza', 'Chicago');
	INSERT INTO Patient VALUES ('P104', 'Robert', 'New York');
	INSERT INTO Patient VALUES ('P105', 'David', 'Chicago');

--> Inserting values to Doctor table:

	INSERT INTO Doctor VALUES ('D201', 'Jane', 'Cardiology', 150000);
	INSERT INTO Doctor VALUES ('D202', 'Maria', 'Nephrology', 110000);
	INSERT INTO Doctor VALUES ('D203', 'John', 'Cardiology', 160000);
	INSERT INTO Doctor VALUES ('D204', 'Jack', 'Neurology', 125000);

--> Inserting values to Consultation table:

	INSERT INTO Consultation VALUES (501, 'P101', 'D204', 500);
	INSERT INTO Consultation VALUES (502, 'P102', 'D201', 600);
	INSERT INTO Consultation VALUES (503, 'P103', 'D202', 450);
	INSERT INTO Consultation VALUES (504, 'P104', 'D203', 550);
	INSERT INTO Consultation VALUES (505, 'P105', 'D203', 550);
	INSERT INTO Consultation VALUES (506, 'P101', 'D202', 450);

	SELECT * FROM Patient
	SELECT * FROM Doctor
	SELECT * FROM Consultation

	UPDATE Consultation
	SET Fee = 900
	WHERE ConsultationID IN (504) 

--> Requirement 1 : 
--> Identify the consultation details of patients with the letter ‘e’ anywhere in their name, who have consulted a cardiologist. 
--   Write a SQL query to display doctor’s name and patient’s name for the identified consultation details.

	SELECT DName, PName
	FROM Consultation
	INNER JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
	INNER JOIN Patient ON Consultation.PatientID = Patient.PatientID
	WHERE PName LIKE '%E%' AND Dept = 'Cardiology';

--> Requirement 2 : 
--> Identify the doctors who have provided consultation to patients from the cities ‘Boston’ and ‘Chicago’. Write a SQL query to 
-- display department and number of patients as PATIENTS who consulted the identified doctor(s). 

	SELECT DName, Dept, COUNT(Patient.PatientID) AS 'Number of Patients'
	FROM Consultation
	INNER JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
	INNER JOIN Patient ON Consultation.PatientID = Patient.PatientID
	WHERE City IN ('Boston', 'Chicago')
	GROUP BY Dept, DName

--> Requirement 3 : 
--> Identify the cardiologist(s) who have provided consultation to more than one patient. 
--Write a SQL query to display doctor’s id and doctor’s name for the identified cardiologists.

	SELECT Doctor.DoctorID, COUNT(Patient.PatientID) 'Number of Patients', DName
	FROM Consultation
	INNER JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
	INNER JOIN Patient ON Consultation.PatientID = Patient.PatientID
	WHERE Dept = 'Cardiology'
	GROUP BY Doctor.DoctorID, DName
	HAVING COUNT(*) > 1

-->Requirement 4 : 
-->Write a SQL query to combine the results of the following two reports into a single report. 
--The query result should NOT contain duplicate records. 
--Report 1 – Display doctor’s id of all cardiologists who have been consulted by patients. 
--Report 2 – Display doctor’s id of all doctors whose total consultation fee charged in the portal is more than INR 800. 

	SELECT Doctor.DoctorID
	FROM Consultation
	INNER JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
	WHERE Dept = 'Cardiology'
	--GROUP BY Doctor.DoctorID

	UNION

	SELECT DoctorID
	FROM Consultation
	GROUP BY DoctorID
	HAVING SUM(Fee) > 800

	--OR

	SELECT Doctor.DoctorID
	FROM Consultation
	INNER JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
	WHERE Dept = 'Cardiology'
	GROUP BY Doctor.DoctorID
	HAVING SUM(Fee) > 800


-->Requirement 5 : 
--Write a SQL query to combine the results of the following two reports into a single report. 
--The query result should NOT contain duplicate records. 
--Report 1 – Display patient’s id belonging to ‘New York’ city who have consulted with the doctor(s) through the portal. 
--Report 2 – Display patient’s id who have consulted with doctors other than cardiologists and have paid a total 
--consultation fee less than INR 1000. 

	SELECT DISTINCT Patient.PatientID
	FROM Consultation
	INNER JOIN Patient ON Consultation.PatientID = Patient.PatientID
	WHERE City = 'New York'
	--GROUP BY Patient.PatientID

	UNION

	SELECT PatientID
	FROM Consultation
	INNER JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
	--INNER JOIN Patient ON Consultation.PatientID = Patient.PatientID
	WHERE Dept NOT IN ('Cardiology') 
	GROUP BY PatientID
	HAVING SUM(Fee) < 1000


--> Assignment - 5(b)

--> Customer table:

	CREATE TABLE Customers(
	CustID INT PRIMARY KEY,
	CustName VARCHAR(10) NOT NULL,
	CustType CHAR(1)
	);

--> Category table:

	CREATE TABLE Category(
	CID CHAR(4) PRIMARY KEY,
	CName VARCHAR(25) NOT NULL
	);

--> Toys table:

	CREATE TABLE Toys(
	ToyID CHAR(5) PRIMARY KEY,
	ToyName VARCHAR(25) UNIQUE NOT NULL,
	Price INT NOT NULL,
	Stock INT NOT NULL,
	CID CHAR(4) FOREIGN KEY REFERENCES Category (CID)
	);

--> Transactions table:

	CREATE TABLE Transactions(
	TxnID INT PRIMARY KEY,
	Quantity INT,
	TxnCost DECIMAL(5, 1),
	CustID INT FOREIGN KEY REFERENCES Customers(CustID) NOT NULL,
	ToyID CHAR(5) FOREIGN KEY REFERENCES Toys (ToyID) NOT NULL
	);

--> Inserting values to Customers table:

	INSERT INTO Customers VALUES(101, 'Tom', 'R');
	INSERT INTO Customers VALUES(102, 'Harry', NULL); 
	INSERT INTO Customers VALUES(103, 'Dick', 'P');
	INSERT INTO Customers VALUES(104, 'Joy', 'P');

--> Inserting values to Category table:

	INSERT INTO Category VALUES('C101', 'Vehicles');
	INSERT INTO Category VALUES('C102', 'Musical');
	INSERT INTO Category VALUES('C103', 'Dolls');
	INSERT INTO Category VALUES('C104', 'Craft');

--> Inserting values to Toys table:

	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1001', 'GT Racing Car', 'C101', 500, 40);
	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1002', 'Hummer Monster Car', 'C101', 600, 20);
	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1003', 'ThunderBot Car', 'C101', 700, 15);
	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1004', 'Ken Beat', 'C102', 150, 20);
	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1005', 'Drummer', 'C102', 200, 10);
	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1006', 'Kelly', 'C103', 150, 13);
	INSERT INTO Toys(ToyID, ToyName, CID, Price, Stock) VALUES('T1007', 'Barble', 'C103', 550, 40);

--> Inserting values to Transactions table:

	INSERT INTO Transactions VALUES(1000, 5, 2750, 103, 'T1006');
	INSERT INTO Transactions VALUES(1001, 2, 1200, 104, 'T1002');
	INSERT INTO Transactions VALUES(1002, 3, 600, 103, 'T1005');
	INSERT INTO Transactions VALUES(1003, 1, 500, 101, 'T1001');
	INSERT INTO Transactions VALUES(1004, 3, 450, 101, 'T1004');
	INSERT INTO Transactions VALUES(1005, 3, 2100, 103, 'T1003');
	INSERT INTO Transactions VALUES(1006, 4, 2400, 104, 'T1003');

	SELECT * FROM Customers	
	SELECT * FROM Category	
	SELECT * FROM Toys	
	SELECT * FROM Transactions

--> 1. Display CustName and total transaction cost as TotalPurchase for those customers whose total transaction cost is 
----greater than 1000.

	SELECT CustName, SUM(Transactions.TxnCost)
	FROM Customers
	INNER JOIN Transactions ON CustomerS.CustID = Transactions.CustID
	GROUP BY CustName
	HAVING SUM(Transactions.TxnCost) > 1000

--> 2. List all the toyid, total quantity purchased as 'total quantity' irrespective of the customer. 
-- Toys that have not been sold should also appear in the result with total units as 0 

	SELECT Toys.ToyID, ISNULL(SUM(Quantity), 0) AS 'Total Quantity'
	FROM Toys
	LEFT JOIN Transactions ON Toys.ToyID = Transactions.ToyID
	GROUP BY Toys.ToyID

--> 3. The CEO of Toys corner wants to know which toy has the highest total Quantity sold. 
----Display CName, ToyName, total Quantity sold of this toy. 

	SELECT DISTINCT TOP(1) EmployeeName, salary
	FROM tblEmployeeDtl
	WHERE Salary NOT IN (SELECT DISTINCT TOP(3) Salary
					FROM tblEmployeeDtl
					ORDER BY Salary desc)
	ORDER BY Salary desc

	SELECT * FROM tblEmployeeDtl


