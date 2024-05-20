CREATE DATABASE Hotel;
USE Hotel;
-- Table for storing information about guests
CREATE TABLE Guest (
  GuestID INT PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(20),
  Address VARCHAR(255)
);
-- Table for storing information about rooms
CREATE TABLE Room (
  RoomNumber INT PRIMARY KEY,
  RoomType VARCHAR(50),
  Capacity INT,
  Price DECIMAL(10, 2)
);
-- Table for storing reservations
CREATE TABLE Reservation (
  ReservationID VARCHAR(20) PRIMARY KEY,
  GuestID INT,
  RoomNumber INT,
  CheckInDate DATE,
  CheckOutDate DATE,
  TotalAmount DECIMAL(10, 2),
  AdditionalGuests INT,
  Roomstatus ENUM ('Available', 'Occupied', 'Under Maintenance'),
  Paymentstatus ENUM ('Paid', 'Pending', 'Cancelled'),
  EmployeeID VARCHAR(20), -- Add the EmployeeID column
  FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),
  FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) -- Add the foreign key constraint
);
ALTER TABLE Reservation
ADD CONSTRAINT fk_employee_reservation FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);
-- Table for storing services offered by the hotel
CREATE TABLE Service (
  ServiceID VARCHAR(20) PRIMARY KEY,
  ServiceName VARCHAR(100),
  Description TEXT,
  Price DECIMAL(10, 2)
);
ALTER TABLE Service
ADD COLUMN EmployeeID VARCHAR(20),
ADD CONSTRAINT fk_employee
FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);

-- Table for storing information about service bookings
CREATE TABLE ServiceBooking (
  BookingID VARCHAR(20) PRIMARY KEY,
  GuestID INT,
  ServiceID VARCHAR(20),
  ReservationID VARCHAR(20), 
  Quantity INT,
  TotalAmount DECIMAL(10, 2),
  FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
  FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)
);

CREATE TABLE Employee (
  EmployeeID VARCHAR(20) PRIMARY KEY,
  Name VARCHAR(100),
  Email VARCHAR(100),
  Phone VARCHAR(20),
  Address VARCHAR(255),
  Position VARCHAR(50),
  Salary DECIMAL(10, 2)
);



























