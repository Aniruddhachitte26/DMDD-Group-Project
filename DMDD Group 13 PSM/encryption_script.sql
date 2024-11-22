--Altering datatype of all columns from varchar(x) to VARCHAR(MAX) so that the length of the column is sufficient to store encrypted data 
ALTER TABLE Dose_Regimen
ALTER COLUMN Dosage VARCHAR(MAX);
ALTER TABLE Dose_Regimen
ALTER COLUMN Frequency VARCHAR(MAX);

ALTER TABLE Case_Reporter
ALTER COLUMN ReporterName VARCHAR(MAX);
ALTER TABLE Case_Reporter
ALTER COLUMN ReporterRole VARCHAR(MAX);
ALTER TABLE Case_Reporter
ALTER COLUMN ContactNo VARCHAR(MAX);
ALTER TABLE Case_Reporter
ALTER COLUMN ReporterNotes VARCHAR(MAX);

--Altering datatype of medical history column from Case table to VARCHAR(MAX) because EncryptByKey function in SQL Server does not support the TEXT data type
ALTER TABLE Patient
ALTER COLUMN MedicalHistory VARCHAR(MAX);
ALTER TABLE Patient
ALTER COLUMN ContactNo VARCHAR(MAX);
ALTER TABLE Patient
ALTER COLUMN PatientName VARCHAR(MAX);
ALTER TABLE Patient
ALTER COLUMN Allergies VARCHAR(MAX);
GO



-- 1. Handle existing Master Key
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    PRINT 'Master Key already exists. Skipping creation.';
END
ELSE
BEGIN
    -- Creating a master key
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongMasterKeyPassword!';
    PRINT 'Master Key created successfully.';
END;

-- 2. Handle existing Certificate
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'CertConfidentialData')
BEGIN
    PRINT 'Certificate already exists. Skipping creation.';
END
ELSE
BEGIN
    -- Creating a certificate to encrypt and decrypt the symmetric keys
    CREATE CERTIFICATE CertConfidentialData
    WITH SUBJECT = 'Certificate to protect confidential data';
    PRINT 'Certificate created successfully.';
END;

-- 3. Handle existing Symmetric Keys
-- Drop keys safely after decrypting the data they were used for, if they exist.

-- DoseRegimenKey
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'DoseRegimenKey')
BEGIN
    -- Decrypt data before dropping the key
    OPEN SYMMETRIC KEY DoseRegimenKey DECRYPTION BY CERTIFICATE CertConfidentialData;

    UPDATE Dose_Regimen
    SET 
        Dosage = CAST(DECRYPTBYKEY(Dosage) AS VARCHAR(MAX)),
        Frequency = CAST(DECRYPTBYKEY(Frequency) AS VARCHAR(MAX));

    CLOSE SYMMETRIC KEY DoseRegimenKey;

    DROP SYMMETRIC KEY DoseRegimenKey;
    PRINT 'Existing DoseRegimenKey dropped after decrypting data.';
END

-- Recreate DoseRegimenKey
CREATE SYMMETRIC KEY DoseRegimenKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertConfidentialData;
PRINT 'DoseRegimenKey created successfully.';

-- Encrypt data
OPEN SYMMETRIC KEY DoseRegimenKey DECRYPTION BY CERTIFICATE CertConfidentialData;

UPDATE Dose_Regimen
SET 
    Dosage = ENCRYPTBYKEY(KEY_GUID('DoseRegimenKey'), Dosage),
    Frequency = ENCRYPTBYKEY(KEY_GUID('DoseRegimenKey'), Frequency);

CLOSE SYMMETRIC KEY DoseRegimenKey;

-- CaseReporterKey
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'CaseReporterKey')
BEGIN
    -- Decrypt data before dropping the key
    OPEN SYMMETRIC KEY CaseReporterKey DECRYPTION BY CERTIFICATE CertConfidentialData;

    UPDATE Case_Reporter
    SET 
        ReporterName = CAST(DECRYPTBYKEY(ReporterName) AS VARCHAR(MAX)),
        ReporterRole = CAST(DECRYPTBYKEY(ReporterRole) AS VARCHAR(MAX)),
        ContactNo = CAST(DECRYPTBYKEY(ContactNo) AS VARCHAR(MAX)),
        ReporterNotes = CAST(DECRYPTBYKEY(ReporterNotes) AS VARCHAR(MAX));

    CLOSE SYMMETRIC KEY CaseReporterKey;

    DROP SYMMETRIC KEY CaseReporterKey;
    PRINT 'Existing CaseReporterKey dropped after decrypting data.';
END

-- Recreate CaseReporterKey
CREATE SYMMETRIC KEY CaseReporterKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertConfidentialData;
PRINT 'CaseReporterKey created successfully.';

-- Encrypt data
OPEN SYMMETRIC KEY CaseReporterKey DECRYPTION BY CERTIFICATE CertConfidentialData;

UPDATE Case_Reporter
SET 
    ReporterName = ENCRYPTBYKEY(KEY_GUID('CaseReporterKey'), ReporterName),
    ReporterRole = ENCRYPTBYKEY(KEY_GUID('CaseReporterKey'), ReporterRole),
    ContactNo = ENCRYPTBYKEY(KEY_GUID('CaseReporterKey'), ContactNo),
    ReporterNotes = ENCRYPTBYKEY(KEY_GUID('CaseReporterKey'), ReporterNotes);

CLOSE SYMMETRIC KEY CaseReporterKey;

-- PatientKey
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'PatientKey')
BEGIN
    -- Decrypt data before dropping the key
    OPEN SYMMETRIC KEY PatientKey DECRYPTION BY CERTIFICATE CertConfidentialData;

    UPDATE Patient
    SET 
        PatientName = CAST(DECRYPTBYKEY(PatientName) AS VARCHAR(MAX)),
        MedicalHistory = CAST(DECRYPTBYKEY(MedicalHistory) AS VARCHAR(MAX)),
        Allergies = CAST(DECRYPTBYKEY(Allergies) AS VARCHAR(MAX)),
        ContactNo = CAST(DECRYPTBYKEY(ContactNo) AS VARCHAR(MAX));

    CLOSE SYMMETRIC KEY PatientKey;

    DROP SYMMETRIC KEY PatientKey;
    PRINT 'Existing PatientKey dropped after decrypting data.';
END

-- Recreate PatientKey
CREATE SYMMETRIC KEY PatientKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CertConfidentialData;
PRINT 'PatientKey created successfully.';

-- Encrypt data
OPEN SYMMETRIC KEY PatientKey DECRYPTION BY CERTIFICATE CertConfidentialData;

UPDATE Patient
SET 
    PatientName = ENCRYPTBYKEY(KEY_GUID('PatientKey'), PatientName),
    MedicalHistory = ENCRYPTBYKEY(KEY_GUID('PatientKey'), MedicalHistory),
    Allergies = ENCRYPTBYKEY(KEY_GUID('PatientKey'), Allergies),
    ContactNo = ENCRYPTBYKEY(KEY_GUID('PatientKey'), ContactNo);

CLOSE SYMMETRIC KEY PatientKey;

PRINT 'Encryption script executed successfully.';


