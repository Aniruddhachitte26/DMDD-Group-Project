-- 1. Add 50 new Cases with diverse statuses, severities, and dates
DECLARE @i INT = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO [Case] (PatientID, ReporterID, CaseDescription, CaseDate, [Status], Severity)
    VALUES (
        (RAND() * 10) + 1, -- Random PatientID (1 to 10)
        (RAND() * 10) + 1, -- Random ReporterID (1 to 10)
        CONCAT('Generated case ', @i, ' description.'),
        DATEADD(DAY, -((RAND() * 365) + 1), GETDATE()), -- Random past dates
        CASE 
            WHEN @i % 6 = 0 THEN 'Evaluation'
            WHEN @i % 5 = 0 THEN 'MR In-Progress'
            WHEN @i % 4 = 0 THEN 'Closed'
            WHEN @i % 3 = 0 THEN 'Submitted for Quality Check'
            ELSE 'Case Locked'
        END,
        (RAND() * 5) + 1 -- Random severity (1 to 5)
    );
    SET @i = @i + 1;
END;

-- 2. Add 50 new Case_Reports with diverse statuses and types
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Case_Report (CaseID, ReportDate, ReportStatus, ReportType)
    VALUES (
        (SELECT MAX(CaseID) FROM [Case]) - @i + 1, -- Link to new cases
        DATEADD(DAY, -((RAND() * 300) + 1), GETDATE()), -- Random past dates
        CASE 
            WHEN @i % 4 = 0 THEN 'Draft'
            WHEN @i % 3 = 0 THEN 'In-Review'
            WHEN @i % 2 = 0 THEN 'Approved'
            ELSE 'Dispatched'
        END,
        CASE 
            WHEN @i % 2 = 0 THEN 'Follow-Up'
            ELSE 'Initial'
        END
    );
    SET @i = @i + 1;
END;

-- 3. Add 50 new Regulatory_Case_Reports with diverse statuses
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Regulatory_Case_Reports (AgencyID, ReportID, SubmissionDate, ACKDate, [Status])
    VALUES (
        ((RAND() * 10) + 1001), -- Random AgencyID (1001 to 1010)
        (SELECT MAX(ReportID) FROM Case_Report) - @i + 1, -- Link to new reports
        DATEADD(DAY, -((RAND() * 200) + 1), GETDATE()), -- Random submission date
        DATEADD(DAY, -((RAND() * 180) + 1), GETDATE()), -- Random ACK date
        CASE 
            WHEN @i % 5 = 0 THEN 'Pending'
            WHEN @i % 4 = 0 THEN 'Sent'
            WHEN @i % 3 = 0 THEN 'Success'
            ELSE 'Error'
        END
    );
    SET @i = @i + 1;
END;

-- 4. Add 50 new Follow_Ups with diverse reporters
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Follow_up (CaseID, FollowupDate, FollowupNotes, ReportedBy)
    VALUES (
        (SELECT MAX(CaseID) FROM [Case]) - @i + 1, -- Link to new cases
        DATEADD(DAY, -((RAND() * 150) + 1), GETDATE()), -- Random follow-up date
        CONCAT('Generated follow-up note ', @i, '.'),
        CASE 
            WHEN @i % 4 = 0 THEN 'Patient(self)'
            WHEN @i % 3 = 0 THEN 'Medical Staff Personnel'
            WHEN @i % 2 = 0 THEN 'External Contact Person'
            ELSE 'System Generated'
        END
    );
    SET @i = @i + 1;
END;

-- 5. Add 50 new Dose_Regimens with diverse products and frequencies
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO Dose_Regimen (CaseID, ProductID, Dosage, Frequency)
    VALUES (
        (SELECT MAX(CaseID) FROM [Case]) - @i + 1, -- Link to new cases
        (RAND() * 10) + 501, -- Random ProductID (501 to 510)
        CONCAT((RAND() * 1000), ' mg'), -- Random dosage
        CASE 
            WHEN @i % 3 = 0 THEN 'Once Daily'
            WHEN @i % 2 = 0 THEN 'Twice a Day'
            ELSE 'Every 8 Hours'
        END
    );
    SET @i = @i + 1;
END;

-- 6. Add 50 new Products with varying expiry dates
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO [Product] (ProductName, ProductType, ManufacturerName, ExpiryDate)
    VALUES (
        CONCAT('GeneratedProduct', @i),
        CASE 
            WHEN @i % 2 = 0 THEN 'Drug'
            ELSE 'Device'
        END,
        CONCAT('GeneratedManufacturer', @i),
        DATEADD(DAY, ((RAND() * 3650) + 30), GETDATE()) -- Expiry dates 30 days to 10 years from now
    );
    SET @i = @i + 1;
END;

-- Assign new cases to existing users in the User table
SET @i = 1;
WHILE @i <= 50
BEGIN
    INSERT INTO User_Case_Assignment (UserID, CaseID, [Status], StartDate, CompleteDate)
    VALUES (
        (RAND() * 10) + 1, -- Random UserID (1 to 10)
        (SELECT MAX(CaseID) FROM [Case]) - @i + 1, -- Assign to the most recent cases
        CASE 
            WHEN @i % 3 = 0 THEN 'Assigned'
            WHEN @i % 2 = 0 THEN 'In Progress'
            ELSE 'Completed'
        END,
        DATEADD(DAY, -((RAND() * 200) + 1), GETDATE()), -- Random start date
        CASE 
            WHEN @i % 3 = 0 THEN NULL -- No completion date for "Assigned"
            ELSE DATEADD(DAY, -((RAND() * 150) + 1), GETDATE()) -- Random complete date
        END
    );
    SET @i = @i + 1;
END;

