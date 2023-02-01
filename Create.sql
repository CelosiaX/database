DROP DATABASE LADtop
GO
CREATE DATABASE LADtop
GO
USE LADtop
GO

CREATE TABLE Staff(
	[ID] CHAR(5) NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	[Gender] VARCHAR(255) NOT NULL,
	[Email] VARCHAR(255) NOT NULL,
	[Phone_Number] VARCHAR(255) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	[Salary] INT NOT NULL,
	CONSTRAINT Staff_pk PRIMARY KEY(ID),
	CONSTRAINT staffID_Check CHECK(ID LIKE 'ST[0-9][0-9][0-9]'),
	CONSTRAINT staffGender_Check CHECK(Gender IN('Male','Female')),
	CONSTRAINT staffEmail_Check CHECK(Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
	CONSTRAINT staffSalary_Check CHECK(Salary BETWEEN 5000000 AND 10000000)
)

CREATE TABLE Customer(
	[ID] CHAR(5) NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	[Gender] VARCHAR(255) NOT NULL,
	[Email] VARCHAR(255) NOT NULL,
	[Phone_Number] VARCHAR(255) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	CONSTRAINT Customer_pk PRIMARY KEY(ID),
	CONSTRAINT nameLength_Check CHECK(LEN(Name) > 2),
	CONSTRAINT customerID_Check CHECK(ID LIKE 'CU[0-9][0-9][0-9]'),
	CONSTRAINT customerGender_Check CHECK(Gender IN('Male','Female')),
	CONSTRAINT customerEmail_Check CHECK(Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
)

CREATE TABLE Vendor(
	[ID] CHAR(5) NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	[Email] VARCHAR(255) NOT NULL,
	[Phone_Number] VARCHAR(255) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	CONSTRAINT Vendor_pk PRIMARY KEY(ID),
	CONSTRAINT vendorID_Check CHECK(ID LIKE 'VE[0-9][0-9][0-9]'),
	CONSTRAINT vendorEmail_Check CHECK(Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
)

CREATE TABLE LaptopBrand(
	[ID] CHAR(5) NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT LaptopBrand_pk PRIMARY KEY(ID),
	CONSTRAINT laptopBrandID_Check CHECK(ID LIKE 'LB[0-9][0-9][0-9]'),
)

CREATE TABLE Laptop(
	[ID] CHAR(5) NOT NULL,
	[LaptopBrandID] CHAR(5) NOT NULL,
	[Name] VARCHAR(255) NOT NULL,
	[Price] INT NOT NULL,
	CONSTRAINT Laptop_pk PRIMARY KEY(ID),
	CONSTRAINT LaptopBrand_fk FOREIGN KEY(LaptopBrandID) 
		REFERENCES LaptopBrand(ID),
	CONSTRAINT LaptopID_Check CHECK(ID LIKE 'LA[0-9][0-9][0-9]'),
	CONSTRAINT LaptopPrice_Check CHECK(Price > 5000000)
)

CREATE TABLE LaptopPurchase(
	[ID] CHAR(5) NOT NULL,
	[StaffID] CHAR(5) NOT NULL,
	[VendorID] CHAR(5) NOT NULL,
	[PurchaseDate] DATE NOT NULL,
	CONSTRAINT LaptopPurchase_pk PRIMARY KEY(ID),
	CONSTRAINT PuStaffID_fk FOREIGN KEY (StaffID) REFERENCES Staff(ID),
	CONSTRAINT PuVendorID_fk FOREIGN KEY (VendorID) REFERENCES Vendor(ID),
	CONSTRAINT LaptopPurchaseID_Check CHECK(ID LIKE 'PU[0-9][0-9][0-9]'),
	CONSTRAINT PurchaseDate_Check CHECK(DATEDIFF(DAY, PurchaseDate, GETDATE()) >= 0)
)

CREATE TABLE PurchaseDetail(
	[PurchaseID] CHAR(5) NOT NULL,
	[LaptopID] CHAR(5) NOT NULL,
	[Qty] INT NOT NULL,
	CONSTRAINT PDPurchaseID_fk FOREIGN KEY (PurchaseID) REFERENCES LaptopPurchase(ID),
	CONSTRAINT PDLaptop_fk FOREIGN KEY (LaptopID) REFERENCES Laptop(ID),
)

CREATE TABLE CustomerTransaction(
	[ID] CHAR(5) NOT NULL,
	[StaffID] CHAR(5) NOT NULL,
	[CustomerID] CHAR(5) NOT NULL,
	[TransactionDate] DATE NOT NULL,
	CONSTRAINT CustomerTransaction_pk PRIMARY KEY(ID),
	CONSTRAINT TraStaffID_fk FOREIGN KEY (StaffID) REFERENCES Staff(ID),
	CONSTRAINT TraCustomerID_fk FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
	CONSTRAINT LaptopTranactionID_Check CHECK(ID LIKE 'TR[0-9][0-9][0-9]'),
	CONSTRAINT TransactionDate_Check CHECK(DATEDIFF(DAY, TransactionDate, GETDATE()) >= 0)
)
CREATE TABLE TransactionDetail(
	[TransactionID] CHAR(5) NOT NULL,
	[LaptopID] CHAR(5) NOT NULL,
	[Qty] INT NOT NULL,
	CONSTRAINT TDTransactionID_fk FOREIGN KEY (TransactionID) REFERENCES CustomerTransaction(ID),
	CONSTRAINT TDLaptop_fk FOREIGN KEY (LaptopID) REFERENCES Laptop(ID),
)











