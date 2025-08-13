/*
------------------------------------------
  Created by: Torian Knox
  Created on: 8/13/2025
  Description: Creating a database schema
------------------------------------------
*/

CREATE DATABASE GrantsDB;
GO

USE GrantsDB;
GO

CREATE TABLE Providers(
  ProviderID   INT IDENTITY PRIMARY KEY,
  Name         NVARCHAR(200) NOT NULL,
  LicenseNo    NVARCHAR(50) UNIQUE NOT NULL,
  Capacity     INT CHECK (Capacity >= 0),
  ZipCode      CHAR(5),
  IsActive     BIT NOT NULL DEFAULT 1,
  CreatedAt    DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE FundingSources(
  FundingID    INT IDENTITY PRIMARY KEY,
  Name         NVARCHAR(200) NOT NULL,
  FiscalYear   CHAR(9) NOT NULL, -- e.g. 2024-2025
  CapAmount    DECIMAL(14,2) CHECK (CapAmount >= 0)
);

CREATE TABLE Families(
  FamilyID     INT IDENTITY PRIMARY KEY,
  HouseholdSize INT CHECK (HouseholdSize > 0),
  IncomeBand    NVARCHAR(50),
  CreatedAt     DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE Children(
  ChildID      INT IDENTITY PRIMARY KEY,
  FamilyID     INT NOT NULL
    REFERENCES Families(FamilyID),
  FirstName    NVARCHAR(80) NOT NULL,
  LastName     NVARCHAR(80) NOT NULL,
  DOB          DATE NOT NULL
);

CREATE TABLE Applications(
  ApplicationID INT IDENTITY PRIMARY KEY,
  FamilyID      INT NOT NULL REFERENCES Families(FamilyID),
  ProviderID    INT NOT NULL REFERENCES Providers(ProviderID),
  Status        NVARCHAR(30) NOT NULL,  -- Submitted/Approved/Denied/Pending Docs
  SubmittedAt   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
  ApprovedAt    DATETIME2 NULL
);

CREATE TABLE Awards(
  AwardID      INT IDENTITY PRIMARY KEY,
  ApplicationID INT NOT NULL REFERENCES Applications(ApplicationID),
  FundingID     INT NOT NULL REFERENCES FundingSources(FundingID),
  StartDate     DATE NOT NULL,
  EndDate       DATE NOT NULL,
  MonthlyAmount DECIMAL(12,2) CHECK (MonthlyAmount >= 0)
);

CREATE TABLE Disbursements(
  DisbursementID INT IDENTITY PRIMARY KEY,
  AwardID        INT NOT NULL REFERENCES Awards(AwardID),
  PeriodMonth    DATE NOT NULL,   -- use first of month
  PaidAmount     DECIMAL(12,2) NOT NULL CHECK (PaidAmount >= 0),
  PaidAt         DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

-- Useful indexes
CREATE INDEX IX_Awards_Period ON Disbursements(PeriodMonth);
CREATE INDEX IX_Applications_Status ON Applications(Status);
CREATE INDEX IX_Providers_Zip ON Providers(ZipCode) INCLUDE (Capacity);

