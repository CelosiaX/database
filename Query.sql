USE LADtop
GO

--1
SELECT [Customer Name] = CONCAT('Mr. ',c.Name),
	[Customer Gender] = c.Gender, [Total Transaction] = COUNT(ct.ID)
FROM Customer c JOIN CustomerTransaction ct
	ON c.ID = ct.CustomerID
WHERE c.Gender = 'Male'
GROUP BY c.ID, c.Name,c.Gender 

-- CONCAT = To add MR on customer name
-- COUNT = To find number of transactions done by each customer

--2
SELECT [LaptopId] = l.ID, [LaptopName] = l.Name, [LaptopBrandName] = lb.Name
, [LaptopPrice] = l.Price, [Total Sold] = SUM(td.Qty)
FROM Laptop l JOIN LaptopBrand lb
	ON l.LaptopBrandID = lb.ID JOIN TransactionDetail td
	ON l.ID = td.LaptopID 
WHERE l.Price > 10000000 AND (CONVERT(INT, RIGHT(l.ID,3)) % 2) = 0
GROUP BY l.ID, l.Name, lb.Name, l.Price

-- SUM = to count number of laptops sold
-- RIGHT =  to get numbers from ID 
-- CONVERT = To change laptopID from varchar to INT 


--3
SELECT [StaffID] = REPLACE(s.ID, 'ST', 'Staff'), [StaffName] = s.Name, [Total Transactions Handled] = COUNT(ct.ID), [Maximum Quantity] = MAX(td.Qty)
FROM Staff s JOIN CustomerTransaction ct
	ON s.ID = ct.StaffID JOIN TransactionDetail td
	ON ct.ID = td.TransactionID
WHERE DATEPART(MONTH, ct.TransactionDate) = 4 AND s.Gender = 'Female'
GROUP BY s.ID, s.Name
HAVING  COUNT(ct.ID) > 2

-- REPLACE = to swap ST to Staff
-- COUNT = to find number of transactions handled
-- MAX = to find max laptop sold by staff
-- DATEPART = to get month of transaction date

--4
SELECT [CustomerName] = c.Name, [Customer Email] = c.Email, [Total Pruchase] = concat(COUNT(ct.ID), ' Purchase(s)'), [Total Laptop Bought] = SUM(td.Qty)
FROM Customer c JOIN CustomerTransaction ct
	ON C.ID = ct.CustomerID JOIN TransactionDetail td 
	ON ct.ID = td.TransactionID
WHERE c.Email LIKE '%@gmail.com'
GROUP BY c.ID, c.Name, c.Email
HAVING  SUM(td.Qty) > 2

-- COUNT = To find how many purchases done on CustomerTransaction table
-- CONCAT = to add 'purchase(s)' to total purchase result

-- 5 PT test INSERT
--BEGIN TRAN
--COMMIT
--ROLLBACK
--SELECT * FROM VENDOR
--INSERT INTO Vendor VALUES ('VE011', 'PT.VeT', 'Bol@gmail.com','000', 'yolo road')
--INSERT INTO laptopPurchase VALUES ('PU016','ST003','VE011','2022-02-25')
--INSERT INTO PurchaseDetail VALUES 
--('PU016','LA002','15')

--5
SELECT [VendorName] = REPLACE(v.Name, 'PT', 'Perseroan Terbatas'), [PurchaseDate] = lp.PurchaseDate, [Laptop ID Number] = RIGHT(pd.LaptopID, 3), [Quantity] = pd.Qty
FROM Vendor v JOIN LaptopPurchase lp
	ON v.ID = lp.VendorID JOIN PurchaseDetail pd
	ON lp.ID = pd.PurchaseID, 
	(SELECT [Avg] = AVG(pd.qty)  FROM PurchaseDetail pd) AS SQ
WHERE v.Name LIKE '%e%'AND pd.qty > SQ.Avg  -- SUBQUERY
GROUP BY v.ID, v.Name, lp.PurchaseDate, pd.LaptopID, pd.Qty

-- Replace = to replace PT with perseroan terbatas
-- Group by makes AVG not account for all the average so used SELECT in WHERE condition to get actual average

--6
SELECT [Name] = UPPER(lb.Name)+ ' ' + l.Name, [Price] = CONCAT('Rp.', l.Price)
FROM Laptop l JOIN LaptopBrand lb
	ON l.LaptopBrandID = lb.ID, 
	(SELECT [Avg] = AVG(l.Price) FROM Laptop l) AS SQ
WHERE l.Name LIKE '%e%' AND l.Price > SQ.Avg -- subquery 

--UPPER = turns a string of char into all uppercase\

--7
SELECT [Laptop ID Number] = RIGHT(l.ID, 3), [Brand] = UPPER(lb.Name), [Price] = CONCAT('Rp.', l.Price), [Total Laptop Sold] = sum(td.Qty) 
FROM Laptop l JOIN LaptopBrand lb
	ON l.LaptopBrandID = lb.ID JOIN TransactionDetail td
	ON td.LaptopID = l.ID, 
	(SELECT [AVG] = AVG(td.Qty) FROM TransactionDetail td) AS SQ
WHERE l.Price > 15000000
GROUP BY l.ID, lb.Name, l.Price, SQ.AVG
HAVING sum(td.Qty) >  SQ.AVG

--8
SELECT [Staff First Name] = LEFT(s.Name, CHARINDEX(' ', s.Name) - 1), [Staff Last Name] = RIGHT(s.Name, CHARINDEX(' ', REVERSE(s.Name)) - 1), [Total Laptop Sold] = SUM(td.Qty)
FROM Staff s JOIN CustomerTransaction ct
	ON s.ID = ct.StaffID JOIN TransactionDetail td
	ON ct.ID = td.TransactionID,
	(SELECT [AVG] = AVG(td.Qty) FROM TransactionDetail td) AS SQ
WHERE (LEN(s.Name) - LEN(REPLACE(s.Name,' ',''))) = 1
GROUP BY s.ID, s.Name, SQ.AVG
HAVING SUM(td.Qty) > SQ.AVG


--CHARINDEX(' ', s.Name) = to find position of first space
--CHARINDEX(' ', REVERSE(s.Name)) = to find position of last space(last name)
--A = SELECT (LEN(s.Name)) FROM staff s = length of original text  
--B = SELECT LEN(REPLACE(s.Name,' ','')) FROM staff s = length of text without space
-- A-B = Total space in name

--9 
CREATE VIEW [Vendor_Minimum_Transaction_View] AS
SELECT [Vendor ID] = REPLACE(v.ID, 'VE', 'Vendor '), [VendorName] = v.Name, [Total Transaction Handled] = count(lp.ID), [Minimum Purchases in One Transaction] = MIN(pd.Qty)
FROM Vendor v JOIN LaptopPurchase lp
	ON v.ID = lp.VendorID JOIN PurchaseDetail pd
	ON lp.ID = pd.PurchaseID 
WHERE DATEPART(MONTH, lp.PurchaseDate) = 5
GROUP BY v.ID, v.Name

--MIN = to find minimum of qty

--10
Create view [Staff_Max_Laptop_Purchased_View] AS
SELECT [StaffName] = s.Name, [StaffEmail] = UPPER(s.Email), [Total Purchase] = SUM(pd.Qty), 
[Maximum of Laptop That Has Been Purchased in One Purchase] = MAX(PD.Qty) 
FROM Staff s JOIN LaptopPurchase lp 
ON s.ID = lp.StaffID JOIN PurchaseDetail pd 
ON lp.ID = pd.PurchaseID
WHERE s.Email LIKE '%@gmail.com'
GROUP BY s.Name, s.Email








