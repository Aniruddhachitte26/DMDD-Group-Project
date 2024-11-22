--Below Indexes are used to improve the performace of view: vw_RegulatoryReports 
CREATE INDEX idx_RCCR_AgencyID ON Regulatory_Case_Reports(AgencyID);
CREATE INDEX idx_RA_AgencyID ON Regulatory_Agency(AgencyID);
CREATE INDEX idx_RCCR_TrackingNum ON Regulatory_Case_Reports(TrackingNum);

--Below Indexes are used to improve the performace of view: CaseFollowupSummary 
CREATE INDEX idx_Case_PatientID ON [Case](PatientID);
CREATE INDEX idx_Followup_CaseID ON Follow_up(CaseID);
CREATE INDEX idx_Followup_CaseID_FollowupDate ON Follow_up(CaseID, FollowupDate);
