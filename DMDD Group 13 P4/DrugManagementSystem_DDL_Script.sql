CREATE DATABASE DrugManagementSystem;
USE DrugManagementSystem;



DROP TABLE IF EXISTS User_Case_Assignment;
DROP TABLE IF EXISTS Follow_up;
DROP TABLE IF EXISTS Dose_Regimen;
DROP TABLE IF EXISTS Regulatory_Case_Reports;
DROP TABLE IF EXISTS Case_Report;
DROP TABLE IF EXISTS [Case];
DROP TABLE IF EXISTS Case_Reporter;
DROP TABLE IF EXISTS Drug;
DROP TABLE IF EXISTS Device;
DROP TABLE IF EXISTS Regulatory_Agency_Contact;
DROP TABLE IF EXISTS [User];
DROP TABLE IF EXISTS [Product];
DROP TABLE IF EXISTS Regulatory_Agency;
DROP TABLE IF EXISTS Patient;

 
CREATE TABLE Regulatory_Agency (
    AgencyID INT PRIMARY KEY IDENTITY(1001,1),
    AgencyName VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    RegulationCode VARCHAR(50) NOT NULL
);

 
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    PatientName VARCHAR(100) NOT NULL,
    MedicalHistory TEXT,
    Allergies VARCHAR(100),
    ContactNo VARCHAR(20)
);

CREATE TABLE Case_Reporter (
    ReporterID INT PRIMARY KEY IDENTITY(1,1),
    ReporterName VARCHAR(100) NOT NULL,
    ReporterRole VARCHAR(50),
    ContactNo VARCHAR(20),
    ReporterNotes TEXT
);

CREATE TABLE [Product] (
    ProductID INT PRIMARY KEY IDENTITY(501,1),
    ProductName VARCHAR(100) NOT NULL,
    ProductType VARCHAR(50) CHECK (ProductType IN ('Drug', 'Device')), -- CHECK constraint for product types
    ManufacturerName VARCHAR(100),
    ExpiryDate DATE CHECK (ExpiryDate > GETDATE()) -- CHECK constraint to ensure expiry date is in the future
);

CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName VARCHAR(100) NOT NULL,
    [Role] VARCHAR(50) CHECK ([Role] IN ('Case Manager', 'Associate', 'Quality Analyst')), -- CHECK constraint for user roles
    ContactNo VARCHAR(20)
);

CREATE TABLE [Case] (
    CaseID INT PRIMARY KEY IDENTITY(111,1),
    PatientID INT NOT NULL,
    ReporterID INT NOT NULL,
    CaseDescription TEXT,
    CaseDate DATE NOT NULL,
    [Status] VARCHAR(50) CHECK ([Status] IN ('Evaluation', 'Submitted for MR', 'MR In-Progress', 'Submitted for Quality Check', 'Quality Check In-Progress', 'Case Locked', 'Closed' )),
    Severity INT CHECK (Severity BETWEEN 1 AND 5),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (ReporterID) REFERENCES Case_Reporter(ReporterID)
);


CREATE TABLE Case_Report (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    ReportDate DATE NOT NULL,
    ReportStatus VARCHAR(50) CHECK (ReportStatus IN ('Draft', 'In-Review', 'Approved', 'Dispatched')),
    ReportType VARCHAR(50),
    FOREIGN KEY (CaseID) REFERENCES [Case](CaseID)
);


CREATE TABLE Regulatory_Case_Reports (
    TrackingNum INT PRIMARY KEY IDENTITY(101,1),
    AgencyID INT NOT NULL,
    ReportID INT NOT NULL,
    SubmissionDate DATE,
    ACKDate DATE,
    [Status] VARCHAR(50) CHECK ([Status] IN ('Pending', 'Sent', 'Success', 'Error' )),
    FOREIGN KEY (AgencyID) REFERENCES Regulatory_Agency(AgencyID),
    FOREIGN KEY (ReportID) REFERENCES Case_Report(ReportID)
);

 
CREATE TABLE Dose_Regimen (
    RegimenID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    ProductID INT NOT NULL,
    Dosage VARCHAR(15), 
    Frequency VARCHAR(50),
    FOREIGN KEY (CaseID) REFERENCES [Case](CaseID),
    FOREIGN KEY (ProductID) REFERENCES [Product](ProductID)
);


CREATE TABLE Follow_up (
    FollowupID INT PRIMARY KEY IDENTITY(101,1),
    CaseID INT NOT NULL,
    FollowupDate DATE,
    FollowupNotes TEXT,
    ReportedBy VARCHAR(50) 
        CHECK (ReportedBy IN ('Patient(self)', 'System Generated', 'Medical Staff Personnel', 'External Contact Person')),
    FOREIGN KEY (CaseID) REFERENCES [Case](CaseID)
);


CREATE TABLE User_Case_Assignment (
    AssignmentID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    CaseID INT NOT NULL,
    [Status] VARCHAR(50) CHECK ([Status] IN ('Assigned', 'In Progress', 'Completed')),
    StartDate DATE,
    CompleteDate DATE,
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (CaseID) REFERENCES [Case](CaseID)
);


CREATE TABLE Drug (
    ProductID INT PRIMARY KEY,
    DosageForm VARCHAR(50),
    Strength VARCHAR(50),
    RouteOfAdministration VARCHAR(50),
    FOREIGN KEY (ProductID) REFERENCES [Product](ProductID)
);


CREATE TABLE Device (
    ProductID INT PRIMARY KEY,
    [Classification] VARCHAR(50),
    Model VARCHAR(50),
    Manufacturer VARCHAR(50),
    FOREIGN KEY (ProductID) REFERENCES [Product](ProductID)
);

 
CREATE TABLE Regulatory_Agency_Contact (
    PersonID INT PRIMARY KEY IDENTITY(1,1),
    AgencyID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Position VARCHAR(50),
    FOREIGN KEY (AgencyID) REFERENCES Regulatory_Agency(AgencyID)
);
