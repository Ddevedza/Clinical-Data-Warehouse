-- Date casting check
SELECT
    start
FROM (SELECT
    TRY_CAST(start as DATE) start, -- Turning data into date if possible
    TRY_CAST(stop as DATE) stop
FROM bronze.medications)t
WHERE start IS NULL

-- Check for encounters where stop is before start
SELECT patient,start, stop
FROM bronze.medications
WHERE TRY_CAST(stop AS DATETIME)<TRY_CAST(start AS DATETIME)

SELECT 
    patient,
    CASE 
        WHEN TRY_CAST(stop AS DATETIME) < TRY_CAST(start AS DATETIME) THEN TRY_CAST(stop AS DATETIME)
        ELSE TRY_CAST(start AS DATETIME) 
    END AS start_date,
    CASE 
        WHEN TRY_CAST(stop AS DATETIME) < TRY_CAST(start AS DATETIME) THEN TRY_CAST(start AS DATETIME)
        ELSE TRY_CAST(stop AS DATETIME) 
    END AS stop_date
FROM bronze.medications;

-- Composite key NULL check
SELECT patient, encounter, code
FROM bronze.medications
WHERE patient IS NULL OR encounter IS NULL OR code IS NULL

-- Duplicate check
SELECT patient, encounter, code, start, COUNT(*)
FROM bronze.medications
GROUP BY patient, encounter, code, start
HAVING COUNT(*) > 1

-- Unexpected spaces
SELECT patient, encounter, code
FROM bronze.medications
WHERE TRIM(patient) != patient OR TRIM(encounter) != encounter OR TRIM(code) != code

-- FK checks
SELECT patient FROM bronze.medications
WHERE patient NOT IN (SELECT id FROM bronze.patients)

SELECT encounter FROM bronze.medications
WHERE encounter NOT IN (SELECT id FROM bronze.encounters)

SELECT payer FROM bronze.medications
WHERE payer NOT IN (SELECT id FROM bronze.payers)

-- Negative cost check (costs should never be negative)
SELECT patient, base_cost, payer_coverage, totalcost
FROM bronze.medications
WHERE base_cost < 0 OR payer_coverage < 0 OR totalcost < 0

-- Payer coverage exceeds total cost (shouldn't be possible)
SELECT patient, totalcost, payer_coverage
FROM bronze.medications
WHERE payer_coverage > totalcost

-- Dispenses should be positive
SELECT patient, dispenses
FROM bronze.medications
WHERE dispenses <= 0
