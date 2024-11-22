--1. Viewing the encrypted data from Dose Regimen
Print 'Printing encrypted and decrypted data from Dose Regimen';
SELECT * FROM Dose_Regimen;

-- Decrypting data
OPEN SYMMETRIC KEY DoseRegimenKey DECRYPTION BY CERTIFICATE CertConfidentialData;

SELECT 
    RegimenID,
    CaseID,
    ProductID,
    CAST(DECRYPTBYKEY(Dosage) AS VARCHAR(MAX)) AS DecryptedDosage,
    CAST(DECRYPTBYKEY(Frequency) AS VARCHAR(MAX)) AS DecryptedFrequency
FROM Dose_Regimen;

CLOSE SYMMETRIC KEY DoseRegimenKey;




--2. Viewing the encrypted data from Case_Reporter
Print 'Printing encrypted and decrypted data from Case_Reporter';
SELECT * FROM Case_Reporter;

-- Decrypting data
OPEN SYMMETRIC KEY CaseReporterKey DECRYPTION BY CERTIFICATE CertConfidentialData;

SELECT 
    ReporterID,
    CAST(DECRYPTBYKEY(ReporterName) AS VARCHAR(100)) AS DecryptedReporterName,
    CAST(DECRYPTBYKEY(ReporterRole) AS VARCHAR(50)) AS DecryptedReporterRole,
    CAST(DECRYPTBYKEY(ContactNo) AS VARCHAR(20)) AS DecryptedContactNo,
    CAST(DECRYPTBYKEY(ReporterNotes) AS VARCHAR(MAX)) AS DecryptedReporterNotes
FROM Case_Reporter;

CLOSE SYMMETRIC KEY CaseReporterKey;




--3. Viewing the encrypted data from Patient
Print 'Printing encrypted and decrypted data from Patient';
SELECT * FROM Patient;

-- Decrypting data
OPEN SYMMETRIC KEY PatientKey DECRYPTION BY CERTIFICATE CertConfidentialData;

SELECT 
    PatientID,
    CAST(DECRYPTBYKEY(PatientName) AS VARCHAR(100)) AS DecryptedPatientName,
    CAST(DECRYPTBYKEY(MedicalHistory) AS VARCHAR(MAX)) AS DecryptedMedicalHistory,
    CAST(DECRYPTBYKEY(Allergies) AS VARCHAR(100)) AS DecryptedAllergies,
    CAST(DECRYPTBYKEY(ContactNo) AS VARCHAR(20)) AS DecryptedContactNo
FROM Patient;

CLOSE SYMMETRIC KEY PatientKey;
