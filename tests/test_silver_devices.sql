-- Duplicate check
SELECT
    patient,
    encounter,
    code,
    COUNT(*) counted_patients
FROM bronze.devices
GROUP BY patient,encounter,code
HAVING COUNT(*)>1
-- Composite key NULL check
SELECT
    patient,
    encounter,
    code
FROM bronze.devices
WHERE patient IS NULL or encounter IS NULL or code IS NULL
-- Date casting check
SELECT
    start
FROM (SELECT
    TRY_CAST(start as DATE) start, -- Turning data into date if possible
    TRY_CAST(stop as DATE) stop
FROM bronze.devices)t
WHERE start IS NULL
-- Unexpected spaces
SELECT
    patient,
    encounter,
    code
FROM bronze.devices
WHERE TRIM(patient) != patient or TRIM(encounter) != encounter or TRIM(code) != code
-- FK not existing keys check
SELECT patient
FROM bronze.devices
WHERE patient NOT IN (SELECT id FROM bronze.patients)
SELECT encounter
FROM bronze.devices
WHERE encounter NOT IN (SELECT id FROM bronze.encounters)
