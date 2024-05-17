Use Hotel;

SELECT * -- показує всі бронювання на певну дату
FROM Reservation
WHERE CheckInDate = '2024-02-13' OR CheckOutDate = '2024-02-14';

SELECT r.RoomType, SUM(res.TotalAmount) AS TotalRevenue -- знаходить дохід від кімнат за певний діапазон від різних типів кімнат
FROM Room r
INNER JOIN Reservation res ON r.RoomNumber = res.RoomNumber
WHERE res.CheckInDate BETWEEN '2024-02-01' AND '2024-03-15'
GROUP BY r.RoomType;

SELECT SUM(res.TotalAmount) AS TotalRevenue -- знаходить дохід від кімнат в цілому за певний діапазон 
FROM Room r
INNER JOIN Reservation res ON r.RoomNumber = res.RoomNumber
WHERE res.CheckInDate BETWEEN '2024-02-01' AND '2024-03-15';

SELECT s.ServiceName, SUM(sb.TotalAmount) AS TotalRevenue -- дохід за певний інтервал від сервісів по групах
FROM Service s
INNER JOIN ServiceBooking sb ON s.ServiceID = sb.ServiceID
WHERE sb.BookingID IN (
  SELECT BookingID
  FROM Reservation res
  WHERE res.CheckInDate BETWEEN '2024-02-01' AND '2024-03-15'
)
GROUP BY s.ServiceName;

SELECT SUM(sb.TotalAmount) AS TotalServiceRevenue -- дохід від сервісів за певний інтервал в загальному
FROM Service s
INNER JOIN ServiceBooking sb ON s.ServiceID = sb.ServiceID
WHERE sb.BookingID IN (
  SELECT BookingID
  FROM Reservation res
  WHERE res.CheckInDate BETWEEN '2024-02-01' AND '2024-03-15'
);

SELECT -- показує прибуток за певну дату в цілому
  SUM(res.TotalAmount) AS TotalReservationRevenue,
  SUM(sb.TotalAmount) AS TotalServiceRevenue
FROM Reservation res
LEFT JOIN ServiceBooking sb ON res.ReservationID = sb.BookingID
WHERE res.CheckInDate BETWEEN '2024-02-01' AND '2024-03-15';

SELECT -- можна подивитися всі сервіси, які забронював певний гість
  s.ServiceName, 
  SUM(sb.TotalAmount) AS TotalSpent
FROM Guest g
INNER JOIN ServiceBooking sb ON g.GuestID = sb.GuestID
INNER JOIN Service s ON sb.ServiceID = s.ServiceID
WHERE g.GuestID = 35  -- Filter by GuestID
GROUP BY s.ServiceName
ORDER BY s.ServiceName;

SELECT -- показує, які людина взяла сервіси та їх вартість для неї
  s.ServiceName, 
  SUM(sb.TotalAmount) AS TotalSpent
FROM Guest g
INNER JOIN ServiceBooking sb ON g.GuestID = sb.GuestID
INNER JOIN Service s ON sb.ServiceID = s.ServiceID
WHERE g.Name = 'Ірина Іванова' 
GROUP BY s.ServiceName
ORDER BY s.ServiceName;

( -- показує суму за кімнату + сервіс для певної людини
SELECT 
    SUM(r.TotalAmount) AS TotalAmount
  FROM Reservation r
  INNER JOIN Guest g ON r.GuestID = g.GuestID
  WHERE g.Name = 'Ірина Іванова'
)
UNION ALL
(
  SELECT 
    SUM(sb.TotalAmount) AS TotalAmount
  FROM Guest g
  INNER JOIN ServiceBooking sb ON g.GuestID = sb.GuestID
  INNER JOIN Service s ON sb.ServiceID = s.ServiceID
  WHERE g.Name = 'Ірина Іванова'
);

SELECT  -- показує статус оплати клієнта кирилицею
  g.Name AS GuestName,
  g.Email,
  r.RoomType,
  r.Price,
  rv.CheckInDate,
  rv.CheckOutDate,
  rv.TotalAmount,
  CASE WHEN rv.PaymentStatus = 'Paid' THEN 'Оплачено'
       WHEN rv.PaymentStatus = 'Pending' THEN 'Awaiting Payment'
       ELSE 'Cancelled'
  END AS PaymentStatus
FROM Guest g
INNER JOIN Reservation rv ON g.GuestID = rv.GuestID
INNER JOIN Room r ON rv.RoomNumber = r.RoomNumber
WHERE rv.ReservationID = 'RS1';  

SELECT Room.RoomNumber, Room.RoomType, Room.Capacity, Room.Price -- показує всі вільні кімнати на певний діапазон дат
FROM Room
LEFT JOIN Reservation
ON Room.RoomNumber = Reservation.RoomNumber
  AND Reservation.RoomStatus = 'Occupied'  
  AND Reservation.CheckInDate BETWEEN '2024-02-13' AND '2024-02-18' 
WHERE Reservation.RoomNumber IS NULL;

SELECT r.RoomType, SUM(rv.TotalAmount) AS TotalRevenue -- показує кімнати за доходом в порядку спадання
FROM Room r
INNER JOIN Reservation rv ON r.RoomNumber = rv.RoomNumber
GROUP BY r.RoomType
ORDER BY TotalRevenue DESC
LIMIT 5;

SELECT s.ServiceName, SUM(sb.Quantity) AS TotalBookings -- визначає найпопулярніший сервіс за к-стю бронювань
FROM Service s
INNER JOIN ServiceBooking sb ON s.ServiceID = sb.ServiceID
GROUP BY s.ServiceName
ORDER BY TotalBookings DESC
LIMIT 5;

SELECT e.Name, COUNT(*) AS ReservationCount -- показує скільки бронювань опрацював кожен адміністратор
FROM Employee e
INNER JOIN Reservation rv ON e.EmployeeID = rv.EmployeeID
GROUP BY e.Name
ORDER BY ReservationCount DESC;

SELECT  -- показує середню тривалість проживання за типом кімнати в порядку спадання
    Room.RoomType, AVG(DATEDIFF(Reservation.CheckOutDate, Reservation.CheckInDate)) AS AvgStayDuration
FROM 
    Reservation
JOIN 
    Room ON Reservation.RoomNumber = Room.RoomNumber
GROUP BY 
    Room.RoomType;





























