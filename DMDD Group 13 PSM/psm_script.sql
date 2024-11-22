-- PSM SCRIPT

-- 1. Stored Procedures
-- sp_GetCasesBySeverity
-- 1.Input: @Severity INT
-- 2.Output: List of cases matching the severity level.

IF OBJECT_ID('sp_GetCasesBySeverity', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetCasesBySeverity;
GO

CREATE PROCEDURE sp_GetCasesBySeverity @Severity INT
AS
BEGIN
    SELECT CaseID, CaseDescription, CaseDate, [Status]
    FROM [Case]
    WHERE Severity = @Severity;
END;
GO

--EXEC sp_GetCasesBySeverity @Severity = 3;



-- sp_AssignCaseToUser
-- 1.Inputs: @CaseID INT, @UserID INT, @Status VARCHAR(50)
-- 2.Output: Confirmation of case assignment.
IF OBJECT_ID('sp_AssignCaseToUser', 'P') IS NOT NULL
    DROP PROCEDURE sp_AssignCaseToUser;
GO

CREATE PROCEDURE sp_AssignCaseToUser @CaseID INT, @UserID INT, @Status VARCHAR(50) 
AS
BEGIN
    INSERT INTO User_Case_Assignment (CaseID, UserID, [Status], StartDate)
    VALUES (@CaseID, @UserID, @Status, GETDATE());
END;
GO

--EXEC sp_AssignCaseToUser @CaseID=111, @UserID=1, @Status='In Progress';

--select * from User_Case_Assignment


-- sp_GetCaseReportStatus
-- 1.Input: @CaseID INT
-- 2.Output: Case report statuses and dates.
IF OBJECT_ID('sp_GetCaseReportStatus', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetCaseReportStatus;
GO

CREATE PROCEDURE sp_GetCaseReportStatus @CaseID INT
AS
BEGIN
    SELECT CR.ReportID, CR.ReportStatus, CR.ReportDate
    FROM Case_Report CR
    WHERE CR.CaseID = @CaseID;
END;
GO

--EXEC sp_GetCaseReportStatus @CaseID = 111;




-- 2. Views


-- vw_ActiveCases
-- Reports all active cases.
IF OBJECT_ID('vw_ActiveCases', 'V') IS NOT NULL
    DROP VIEW vw_ActiveCases;
GO

CREATE VIEW vw_ActiveCases AS 
SELECT CaseID, CaseDescription, Severity, [Status] FROM [Case] 
WHERE [Status] NOT IN ('Closed', 'Case Locked');
GO

--select * from vw_ActiveCases;




-- vw_RegulatoryReports
-- Shows the status of reports submitted to regulatory agencies.
IF OBJECT_ID('vw_RegulatoryReports', 'V') IS NOT NULL
    DROP VIEW vw_RegulatoryReports;
GO

CREATE VIEW vw_RegulatoryReports AS 
SELECT RA.AgencyName, RCCR.TrackingNum, RCCR.[Status], RCCR.SubmissionDate 
FROM Regulatory_Case_Reports RCCR JOIN Regulatory_Agency RA ON RCCR.AgencyID = RA.AgencyID;
GO

--select * from vw_RegulatoryReports;



-- vw_PatientOverview
-- Provides a detailed summary of patients and their cases.
IF OBJECT_ID('vw_PatientOverview', 'V') IS NOT NULL
    DROP VIEW vw_PatientOverview;
GO

CREATE VIEW vw_PatientOverview AS
SELECT P.PatientName, P.MedicalHistory, C.CaseDescription, C.CaseDate, C.Severity 
FROM Patient P JOIN [Case] C ON P.PatientID = C.PatientID;
GO

--select * from vw_PatientOverview




-- vw_ProductDosage
-- View to show products and their dosage regimens
IF OBJECT_ID('vw_ProductDosage', 'V') IS NOT NULL
    DROP VIEW vw_ProductDosage;
GO

CREATE VIEW vw_ProductDosage AS
SELECT p.ProductName, dr.Dosage, dr.Frequency 
FROM Dose_Regimen dr JOIN [Product] p ON dr.ProductID = p.ProductID;
GO

--select * from vw_ProductDosage




--CaseFollowupSummary 
--provides insights into cases, their current status, the patient involved, the most recent follow-up date, and the total number of follow-ups.
IF OBJECT_ID('CaseFollowupSummary', 'V') IS NOT NULL
    DROP VIEW CaseFollowupSummary;
GO

CREATE VIEW CaseFollowupSummary AS
SELECT 
    c.CaseID,
    p.PatientName,
    CAST(c.CaseDescription AS NVARCHAR(MAX)) AS CaseDescription, 
    c.[Status] AS CaseStatus,
    MAX(f.FollowupDate) AS LastFollowupDate,
    COUNT(f.FollowupID) AS TotalFollowups
FROM [Case] c
INNER JOIN Patient p ON c.PatientID = p.PatientID
LEFT JOIN Follow_up f ON c.CaseID = f.CaseID
GROUP BY c.CaseID, p.PatientName, CAST(c.CaseDescription AS NVARCHAR(MAX)), c.[Status];
GO
--select * from CaseFollowupSummary;





-- 3. User-Defined Functions


-- uf_IsReportApproved
-- Checks if a report is approved.
IF OBJECT_ID('dbo.uf_IsReportApproved', 'FN') IS NOT NULL
    DROP FUNCTION dbo.uf_IsReportApproved;
GO

CREATE FUNCTION dbo.uf_IsReportApproved (@ReportID INT) RETURNS BIT
AS 
BEGIN
    RETURN (SELECT CASE WHEN ReportStatus = 'Approved' THEN 1 ELSE 0 END FROM Case_Report WHERE ReportID = @ReportID);
END;
GO
--SELECT dbo.uf_IsReportApproved(6) AS IsApproved; 

--SELECT dbo.uf_IsReportApproved(1) AS IsApproved; 



-- UDF to calculate the number of cases by severity 
IF OBJECT_ID('dbo.fn_CalculateCasesBySeverity', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_CalculateCasesBySeverity;
GO

CREATE FUNCTION dbo.fn_CalculateCasesBySeverity (@Severity INT) 
RETURNS INT
AS
BEGIN
    DECLARE @CaseCount INT;
    SELECT @CaseCount = COUNT(*) 
    FROM [Case] 
    WHERE Severity = @Severity; 
    RETURN @CaseCount;
END;
GO

--SELECT dbo.fn_CalculateCasesBySeverity(2) AS CaseCount; 



-- UDF to get the full name of a regulatory agency
IF OBJECT_ID('dbo.fn_GetRegulatoryAgencyName', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetRegulatoryAgencyName;
GO

CREATE FUNCTION dbo.fn_GetRegulatoryAgencyName (@AgencyID INT) RETURNS VARCHAR(100)
AS
BEGIN 
    DECLARE @AgencyName VARCHAR(100);
    SELECT @AgencyName = AgencyName FROM Regulatory_Agency WHERE AgencyID = @AgencyID; 
    RETURN @AgencyName; 
END;
GO
--SELECT dbo.fn_GetRegulatoryAgencyName(1002) AS AgencyName;  





-- 4. Triggers


--Trigger 1- to log changes in the status column of Case table

--Audit table to log changes in the status column of Case table
DROP TABLE IF EXISTS CaseStatusAudit
CREATE TABLE CaseStatusAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    CaseID INT,
    OldStatus VARCHAR(50),
    NewStatus VARCHAR(50),
    ChangedOn DATETIME DEFAULT GETDATE()
);

--Creating the Trigger
IF OBJECT_ID('LogCaseStatusChange', 'TR') IS NOT NULL
    DROP TRIGGER LogCaseStatusChange;
GO

CREATE TRIGGER LogCaseStatusChange
ON [Case]
AFTER UPDATE
AS
BEGIN
    INSERT INTO CaseStatusAudit (CaseID, OldStatus, NewStatus)
    SELECT i.CaseID, d.[Status], i.[Status]
    FROM Inserted i
    INNER JOIN Deleted d ON i.CaseID = d.CaseID
    WHERE i.[Status] <> d.[Status];
END;
GO
--Verify the working of the above trigger:
--select * from [Case]

--updating Status column of CaseId 119 to MR in-Progress (currently status is submitted for MR, can be verified from above select query) from Case table to verify the trigger
--UPDATE [Case]
--SET [Status] = 'MR In-Progress'
--WHERE CaseID = 119;

--select * from CaseStatusAudit;



--Trigger 2- to log deleted cases from case table
--Audit table to log deleted cases
DROP TABLE IF EXISTS DeletedCasesAudit
CREATE TABLE DeletedCasesAudit (
    CaseID INT,
    PatientID INT,
    ReporterID INT,
    CaseDescription TEXT,
    CaseDate DATE,
    [Status] VARCHAR(50),
    Severity INT,
    DeletedOn DATETIME DEFAULT GETDATE()
);

--Creating the trigger to log deleted cases
IF OBJECT_ID('LogDeletedCases', 'TR') IS NOT NULL
    DROP TRIGGER LogDeletedCases;
GO

CREATE TRIGGER LogDeletedCases
ON [Case]
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedCasesAudit (CaseID, PatientID, ReporterID, CaseDescription, CaseDate, [Status], Severity, DeletedOn)
    SELECT 
        CaseID, 
        PatientID, 
        ReporterID, 
        'N/A Case has been Deleted',
        CaseDate, 
        [Status], 
        Severity, 
        GETDATE() AS DeletedOn
    FROM Deleted;
END;
GO
--Verify the working of the above trigger:
--select * from [Case]
--Delete from [Case] where CaseID= <select any one case ID from above select query>


--Trigger 3- to change the value of status column of Case table upon getting a follow-up for an existing case
IF OBJECT_ID('UpdateCaseStatusOnFollowup', 'TR') IS NOT NULL
    DROP TRIGGER UpdateCaseStatusOnFollowup;
GO

CREATE TRIGGER UpdateCaseStatusOnFollowup
ON Follow_up
AFTER INSERT
AS
BEGIN
    UPDATE [Case]
    SET [Status] = 'Evaluation'
    FROM [Case]
    INNER JOIN Inserted i ON [Case].CaseID = i.CaseID;
END;
GO
--Verify the working of the above trigger:
--Insert into Follow_up (CaseID, FollowupDate, FollowupNotes, ReportedBy)
--Values (119, GETDATE(), 'Followup to check the case status change trigger', 'System Generated');