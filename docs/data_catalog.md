# Data Catalog — Clinical Data Warehouse (Synthea)

This document describes all tables in the **Silver Layer** of the Clinical Data Warehouse.  
It covers table purpose, grain, primary keys, foreign keys, and column definitions with Silver-layer data types.

> **Source:** Synthea 1K Sample Synthetic Patient Records (CSV)  
> **Layer:** Silver (cleaned, standardized, validated)  
> **Last Updated:** 2026-03-10

---

## Table of Contents

1. [patients](#1-patients)
2. [encounters](#2-encounters)
3. [conditions](#3-conditions)
4. [observations](#4-observations)
5. [medications](#5-medications)
6. [procedures](#6-procedures)
7. [immunizations](#7-immunizations)
8. [allergies](#8-allergies)
9. [careplans](#9-careplans)
10. [devices](#10-devices)
11. [imaging_studies](#11-imaging_studies)
12. [supplies](#12-supplies)
13. [organizations](#13-organizations)
14. [providers](#14-providers)
15. [payers](#15-payers)
16. [payer_transitions](#16-payer_transitions)

---

## 1. patients

**Description:**  
One row per synthetic patient. Contains demographic, geographic, and financial attributes. This is the root entity of the warehouse — almost every clinical table links back to a patient.

**Grain:** One row per patient.  
**Primary Key:** `patient_id`  
**Foreign Keys:** None.

| Column | Silver Data Type | Description |
|---|---|---|
| patient_id | NVARCHAR(255) | Unique patient identifier (UUID) |
| birthdate | DATE | Date of birth |
| deathdate | DATE | Date of death (NULL if alive) |
| ssn | NVARCHAR(50) | Social security number |
| drivers | NVARCHAR(50) | Driver's license number |
| passport | NVARCHAR(50) | Passport number |
| prefix | NVARCHAR(50) | Name prefix (Mr., Mrs., Dr., etc.) |
| first | NVARCHAR(50) | First name |
| last | NVARCHAR(50) | Last name |
| suffix | NVARCHAR(50) | Name suffix |
| maiden | NVARCHAR(255) | Maiden name |
| marital | NVARCHAR(50) | Marital status (M, S, etc.) |
| race | NVARCHAR(50) | Race |
| ethnicity | NVARCHAR(255) | Ethnicity |
| gender | NVARCHAR(50) | Gender (M / F) |
| birthplace | NVARCHAR(255) | City and country of birth |
| address | NVARCHAR(255) | Street address |
| city | NVARCHAR(50) | City of residence |
| state | NVARCHAR(50) | State of residence |
| county | NVARCHAR(50) | County of residence |
| zip | NVARCHAR(50) | ZIP code |
| lat | DECIMAL(18,6) | Latitude coordinate |
| lon | DECIMAL(18,6) | Longitude coordinate |
| healthcare_expenses | DECIMAL(18,2) | Total lifetime healthcare expenses |
| healthcare_coverage | DECIMAL(18,2) | Total lifetime healthcare coverage |

---

## 2. encounters

**Description:**  
One row per clinical visit or hospital stay. The central table of the warehouse — nearly all clinical events (conditions, observations, medications, etc.) are linked to an encounter. Contains timing, class, cost, and reason information for each visit.

**Grain:** One row per encounter.  
**Primary Key:** `encounter_id`  
**Foreign Keys:** `patient_id` → patients, `organization_id` → organizations, `provider_id` → providers, `payer_id` → payers

| Column | Silver Data Type | Description |
|---|---|---|
| encounter_id | NVARCHAR(255) | Unique encounter identifier (UUID) |
| start | DATETIME | Encounter start timestamp |
| stop | DATETIME | Encounter end timestamp |
| patient_id | NVARCHAR(255) | FK — patient who had the encounter |
| organization_id | NVARCHAR(255) | FK — organization where encounter occurred |
| provider_id | NVARCHAR(255) | FK — provider who conducted the encounter |
| payer_id | NVARCHAR(255) | FK — payer responsible for the encounter |
| encounterclass | NVARCHAR(50) | Class of encounter (ambulatory, inpatient, emergency, etc.) |
| code | NVARCHAR(50) | SNOMED-CT encounter code |
| description | NVARCHAR(500) | Human-readable encounter description |
| base_encounter_cost | DECIMAL(18,2) | Base cost of the encounter |
| total_claim_cost | DECIMAL(18,2) | Total cost claimed |
| payer_coverage | DECIMAL(18,2) | Amount covered by payer |
| reasoncode | NVARCHAR(50) | SNOMED-CT reason code (nullable) |
| reasondescription | NVARCHAR(255) | Reason description (nullable) |

---

## 3. conditions

**Description:**  
One row per condition (diagnosis) recorded for a patient during an encounter. Conditions may be active (no stop date) or resolved (with a stop date). Used for diagnosis prevalence, cohort analysis, and chronic condition tracking.

**Grain:** One row per condition per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| start | DATE | Date condition was diagnosed |
| stop | DATE | Date condition was resolved (NULL if active) |
| patient_id | NVARCHAR(255) | FK — patient with the condition |
| encounter_id | NVARCHAR(255) | FK — encounter at which it was diagnosed |
| code | NVARCHAR(50) | SNOMED-CT condition code |
| description | NVARCHAR(500) | Condition description |

---

## 4. observations

**Description:**  
One row per clinical observation — includes lab results, vital signs, and other measurements taken during an encounter. Values can be numeric or text depending on the observation type.

**Grain:** One row per observation per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code + date).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| date | DATETIME | Date and time of the observation |
| patient_id | NVARCHAR(255) | FK — patient observed |
| encounter_id | NVARCHAR(255) | FK — encounter during which it was recorded |
| code | NVARCHAR(50) | LOINC observation code |
| description | NVARCHAR(500) | Observation name (e.g. "Body Weight") |
| value | NVARCHAR(50) | Observed value (numeric or text) |
| units | NVARCHAR(50) | Unit of measure (e.g. kg, mmHg) |
| type | NVARCHAR(50) | Value type (numeric, text, etc.) |

---

## 5. medications

**Description:**  
One row per medication prescribed to a patient. Includes start and stop dates, cost, payer coverage, and dispense count. Used for medication usage analysis, adherence tracking, and cost reporting.

**Grain:** One row per medication prescription per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code + start).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters, `payer_id` → payers

| Column | Silver Data Type | Description |
|---|---|---|
| start | DATE | Date prescription started |
| stop | DATE | Date prescription ended (NULL if ongoing) |
| patient_id | NVARCHAR(255) | FK — patient prescribed the medication |
| payer_id | NVARCHAR(255) | FK — payer covering the medication |
| encounter_id | NVARCHAR(255) | FK — encounter at which it was prescribed |
| code | NVARCHAR(50) | RxNorm medication code |
| description | NVARCHAR(500) | Medication name |
| base_cost | DECIMAL(18,2) | Base cost per dispense |
| payer_coverage | DECIMAL(18,2) | Amount covered by payer |
| dispenses | INT | Number of times dispensed |
| totalcost | DECIMAL(18,2) | Total cost of all dispenses |
| reasoncode | NVARCHAR(50) | Reason code for prescription (nullable) |
| reasondescription | NVARCHAR(255) | Reason description (nullable) |

---

## 6. procedures

**Description:**  
One row per medical procedure performed on a patient during an encounter. Includes procedure code, cost, and optional reason. Used for procedure frequency analysis and cost reporting.

**Grain:** One row per procedure per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code + date).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| date | DATE | Date the procedure was performed |
| patient_id | NVARCHAR(255) | FK — patient who received the procedure |
| encounter_id | NVARCHAR(255) | FK — encounter during which it was performed |
| code | NVARCHAR(50) | SNOMED-CT procedure code |
| description | NVARCHAR(500) | Procedure description |
| base_cost | DECIMAL(18,2) | Base cost of the procedure |
| reasoncode | NVARCHAR(50) | Reason code (nullable) |
| reasondescription | NVARCHAR(255) | Reason description (nullable) |

---

## 7. immunizations

**Description:**  
One row per immunization administered to a patient. Tracks vaccine type, date administered, and base cost. Used for immunization coverage analysis.

**Grain:** One row per immunization per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code + date).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| date | DATE | Date immunization was administered |
| patient_id | NVARCHAR(255) | FK — patient who received the immunization |
| encounter_id | NVARCHAR(255) | FK — encounter during which it was administered |
| code | NVARCHAR(50) | CVX immunization code |
| description | NVARCHAR(500) | Vaccine description |
| base_cost | DECIMAL(18,2) | Base cost of the immunization |

---

## 8. allergies

**Description:**  
One row per allergy recorded for a patient. May be linked to an encounter. Allergies may be active (no stop date) or resolved. Used for patient safety and clinical risk analysis.

**Grain:** One row per allergy per patient.  
**Primary Key:** None (composite: patient + encounter + code).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| start | DATE | Date allergy was recorded |
| stop | DATE | Date allergy was resolved (NULL if active) |
| patient_id | NVARCHAR(255) | FK — patient with the allergy |
| encounter_id | NVARCHAR(255) | FK — encounter at which it was recorded |
| code | NVARCHAR(50) | SNOMED-CT allergy code |
| description | NVARCHAR(500) | Allergy description |

---

## 9. careplans

**Description:**  
One row per care plan assigned to a patient. A care plan represents a structured plan of clinical management. May be active or completed. Optionally linked to a reason (diagnosis).

**Grain:** One row per care plan per patient per encounter.  
**Primary Key:** `careplan_id`  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| careplan_id | NVARCHAR(255) | Unique care plan identifier (UUID) |
| start | DATE | Date care plan started |
| stop | DATE | Date care plan ended (NULL if active) |
| patient_id | NVARCHAR(255) | FK — patient assigned the care plan |
| encounter_id | NVARCHAR(255) | FK — encounter at which it was initiated |
| code | NVARCHAR(50) | SNOMED-CT care plan code |
| description | NVARCHAR(500) | Care plan description |
| reasoncode | NVARCHAR(50) | Reason code (nullable) |
| reasondescription | NVARCHAR(255) | Reason description (nullable) |

---

## 10. devices

**Description:**  
One row per medical device used by a patient. Includes device type and UDI (Unique Device Identifier). May have a stop date if the device was removed or discontinued.

**Grain:** One row per device per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| start | DATE | Date device was assigned |
| stop | DATE | Date device was removed (NULL if still active) |
| patient_id | NVARCHAR(255) | FK — patient using the device |
| encounter_id | NVARCHAR(255) | FK — encounter at which it was assigned |
| code | NVARCHAR(50) | SNOMED-CT device code |
| description | NVARCHAR(500) | Device description |
| udi | NVARCHAR(255) | Unique Device Identifier |

---

## 11. imaging_studies

**Description:**  
One row per imaging study performed on a patient. Includes body site, modality (e.g. X-ray, MRI), and SOP class. Used for radiology activity analysis.

**Grain:** One row per imaging study.  
**Primary Key:** `imaging_study_id`  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| imaging_study_id | NVARCHAR(255) | Unique imaging study identifier (UUID) |
| date | DATE | Date of the imaging study |
| patient_id | NVARCHAR(255) | FK — patient who had the study |
| encounter_id | NVARCHAR(255) | FK — encounter during which it was performed |
| bodysite_code | NVARCHAR(50) | SNOMED-CT body site code |
| bodysite_description | NVARCHAR(255) | Body site description |
| modality_code | NVARCHAR(50) | Modality code (e.g. DX, MR, CT) |
| modality_description | NVARCHAR(255) | Modality description |
| sop_code | NVARCHAR(50) | DICOM SOP class code |
| sop_description | NVARCHAR(255) | SOP class description |

---

## 12. supplies

**Description:**  
One row per supply item used during an encounter. Tracks supply type and quantity. 

> ⚠️ **Note:** This table contains **0 rows** in the current dataset snapshot. The table structure is preserved for completeness and forward compatibility.

**Grain:** One row per supply per patient per encounter.  
**Primary Key:** None (composite: patient + encounter + code + date).  
**Foreign Keys:** `patient_id` → patients, `encounter_id` → encounters

| Column | Silver Data Type | Description |
|---|---|---|
| date | DATE | Date supply was used |
| patient_id | NVARCHAR(255) | FK — patient for whom the supply was used |
| encounter_id | NVARCHAR(255) | FK — encounter during which it was used |
| code | NVARCHAR(50) | SNOMED-CT supply code |
| description | NVARCHAR(500) | Supply description |
| quantity | INT | Quantity used |

---

## 13. organizations

**Description:**  
One row per healthcare organization (hospital, clinic, etc.). Reference table used to describe where encounters take place. Includes location, contact, and financial summary attributes.

**Grain:** One row per organization.  
**Primary Key:** `organization_id`  
**Foreign Keys:** None.

| Column | Silver Data Type | Description |
|---|---|---|
| organization_id | NVARCHAR(255) | Unique organization identifier (UUID) |
| name | NVARCHAR(255) | Organization name |
| address | NVARCHAR(255) | Street address |
| city | NVARCHAR(255) | City |
| state | NVARCHAR(50) | State |
| zip | NVARCHAR(50) | ZIP code |
| lat | DECIMAL(18,6) | Latitude coordinate |
| lon | DECIMAL(18,6) | Longitude coordinate |
| phone | NVARCHAR(50) | Phone number |
| revenue | DECIMAL(18,2) | Total revenue |
| utilization | INT | Total number of encounters at this organization |

---

## 14. providers

**Description:**  
One row per healthcare provider (physician, nurse, etc.). Reference table describing who conducts encounters. Linked to an organization and includes specialty and location attributes.

**Grain:** One row per provider.  
**Primary Key:** `provider_id`  
**Foreign Keys:** `organization_id` → organizations

| Column | Silver Data Type | Description |
|---|---|---|
| provider_id | NVARCHAR(255) | Unique provider identifier (UUID) |
| organization_id | NVARCHAR(255) | FK — organization the provider belongs to |
| name | NVARCHAR(255) | Provider full name |
| gender | NVARCHAR(50) | Provider gender |
| specialty | NVARCHAR(50) | Clinical specialty |
| address | NVARCHAR(255) | Street address |
| city | NVARCHAR(255) | City |
| state | NVARCHAR(50) | State |
| zip | NVARCHAR(50) | ZIP code |
| lat | DECIMAL(18,6) | Latitude coordinate |
| lon | DECIMAL(18,6) | Longitude coordinate |
| utilization | INT | Total number of encounters conducted |

---

## 15. payers

**Description:**  
One row per insurance payer. Reference table describing who covers patient costs. Includes financial summaries, coverage counts, and quality metrics.

**Grain:** One row per payer.  
**Primary Key:** `payer_id`  
**Foreign Keys:** None.

| Column | Silver Data Type | Description |
|---|---|---|
| payer_id | NVARCHAR(255) | Unique payer identifier (UUID) |
| name | NVARCHAR(255) | Payer name |
| address | NVARCHAR(255) | Street address |
| city | NVARCHAR(255) | City |
| state_headquartered | NVARCHAR(50) | State where payer is headquartered |
| zip | NVARCHAR(50) | ZIP code |
| phone | NVARCHAR(50) | Phone number |
| amount_covered | DECIMAL(18,2) | Total amount covered by payer |
| amount_uncovered | DECIMAL(18,2) | Total amount not covered |
| revenue | DECIMAL(18,2) | Total payer revenue |
| covered_encounters | INT | Number of covered encounters |
| uncovered_encounters | INT | Number of uncovered encounters |
| covered_medications | INT | Number of covered medications |
| uncovered_medications | INT | Number of uncovered medications |
| covered_procedures | INT | Number of covered procedures |
| uncovered_procedures | INT | Number of uncovered procedures |
| covered_immunizations | INT | Number of covered immunizations |
| uncovered_immunizations | INT | Number of uncovered immunizations |
| unique_customers | INT | Number of unique patients covered |
| qols_avg | FLOAT | Average Quality of Life Score |
| member_months | INT | Total member months of coverage |

---

## 16. payer_transitions

**Description:**  
One row per insurance coverage period for a patient. Tracks which payer covered a patient in a given year range and the ownership type. Used for payer transition analysis and coverage timeline reporting.

**Grain:** One row per payer coverage period per patient.  
**Primary Key:** None (composite: patient + payer + start_year).  
**Foreign Keys:** `patient_id` → patients, `payer_id` → payers

| Column | Silver Data Type | Description |
|---|---|---|
| patient_id | NVARCHAR(255) | FK — patient covered |
| start_year | INT | Year coverage started |
| end_year | INT | Year coverage ended |
| payer_id | NVARCHAR(255) | FK — payer providing coverage |
| ownership | NVARCHAR(50) | Coverage ownership type (Self, Guardian, Spouse, etc.) |

---

*Generated for the Clinical Data Warehouse portfolio project by Dušan Devedžić.*
