-- Date casting check
SELECT
    start
FROM (SELECT
    TRY_CAST(start as DATE) start, -- Turning data into date if possible
    TRY_CAST(stop as DATE) stop
FROM bronze.encounters)t
WHERE start IS NULL
-- Check for encounters where stop is before start
SELECT id, start, stop
FROM bronze.encounters
WHERE TRY_CAST(stop AS DATETIME)<TRY_CAST(start AS DATETIME)
-- Duplicate check
SELECT
    patient,
    id,
    COUNT(*) counted
FROM bronze.encounters
GROUP BY patient,id
HAVING COUNT(*)>1
-- Value check
SELECT DISTINCT encounterclass FROM bronze.encounters
-- Unexpected spaces
SELECT
    id,
    patient,
    code
FROM bronze.encounters
WHERE TRIM(patient) != patient or TRIM(id) != id or TRIM(code) != code or TRIM(encounterclass) != encounterclass or TRIM(reasoncode) != reasoncode or TRIM(organization) != organization
