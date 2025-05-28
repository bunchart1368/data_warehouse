IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'AdventureWorksDW')
BEGIN
    CREATE DATABASE AdventureWorksDW;
END;
GO

USE AdventureWorksDW;
GO

-- Shipment DDL
IF OBJECT_ID('dbo.Shipment_dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Shipment_dim (
        ShipmentKey INT IDENTITY(1,1) PRIMARY KEY,
        ShipMethodID INT NOT NULL,
        Name NVARCHAR(50),
        ShipBase MONEY,
        ShipRate MONEY,
        ModifiedDate DATETIME
    );
END;

--Product_dim

IF OBJECT_ID('dbo.Product_dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Product_dim (
        ProductKey INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        Name NVARCHAR(50),
        ProductNumber NVARCHAR(25),
        MakeFlag BIT,
        FinishedGoodsFlag BIT,
        Color NVARCHAR(15),
        SafetyStockLevel SMALLINT,
        ReorderPoint SMALLINT,
        StandardCost MONEY,
        ListPrice MONEY,
        Size NVARCHAR(5),
        SizeUnitMeasureCode NCHAR(3),
        WeightUnitMeasureCode NCHAR(3),
        Weight DECIMAL(8, 2),
        DaysToManufacture INT,
        Class NCHAR(2),
        Style NCHAR(2),
        ProductSubcategoryID INT,
        ProductModelID INT,
        SellStartDate DATETIME,
        SellEndDate DATETIME,
        ModifiedDate DATETIME
    );
END;

--Customer_dim
IF OBJECT_ID('dbo.Customer_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customer_Dim (
        CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
        CustomerID INT NOT NULL,
        PersonID INT,
        StoreID INT,
        Title NVARCHAR(8),
        FirstName NVARCHAR(50),
        MiddleName NVARCHAR(50),
        LastName NVARCHAR(50),
        PersonType NCHAR(2),
        CustomerAddressKey INT -- Reference to CustomerAddress outrigger dim
    );
END;

--CustomerAddress_Dim
IF OBJECT_ID('dbo.CustomerAddress_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CustomerAddress_Dim (
        CustomerAddressKey INT IDENTITY(1,1) PRIMARY KEY,
        CustomerID INT NOT NULL,
        AddressID INT,
        AddressLine1 NVARCHAR(60),
        AddressLine2 NVARCHAR(60),
        City NVARCHAR(30),
        StateProvinceID INT,
        PostalCode NVARCHAR(15),
        ModifiedDate DATETIME
    );
END;

--Employee_dim
IF OBJECT_ID('dbo.Employee_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Employee_Dim (
        EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
        BusinessEntityID INT,
        NationalIDNumber NVARCHAR(15),
        OrganizationLevel SMALLINT,
        Title NVARCHAR(8),
        FirstName NVARCHAR(50),
        MiddleName NVARCHAR(50),
        LastName NVARCHAR(50),
        JobTitle NVARCHAR(50),
        BirthDate DATE,
        MaritalStatus NCHAR(1),
        Gender NCHAR(1),
        HireDate DATE,
        TerminatedDate DATE, -- Newly added column
        SalariedFlag BIT,
        VacationHours SMALLINT,
        SickLeaveHours SMALLINT,
        CurrentFlag BIT
    );
END;

--Sales_Employee_dim (Mini-dim of Employee)
IF OBJECT_ID('dbo.Sales_Employee_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Sales_Employee_Dim (
        SalesEmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
        BusinessEntityID INT NOT NULL,
        NationalIDNumber NVARCHAR(15),
        OrganizationLevel SMALLINT,
        Title NVARCHAR(8),
        FirstName NVARCHAR(50),
        MiddleName NVARCHAR(50),
        LastName NVARCHAR(50),
        JobTitle NVARCHAR(50),
        BirthDate DATE,
        MaritalStatus NCHAR(1),
        Gender NCHAR(1),
        HireDate DATE,
        SalariedFlag BIT,
        VacationHours SMALLINT,
        SickLeaveHours SMALLINT,
        Bonus MONEY,
        CommissionPct SMALLMONEY,
        SalesYTD MONEY,
        SalesLastYear MONEY
    );
END;


--Vendor_Dim
IF OBJECT_ID('dbo.Vendor_dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Vendor_dim (
        VendorKey INT IDENTITY(1,1) PRIMARY KEY,
        BusinessEntityID INT NOT NULL,
        AccountNumber NVARCHAR(15),
        Name NVARCHAR(100),
        CreditRating TINYINT,
        PreferredVendorStatus BIT,
        ActiveFlag BIT,
        PurchasingWebServiceURL NVARCHAR(1024),
        ModifiedDate DATETIME
    );
END;


-- CreditCard_Dim
IF OBJECT_ID('dbo.CreditCard_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CreditCard_Dim (
        CreditCardKey INT IDENTITY(1,1) PRIMARY KEY,
        CreditCardID INT NOT NULL,
        CardType NVARCHAR(50),
        CardNumber NVARCHAR(50),
        ExpMonth TINYINT,
        ExpYear SMALLINT,
        ModifiedDate DATETIME
    );
END;

-- Address_dim
IF OBJECT_ID('dbo.Address_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Address_Dim (
        AddressKey INT IDENTITY(1,1) PRIMARY KEY,       -- Surrogate Key
        AddressID INT,                                  -- Business Key
        AddressLine1 NVARCHAR(60),
        AddressLine2 NVARCHAR(60),
        City NVARCHAR(30),
        StateProvinceID INT,
        StateProvinceCode NVARCHAR(3),
        CountryRegionCode NVARCHAR(3),
        IsOnlyStateProvinceFlag BIT,
        StateProvinceName NVARCHAR(50),
        TerritoryID INT,
        PostalCode NVARCHAR(15),
        SpatialLocation GEOGRAPHY,
        rowguid UNIQUEIDENTIFIER,
        StartDate DATETIME NOT NULL DEFAULT GETDATE(),  -- SCD2 start date
        EndDate DATETIME NOT NULL DEFAULT ('9999-12-31'), -- SCD2 end date
        IsCurrent BIT NOT NULL DEFAULT 1                 -- SCD2 current flag
    );
END;

-- Sales order fact
IF OBJECT_ID('dbo.FactSalesOrder', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FactSalesOrder (
        SalesOrderID INT NOT NULL,                          -- Unique order identifier (business key)
        OrderDateKey INT NOT NULL,                          -- FK to DateDim(theDateKey)
        DueDateKey INT NOT NULL,                            -- FK to DateDim(theDateKey)
        ShipDateKey INT,                                    -- FK to DateDim(theDateKey)
        CustomerKey INT,                                    -- FK to Customer_Dim
        SalesEmployeeKey INT,                               -- FK to Sales_Employee_Dim
        EmployeeKey INT,                                    -- FK to Employee_Dim
        ShipToCustomerAddressKey INT,                       -- FK to CustomerAddress_Dim
        ShipMethodKey INT,                                  -- FK to Shipment_Dim
        CreditCardKey INT,                                  -- FK to CreditCard_Dim
        CurrencyRateKey INT,                                -- FK to CurrencyRate_Dim
        StoreKey INT,                                       -- FK to Store_Dim
        SubTotal MONEY,                                     -- Order subtotal
        TaxAmt MONEY,                                       -- Tax amount
        Freight MONEY,                                      -- Shipping cost
        TotalDue MONEY,                                     -- Final amount due
        Total_discount MONEY,                               -- Total discount applied
        Total_price MONEY,                                  -- Total price before discount
        NetPrice MONEY,                                     -- Final net price
        Total_product_order INT                             -- Number of products ordered
    );
END;


-- CurrencyRate_Dim
IF OBJECT_ID('dbo.CurrencyRate_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CurrencyRate_Dim (
        CurrencyRateKey INT IDENTITY(1,1) PRIMARY KEY,
        CurrencyRateID INT,
        CurrencyRateDate DATE,
        FromCurrencyCode NCHAR(3),
        ToCurrencyCode NCHAR(3),
        AverageRate MONEY,
        EndOfDayRate MONEY,
        ModifiedDate DATETIME
    );
END;


-- Date_dim
IF OBJECT_ID('dbo.DateDim', 'U') IS NULL
BEGIN
    CREATE TABLE DateDim (
        theDateKey INT PRIMARY KEY,         -- Format: YYYYMMDD
        theDate DATE NOT NULL,
        Year INT NOT NULL,
        Month INT NOT NULL,
        DayOfWeek INT NOT NULL,             -- 1 = Sunday, 7 = Saturday
        IsWeekend BIT NOT NULL              -- 1 if Saturday or Sunday
    );
END;


-- Product_dim
IF OBJECT_ID('dbo.Product_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Product_Dim (
        ProductKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
        ProductID INT,                           -- Business/Natural Key
        Name NVARCHAR(50),
        ProductNumber NVARCHAR(25),
        MakeFlag BIT,
        FinishedGoodsFlag BIT,
        Color NVARCHAR(15),
        SafetyStockLevel SMALLINT,
        ReorderPoint SMALLINT,
        StandardCost MONEY,
        ListPrice MONEY,
        Size NVARCHAR(5),
        SizeUnitMeasureCode NCHAR(3),
        WeightUnitMeasureCode NCHAR(3),
        Weight DECIMAL(8, 2),
        DaysToManufacture INT,
        ProductLine NCHAR(2),
        Class NCHAR(2),
        Style NCHAR(2),
        ProductSubcategoryID INT,
        ProductModelID INT,
        SellStartDate DATE,
        SellEndDate DATE,
        DiscontinuedDate DATE,
        IsStillSell BIT,                         -- 1 = Still selling, 0 = Not selling
        rowguid UNIQUEIDENTIFIER,
        ModifiedDate DATETIME
    );
END;

-- Vendor_dim
IF OBJECT_ID('dbo.Vendor_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Vendor_Dim (
        VendorKey INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key
        BusinessEntityID INT NOT NULL,            -- Natural Key
        AccountNumber NVARCHAR(15),
        Name NVARCHAR(100),
        CreditRating TINYINT,
        PreferredVendorStatus BIT,
        ActiveFlag BIT,
        PurchasingWebServiceURL NVARCHAR(1024),
        ModifiedDate DATETIME
    );
END;

-- Product_purchase_fact
IF OBJECT_ID('dbo.ProductPurchaseFact', 'U') IS NULL
    BEGIN
        CREATE TABLE dbo.ProductPurchaseFact (
            PurchaseOrderID INT NOT NULL,                 -- FK to PurchaseOrderHeader
            PurchaseOrderDetailID INT NOT NULL,           -- PK or part of composite PK
            OrderDateKey INT NOT NULL,                    -- FK to DateDim(theDateKey)
            ShipDateKey INT,                              -- FK to DateDim(theDateKey)
            DueDateKey INT NOT NULL,                      -- FK to DateDim(theDateKey)
            EmployeeKey INT NOT NULL,                     -- FK to Employee_Dim
            VendorKey INT NOT NULL,                       -- FK to Vendor_Dim
            ShipMethodKey INT NOT NULL,                   -- FK to Shipment_Dim
            ProductKey INT NOT NULL,                      -- FK to Product_Dim
            OrderQty SMALLINT,
            UnitPrice MONEY,
            LineTotal MONEY,
            ReceivedQty DECIMAL(8, 2),
            RejectedQty DECIMAL(8, 2),
            StockedQty AS (ReceivedQty - RejectedQty) PERSISTED,  -- Optionally persisted
            SubTotal MONEY,
            TaxAmt MONEY,
            Freight MONEY,
            TotalDue MONEY
        );
    END;
    
IF OBJECT_ID('dbo.Store_Dim', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Store_Dim (
        StoreKey INT IDENTITY(1,1) PRIMARY KEY,          -- Surrogate key
        StoreID INT,                                     -- Business key
        StoreBusinessEntityID INT,                       -- Store's BusinessEntityID
        StoreName NVARCHAR(100),
        TerritoryID INT,
        SalesPersonID INT,
        StoreModifiedDate DATETIME,

        -- SCD2 metadata columns
        StartDate DATETIME NOT NULL DEFAULT GETDATE(),   -- SCD2 start date
        EndDate DATETIME NOT NULL DEFAULT ('9999-12-31'),-- SCD2 end date
        IsCurrent BIT NOT NULL DEFAULT 1                 -- Flag to mark current record
    );
END;
