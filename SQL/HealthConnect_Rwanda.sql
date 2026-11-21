
-- HEALTHCONNECT HEALTHCARE ANALYTICS
-- PATIENT ANALYSIS: 
-- 


-- Question 1: Retrieve all registered patients
SELECT *
FROM dbo.HC_Patients;

-- Interpretation:
-- Retrieves all registered patient records and all columns
-- available in the HC_Patients table.


-- Question 2: Count patients by gender
SELECT
    Gender,
    COUNT(PatientID) AS gender_category
FROM dbo.HC_Patients
GROUP BY Gender;

-- Interpretation:
-- Male: 10,090
-- Female: 9,910
-- The query returned 20,000 patients in total.
-- Male patients account for 50.45%, while female patients
-- account for 49.55%.
-- Note: Verify the total because Power Query previously
-- showed 2,000 patient records.


-- Question 3: Count patients by province
SELECT
    p.ProvinceName,
    COUNT(pt.PatientID) AS PatientCount
FROM dbo.HC_Patients AS pt
JOIN dbo.HC_Villages AS v
    ON pt.VillageID = v.VillageID
JOIN dbo.HC_Sectors AS s
    ON v.SectorID = s.SectorID
JOIN dbo.HC_Districts AS d
    ON s.DistrictID = d.DistrictID
JOIN dbo.HC_Provinces AS p
    ON d.ProvinceID = p.ProvinceID
GROUP BY p.ProvinceName;

-- Interpretation:
-- Western: 4,091
-- Eastern: 4,067
-- Southern: 3,967
-- Kigali City: 3,952
-- Northern: 3,923
-- Western recorded the highest patient count, while
-- Northern recorded the lowest.
-- Note: The total is 20,000, so verify the discrepancy
-- with the 2,000 records previously profiled in Power Query.


-- Question 4: Identify patients above 65 years
SELECT *
FROM dbo.HC_Patients
WHERE Age > 65;

-- Interpretation:
-- Retrieves all patient records for patients older than
-- 65 years. Record the number of rows returned after execution.

-- Question 5: Find patients with chronic diseases
SELECT *
FROM dbo.HC_Patients
WHERE ChronicCondition <> 'None';

-- Interpretation:
-- Retrieves patients whose ChronicCondition value is
-- not 'None', identifying patients with a recorded
-- chronic condition.


-- Question 7: Count patients by blood group
SELECT
    BloodGroup,
    COUNT(PatientID) AS bloodgroup_count
FROM dbo.HC_Patients
GROUP BY BloodGroup;

-- Results:
-- AB+: 2,918
-- O-: 2,896
-- B+: 2,833
-- A-: 2,892
-- AB+: 2,918
-- A+: 2,889
-- B-: 2,792
-- O+: 2,780
-- Total: 20,000

-- Interpretation:
-- AB+ has the highest count with 2,918 patients.
-- O+ has the lowest count with 2,780 patients.
-- The query groups patients by blood group and counts
-- the patients in each group.

-- Question 8: List the youngest and oldest patients
SELECT *
FROM dbo.HC_Patients
WHERE Age = (SELECT MIN(Age) FROM dbo.HC_Patients)
   OR Age = (SELECT MAX(Age) FROM dbo.HC_Patients);

-- Interpretation:
-- Retrieves all patient records for patients with the
-- youngest and oldest ages in the dataset.

-- Question 9: Identify duplicate phone numbers
SELECT
    Phone,
    COUNT(*) AS Duplicate
FROM dbo.HC_Patients
GROUP BY Phone
HAVING COUNT(*) > 1;

-- Results:
-- The query returned phone numbers appearing more than once.
-- Examples from the results:
-- 250788003840: 2,288 occurrences
-- 250782007292: 2,187 occurrences
-- 250783006720: 2,204 occurrences
-- 250787004416: 2,225 occurrences
-- 250784006144: 2,181 occurrences
-- 250785005568: 2,255 occurrences
-- 250781007872: 1,098 occurrences
-- 250786004992: 2,194 occurrences
-- 250789003264: 2,239 occurrences
-- 250790002688: 1,129 occurrences

-- Interpretation:
-- Identifies phone numbers shared by multiple patient records.
-- The repeated phone numbers may indicate duplicate records
-- or shared contact numbers and should be investigated.

-- Question 11: Count appointments by month
SELECT
    MONTH(Date) AS Month,
    COUNT(AppointmentID) AS appointment_count
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
GROUP BY MONTH(Date)
ORDER BY Month;

-- Results:
-- January: 418
-- February: 413
-- March: 440
-- April: 405
-- May: 400
-- June: 437
-- July: 416
-- August: 428
-- September: 408
-- October: 414
-- November: 420
-- December: 401

-- Interpretation:
-- March had the highest number of appointments (440),
-- while May had the lowest number (400).
-- The query groups appointments by calendar month and
-- counts the appointments recorded in each month.


-- Question 12: Identify busiest hospitals

SELECT TOP 5
    FacilityID,
    COUNT(AppointmentID) AS appointment_count
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
GROUP BY FacilityID
ORDER BY appointment_count DESC;

-- Results:
-- HF013: 278
-- HF014: 276
-- HF010: 275
-- HF001: 273
-- HF011: 273

-- Interpretation:
-- HF013 recorded the highest appointment volume with 278 appointments.
-- HF001 and HF011 tied at 273 appointments each.
-- The results identify facility IDs rather than hospital names
-- because a confirmed facility lookup table is not available.

-- Question 13: Find busiest departments

SELECT TOP 5
    DepartmentID,
    COUNT(AppointmentID) AS appointment_count
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
GROUP BY DepartmentID
ORDER BY appointment_count DESC;

-- Results:
-- DEP068: 38
-- DEP095: 37
-- DEP181: 36
-- DEP176: 35
-- DEP115: 34

-- Interpretation:
-- DEP068 recorded the highest appointment volume with 38 appointments.
-- DEP095 followed with 37 appointments.
-- The top five departments recorded between 34 and 38 appointments.
-- These counts show appointment volume but do not establish
-- workload or efficiency without staffing and capacity data.

-- Question 14: Find doctors with the highest workload

SELECT TOP 5
    DoctorID,
    COUNT(AppointmentID) AS appointment_count
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
GROUP BY DoctorID
ORDER BY appointment_count DESC;

-- Results:
-- DO0082: 28
-- DO0144: 25
-- DO0322: 24
-- DO0218: 24
-- DO0193: 24

-- Interpretation:
-- DO0082 recorded the highest appointment count with 28 appointments.
-- DO0144 followed with 25 appointments.
-- Three other doctors each recorded 24 appointments.
-- Appointment counts indicate recorded activity but do not
-- independently establish whether a doctor is overworked.


-- Question 15: Identify referral patterns

SELECT TOP 5
    ReferredFacilityID,
    COUNT(ReferralID) AS referral_count
FROM dbo.[HC_Clinical_Transactions.xlsx - Referrals]
GROUP BY ReferredFacilityID
ORDER BY referral_count DESC;

-- Results:
-- HF014: 258
-- HF007: 255
-- HF011: 250
-- HF001: 247
-- HF017: 246

-- Interpretation:
-- HF014 received the highest number of referrals, with 258.
-- HF007 followed with 255 referrals.
-- The top five destination facilities received between
-- 246 and 258 referrals.
-- Facility names and capacity data would be needed to
-- investigate referral reasons and resource requirements.


-- Question 16: Count emergency appointments

SELECT
    COUNT(AppointmentID) AS emergency_appointment
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
WHERE VisitType = 'Emergency';

-- Result:
-- Emergency appointments: 1,650

-- Interpretation:
-- The dataset contains 1,650 appointments classified as Emergency.
-- This count provides an indication of recorded emergency service demand.


-- Question 17: Calculate average appointments per doctor

WITH appointment_count AS (
    SELECT
        DoctorID,
        COUNT(AppointmentID) AS total_appointment
    FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
    GROUP BY DoctorID
)
SELECT
    AVG(total_appointment) AS avg_appointment_per_doctor
FROM appointment_count;

-- Result:
-- Average appointments per doctor: 14

-- Interpretation:
-- Doctors handled an average of 14 appointments each.
-- This provides a baseline for assessing appointment distribution,
-- but further analysis is needed to determine workload balance.

-- Question 18: Retrieve appointments by province

SELECT
    p.ProvinceName,
    COUNT(ap.AppointmentID) AS appointmentCount
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments] AS ap
JOIN dbo.HC_Patients AS pt
    ON ap.PatientID = pt.PatientID
JOIN dbo.HC_Villages AS v
    ON pt.VillageID = v.VillageID
JOIN dbo.HC_Sectors AS s
    ON v.SectorID = s.SectorID
JOIN dbo.HC_Districts AS d
    ON s.DistrictID = d.DistrictID
JOIN dbo.HC_Provinces AS p
    ON d.ProvinceID = p.ProvinceID
GROUP BY p.ProvinceName;

-- Results:
-- Western: 1,051
-- Northern: 1,021
-- Eastern: 1,006
-- Southern: 978
-- Kigali City: 944

-- Interpretation:
-- Western recorded the highest appointment count with 1,051.
-- Kigali City recorded the lowest with 944.
-- The difference between the highest and lowest counts was 107.
-- Appointment counts alone do not establish differences in
-- healthcare access across provinces.

-- Question 19: Identify facilities with the highest patient volume

SELECT TOP 5
    FacilityID,
    COUNT(DISTINCT PatientID) AS patientCount
FROM dbo.[HC_Clinical_Transactions.xlsx - Appointments]
GROUP BY FacilityID
ORDER BY patientCount DESC;

-- Results:
-- HF013: 277
-- HF014: 275
-- HF001: 272
-- HF010: 272
-- HF011: 271

-- Interpretation:
-- HF013 recorded the highest patient volume with 277 unique patients.
-- HF014 followed with 275 unique patients.
-- The top five facilities recorded between 271 and 277 unique patients.
-- These counts show patient volume but do not establish
-- whether facility resources are sufficient.

-- Question 21: Identify top diagnoses

SELECT Diagnosis,
    COUNT(DiagnosisID) AS diagnosisCount
FROM dbo.HC_Diagnoses
GROUP BY Diagnosis
ORDER BY diagnosisCount DESC;

-- Results:
-- Gastritis: 12,208
-- Diabetes: 12,083
-- Hypertension: 12,075
-- Malaria: 11,878
-- Upper Respiratory Infection: 11,756

-- Interpretation:
-- Gastritis was the most frequently recorded diagnosis,
-- with 12,208 entries.
-- Diabetes and hypertension followed with 12,083 and
-- 12,075 entries, respectively.
-- These counts represent diagnosis records, not necessarily
-- unique patients or disease prevalence.

-- Question 22: Most requested laboratory tests

SELECT
    Test,
    COUNT(LabID) AS testCount
FROM dbo.[HC_Clinical_Transactions.xlsx - Laboratory_Tests]
GROUP BY Test
ORDER BY testCount DESC;

-- Results:
-- Malaria: 1,272
-- CBC: 1,257
-- Glucose: 1,247
-- Urinalysis: 1,224

-- Interpretation:
-- Malaria was the most frequently recorded laboratory test,
-- with 1,272 tests.
-- Urinalysis had the lowest count, with 1,224 tests.
-- These results show recorded laboratory test volumes and
-- may help inform service planning.

-- Question 23: Most prescribed medications

SELECT TOP 5
    Medication,
    COUNT(PrescriptionID) AS medicationCount
FROM dbo.[HC_Clinical_Transactions.xlsx - Prescriptions]
GROUP BY Medication
ORDER BY medicationCount DESC;

-- Results:
-- Amlodipine: 1,068
-- Omeprazole: 1,040
-- Metformin: 999
-- Amoxicillin: 979
-- Artemether-Lumefantrine: 914

-- Interpretation:
-- Amlodipine was the most frequently recorded medication,
-- with 1,068 prescriptions.
-- Artemether-Lumefantrine had the lowest count among the
-- top five, with 914 prescriptions.
-- These results may help inform pharmacy stock planning,
-- but do not establish whether stock levels are sufficient.

-- Question 24: Average admission duration

SELECT
    AVG(LengthOfStayDays) AS avg_stay_length
FROM dbo.[HC_Clinical_Transactions.xlsx - Admissions];

-- Result:
-- Average admission duration: 5 days

-- Interpretation:
-- The average recorded length of stay was 5 days.
-- This provides a baseline for monitoring admission duration
-- and planning inpatient services.

-- Question 25: Disease severity distribution

SELECT
    Severity,
    COUNT(DiagnosisID) AS severity_count
FROM dbo.HC_Diagnoses
GROUP BY Severity
ORDER BY severity_count DESC;

-- Results:
-- Mild: 20,190
-- Severe: 19,983
-- Moderate: 19,827

-- Interpretation:
-- Mild was the most frequent severity category, with 20,190 records.
-- Severe followed with 19,983, while Moderate had 19,827.
-- The counts are relatively similar across the three categories.
-- These are diagnosis records, not necessarily unique patients.

-- Question 26: Laboratory test utilization

WITH TEST_COUNT AS (
    SELECT
        Test,
        COUNT(LabID) AS testCount
    FROM dbo.[HC_Clinical_Transactions.xlsx - Laboratory_Tests]
    GROUP BY Test
)
SELECT
    Test,
    testCount,
    CAST(
        testCount * 100.0 / SUM(testCount) OVER ()
        AS DECIMAL(5,2)
    ) AS utilization_percentage
FROM TEST_COUNT
ORDER BY utilization_percentage DESC;

-- Results:
-- Malaria: 1,272 (25.44%)
-- CBC: 1,257 (25.14%)
-- Glucose: 1,247 (24.94%)
-- Urinalysis: 1,224 (24.48%)

-- Interpretation:
-- Malaria tests accounted for the largest share at 25.44%.
-- Urinalysis accounted for the smallest share at 24.48%.
-- Test utilization was relatively evenly distributed.

-- Question 29: Admission rate by diagnosis

WITH Admission_diagnosis AS (
    SELECT
        d.Diagnosis,
        COUNT(d.DiagnosisID) AS diagnosisCount,
        COUNT(a.AdmissionID) AS admissionCount
    FROM dbo.HC_Diagnoses AS d
    LEFT JOIN dbo.[HC_Clinical_Transactions.xlsx - Admissions] AS a
        ON d.AppointmentID = a.AppointmentID
    GROUP BY d.Diagnosis
)
SELECT
    Diagnosis,
    diagnosisCount,
    admissionCount,
    CAST(
        admissionCount * 100.0 / diagnosisCount
        AS DECIMAL(5,2)
    ) AS admission_Rate
FROM Admission_diagnosis
ORDER BY admission_Rate DESC;

-- Interpretation:
-- Upper Respiratory Infection had the highest calculated
-- admission rate at 8.61%.
-- Malaria had the lowest at 8.09%.
-- The rates were relatively similar across the five diagnoses.
-- Validate the joins and counts before drawing clinical conclusions.

-- Q34: Insurance Claims by Provider

SELECT Provider, COUNT(ClaimID) AS insuranceClaim
FROM HC_Insurance_Claims
GROUP BY Provider
ORDER BY insuranceClaim DESC;

-- Results:
-- Radiant: 10,644
-- RSSB: 10,511
-- Private: 10,508
-- MMI: 10,373
-- Total claims: 42,036

-- Interpretation:
-- Radiant recorded the highest number of claims (10,644),
-- while MMI recorded the lowest (10,373).
-- The difference between them was 271 claims.

-- Business Insight:
-- Claim volumes were relatively similar across providers.
-- Claim counts alone do not indicate claim values or approval rates.

-- Q35: Outstanding Payments

SELECT
    SUM(b.Amount - COALESCE(p.AmountPaid, 0))
        AS TotalOutstandingBalance
FROM dbo.HC_Billing AS b
LEFT JOIN dbo.HC_Payments AS p
    ON b.BillingID = p.BillingID
WHERE b.Amount > COALESCE(p.AmountPaid, 0);

-- Result:
-- Total Outstanding Balance: 919,947,405

-- Interpretation:
-- The total outstanding balance based on recorded billing
-- and payment amounts is 919,947,405.

-- Data Quality Note:
-- Some bills marked as Paid have outstanding balances,
-- while some bills marked as Pending have payments equal
-- to their full billing amounts. Therefore, the Status
-- field may be inconsistent with the recorded amounts.


-- Q36: Average Billing Amount

SELECT CAST(AVG(CAST(Amount AS BIGINT)) AS DECIMAL(10,2))
       AS avg_amount
FROM dbo.HC_Billing;

-- Result:
-- Average Billing Amount: 155,156.00

-- Interpretation:
-- The average billing amount across all records in
-- HC_Billing is 155,156.00.

-- Business Insight:
-- This provides a baseline for understanding the
-- typical billing amount and comparing billing patterns.


-- Q37: Monthly Revenue Trend

SELECT
    [Month],
    Revenue
FROM dbo.HC_Revenue_Summary
ORDER BY [Month];

-- Results:
-- Jan 2026: 89,606,847
-- Feb 2026: 89,649,048
-- Mar 2026: 91,548,666
-- Apr 2026: 76,571,605
-- May 2026: 134,086,770
-- Jun 2026: 78,698,417
-- Jul 2026: 78,952,898
-- Aug 2026: 69,840,511
-- Sep 2026: 145,759,784
-- Oct 2026: 89,598,290
-- Nov 2026: 121,678,182
-- Dec 2026: 66,686,482

-- Interpretation:
-- September recorded the highest monthly revenue at
-- 145,759,784, followed by May at 134,086,770.
-- December recorded the lowest revenue at 66,686,482.

-- Business Insight:
-- Revenue fluctuated throughout the year, with notable
-- peaks in May, September, and November. December had
-- the lowest recorded revenue, which may warrant further
-- investigation into service demand and billing patterns.


-- Q38: Payment Methods

SELECT
    Method,
    COUNT(PaymentID) AS payment_count,
    SUM(AmountPaid) AS total_amount
FROM dbo.HC_Payments
GROUP BY Method
ORDER BY total_amount DESC;

-- Results:
-- Card: 15,145 payments; Total: 2,115,489,446
-- Mobile Money: 15,016 payments; Total: 2,104,779,310
-- Insurance: 14,944 payments; Total: 2,094,324,407
-- Cash: 14,895 payments; Total: 2,074,861,393

-- Interpretation:
-- Card had the highest number of payments (15,145)
-- and the highest total amount paid (2,115,489,446).
-- Cash had the lowest number of payments (14,895)
-- and the lowest total amount paid (2,074,861,393).

-- Business Insight:
-- Payment volumes and total amounts were relatively
-- similar across all four payment methods.