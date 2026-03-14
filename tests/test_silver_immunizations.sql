-- Date check
SELECT patient
FROM (SELECT patient, TRY_CAST([date] AS DATE) AS date
      FROM bronze.immunizations) t
WHERE date IS NULL

-- Duplicate check
SELECT
	patient,
	encounter,
	code,
	COUNT(*) counted
FROM bronze.immunizations
GROUP BY patient,encounter,code
HAVING COUNT(*)>1

-- NULL check
SELECT
	patient,
	encounter,
	code
FROM bronze.immunizations
WHERE patient IS NULL or encounter IS NULL or code IS NULL

-- Unexpected spaces
SELECT
	patient,
	encounter,
	code
FROM bronze.immunizations
WHERE TRIM(patient) != patient or TRIM(encounter) != encounter or TRIM(code) != code

-- FK not existing keys check
SELECT patient
FROM bronze.immunizations
WHERE patient NOT IN (SELECT id FROM bronze.patients)

SELECT encounter
FROM bronze.immunizations
WHERE encounter NOT IN (SELECT id FROM bronze.encounters)
