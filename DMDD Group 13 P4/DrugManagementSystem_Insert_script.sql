
INSERT INTO Regulatory_Agency (AgencyName, Country, RegulationCode)
VALUES
('FDA', 'USA', 'FDA-001'),
('EMA', 'Europe', 'EMA-002'),
('MHRA', 'UK', 'MHRA-003'),
('TGA', 'Australia', 'TGA-004'),
('HC', 'Canada', 'HC-005'),
('PMDA', 'Japan', 'PMDA-006'),
('BfArM', 'Germany', 'BFARM-007'),
('SwissMedic', 'Switzerland', 'SWISS-008'),
('ANVISA', 'Brazil', 'ANVISA-009'),
('NMPA', 'China', 'NMPA-010');


INSERT INTO Patient (PatientName, MedicalHistory, Allergies, ContactNo)
VALUES
('John Doe', 'No significant history', 'None', '123-456-7890'),
('Jane Smith', 'Diabetes', 'Peanuts', '234-567-8901'),
('Sam Green', 'Asthma', 'None', '345-678-9012'),
('Lisa White', 'Hypertension', 'Penicillin', '456-789-0123'),
('Mike Black', 'No significant history', 'None', '567-890-1234'),
('Sophia Blue', 'Chronic Migraine', 'None', '678-901-2345'),
('David Grey', 'No significant history', 'Shellfish', '789-012-3456'),
('Isabella Brown', 'Cancer', 'None', '890-123-4567'),
('Ethan Yellow', 'No significant history', 'None', '901-234-5678'),
('Ava Red', 'No significant history', 'None', '012-345-6789');



INSERT INTO Case_Reporter (ReporterName, ReporterRole, ContactNo, ReporterNotes)
VALUES
('John Smith', 'Investigator', '123-456-7890', 'Lead investigator for clinical trials'),
('Emma Davis', 'Analyst', '234-567-8901', 'Responsible for case analysis'),
('Lucas Brown', 'Coordinator', '345-678-9012', 'Coordinate with the regulatory agencies'),
('Olivia Clark', 'Investigator', '456-789-0123', 'Leads case follow-ups and reporting'),
('James Taylor', 'Analyst', '567-890-1234', 'Works on case documentation and reporting'),
('Sophia Lee', 'Coordinator', '678-901-2345', 'Handles follow-up reports and data analysis'),
('David Wilson', 'Investigator', '789-012-3456', 'Experienced in case handling and reporting'),
('Isabella Martinez', 'Analyst', '890-123-4567', 'Assists in preparing case reports'),
('Ethan Anderson', 'Coordinator', '901-234-5678', 'Responsible for case tracking and reporting'),
('Ava Robinson', 'Investigator', '012-345-6789', 'Specializes in case documentation');


INSERT INTO [Product] (ProductName, ProductType, ManufacturerName, ExpiryDate)
VALUES
('Aspirin', 'Drug', 'PharmaCo', '2025-12-31'),
('Tylenol', 'Drug', 'MedCo', '2026-06-30'),
('Insulin', 'Drug', 'HealthPharma', '2025-09-30'),
('Ventolin', 'Drug', 'BioHealth', '2025-11-30'),
('Advil', 'Drug', 'MedLife', '2026-05-31'),
('Salbutamol', 'Drug', 'MediHealth', '2027-04-30'),
('Glucagon', 'Drug', 'MediCare', '2026-07-31'),
('Ibuprofen', 'Drug', 'PharmaWorks', '2027-01-31'),
('Metformin', 'Drug', 'LifeScience', '2025-10-31'),
('Ciprofloxacin', 'Drug', 'PharmaWorks', '2026-03-31');



INSERT INTO [User] (UserName, [Role], ContactNo)
VALUES
('John Smith', 'Case Manager', '123-456-7890'),
('Emma Davis', 'Associate', '234-567-8901'),
('Lucas Brown', 'Quality Analyst', '345-678-9012'),
('Olivia Clark', 'Case Manager', '456-789-0123'),
('James Taylor', 'Associate', '567-890-1234'),
('Sophia Lee', 'Quality Analyst', '678-901-2345'),
('David Wilson', 'Case Manager', '789-012-3456'),
('Isabella Martinez', 'Associate', '890-123-4567'),
('Ethan Anderson', 'Quality Analyst', '901-234-5678'),
('Ava Robinson', 'Case Manager', '012-345-6789');




INSERT INTO [Case] (PatientID, ReporterID, CaseDescription, CaseDate, [Status], Severity)
VALUES
(1, 1, 'Patient experiencing side effects from drug', '2024-01-01', 'Evaluation', 2),
(2, 2, 'Patient undergoing clinical trial', '2024-01-05', 'Submitted for MR', 3),
(3, 3, 'Severe adverse reaction to medication', '2024-02-01', 'MR In-Progress', 5),
(4, 4, 'Patient suffering from chronic illness', '2024-02-10', 'Submitted for Quality Check', 4),
(5, 5, 'Case of drug overdose', '2024-03-01', 'Quality Check In-Progress', 5),
(6, 6, 'Long-term side effects under observation', '2024-03-15', 'Case Locked', 3),
(7, 7, 'Adverse reaction after drug administration', '2024-04-01', 'Closed', 2),
(8, 8, 'Patient with multiple drug interactions', '2024-04-05', 'Evaluation', 4),
(9, 9, 'Clinical trial results and analysis', '2024-05-01', 'Submitted for MR', 1),
(10, 10, 'Patient on experimental drug regimen', '2024-05-10', 'Closed', 2);



INSERT INTO Case_Report (CaseID, ReportDate, ReportStatus, ReportType)
VALUES
(111, '2024-01-01', 'Draft', 'Initial'),
(112, '2024-01-05', 'In-Review', 'Follow-Up'),
(113, '2024-02-01', 'Approved', 'Final'),
(114, '2024-02-10', 'Draft', 'Initial'),
(115, '2024-03-01', 'In-Review', 'Follow-Up'),
(116, '2024-03-15', 'Approved', 'Final'),
(117, '2024-04-01', 'Draft', 'Initial'),
(118, '2024-04-05', 'In-Review', 'Follow-Up'),
(119, '2024-05-01', 'Approved', 'Final'),
(120, '2024-05-10', 'Draft', 'Initial');




INSERT INTO Regulatory_Case_Reports (AgencyID, ReportID, SubmissionDate, ACKDate, [Status])
VALUES
(1001, 1, '2024-01-01', '2024-01-02', 'Pending'),
(1002, 2, '2024-01-05', '2024-01-06', 'Sent'),
(1003, 3, '2024-02-01', '2024-02-03', 'Success'),
(1004, 4, '2024-02-10', '2024-02-12', 'Error'),
(1005, 5, '2024-03-01', '2024-03-02', 'Pending'),
(1006, 6, '2024-03-15', '2024-03-16', 'Sent'),
(1007, 7, '2024-04-01', '2024-04-02', 'Success'),
(1008, 8, '2024-04-05', '2024-04-06', 'Error'),
(1009, 9, '2024-05-01', '2024-05-02', 'Pending'),
(1010, 10, '2024-05-10', '2024-05-11', 'Sent');



INSERT INTO Dose_Regimen (CaseID, ProductID, Dosage, Frequency)
VALUES
(111, 501, '500 mg', 'Once Daily'),
(112, 502, '5 ml', 'Twice a Day'),
(113, 503, '1 g', 'Once Weekly'),
(114, 504, '200 mg', 'Every 12 Hours'),
(115, 505, '5 mg', 'Once Daily'),
(116, 506, '1.5 ml', 'Twice a Day'),
(117, 507, '750 mg', 'Once Daily'),
(118, 508, '2 ml', 'Twice a Day'),
(119, 509, '10 mg', 'Once Daily'),
(120, 510, '5 mg', 'Once Daily');



INSERT INTO Follow_up (CaseID, FollowupDate, FollowupNotes, ReportedBy)
VALUES
(111, '2024-01-10', 'Patient showing mild improvement.', 'Patient(self)'),
(112, '2024-01-15', 'Monitoring ongoing for side effects.', 'Medical Staff Personnel'),
(113, '2024-02-05', 'Patient in stable condition.', 'Patient(self)'),
(114, '2024-02-15', 'Awaiting further tests.', 'External Contact Person'),
(115, '2024-03-05', 'Drug regimen adjustment needed.', 'Medical Staff Personnel'),
(116, '2024-03-18', 'Further observation required.', 'Medical Staff Personnel'),
(117, '2024-04-02', 'Patient has recovered.', 'Patient(self)'),
(118, '2024-04-08', 'No further issues.', 'External Contact Person'),
(119, '2024-05-02', 'Patient is in good health.', 'Patient(self)'),
(120, '2024-05-12', 'Final report submitted.', 'System Generated');



INSERT INTO User_Case_Assignment (UserID, CaseID, [Status], StartDate, CompleteDate)
VALUES
(1, 111, 'Assigned', '2024-01-01', NULL),
(2, 112, 'In Progress', '2024-01-05', NULL),
(3, 113, 'Completed', '2024-02-01', '2024-02-02'),
(4, 114, 'Assigned', '2024-02-10', NULL),
(5, 115, 'Completed', '2024-03-01', '2024-03-02'),
(6, 116, 'In Progress', '2024-03-15', NULL),
(7, 117, 'Assigned', '2024-04-01', NULL),
(8, 118, 'Completed', '2024-04-05', '2024-04-06'),
(9, 119, 'In Progress', '2024-05-01', NULL),
(10, 120, 'Completed', '2024-05-10', '2024-05-11');



INSERT INTO Drug (ProductID, DosageForm, Strength, RouteOfAdministration)
VALUES
(501, 'Tablet', '500 mg', 'Oral'),
(502, 'Syrup', '5 mg/ml', 'Oral'),
(503, 'Injection', '1 g', 'Intravenous'),
(504, 'Tablet', '200 mg', 'Oral'),
(505, 'Capsule', '5 mg', 'Oral'),
(506, 'Syrup', '1.5 ml', 'Oral'),
(507, 'Tablet', '750 mg', 'Oral'),
(508, 'Syrup', '2 ml', 'Oral'),
(509, 'Capsule', '10 mg', 'Oral'),
(510, 'Tablet', '5 mg', 'Oral');


INSERT INTO Device (ProductID, [Classification], Model, Manufacturer)
VALUES
(501, 'Class I', 'Model X', 'MedTech Inc.'),
(502, 'Class II', 'Model Y', 'HealthTech Ltd.'),
(503, 'Class III', 'Model Z', 'MediDevices Corp.'),
(504, 'Class I', 'Model A', 'HealthWorks Ltd.'),
(505, 'Class II', 'Model B', 'PharmaTech Inc.'),
(506, 'Class III', 'Model C', 'MedDevices Inc.'),
(507, 'Class I', 'Model D', 'BioMed Tech'),
(508, 'Class II', 'Model E', 'MediSolutions Ltd.'),
(509, 'Class III', 'Model F', 'MedProducts Inc.'),
(510, 'Class I', 'Model G', 'HealthSystems Inc.');



INSERT INTO Regulatory_Agency_Contact (AgencyID, FirstName, LastName, Email, Position)
VALUES
(1001, 'John', 'Doe', 'john.doe@fda.gov', 'Regulatory Affairs Officer'),
(1002, 'Emma', 'White', 'emma.white@ema.eu', 'Regulatory Specialist'),
(1003, 'Lucas', 'Smith', 'lucas.smith@mhra.uk', 'Senior Officer'),
(1004, 'Olivia', 'Johnson', 'olivia.johnson@tga.gov.au', 'Manager'),
(1005, 'James', 'Williams', 'james.williams@hc.gc.ca', 'Associate'),
(1006, 'Sophia', 'Jones', 'sophia.jones@pmda.go.jp', 'Regulatory Affairs Manager'),
(1007, 'David', 'Brown', 'david.brown@bfarm.de', 'Consultant'),
(1008, 'Isabella', 'Davis', 'isabella.davis@swissmedic.ch', 'Officer'),
(1009, 'Ethan', 'Miller', 'ethan.miller@anvisa.gov.br', 'Lead Specialist'),
(1010, 'Ava', 'Garcia', 'ava.garcia@nmpa.gov.cn', 'Director');










