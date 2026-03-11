-- Date casting check
SELECT
	start
FROM (SELECT
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop
FROM bronze.conditions)t
WHERE start IS NULL

-- Duplicate check
SELECT
	patient,
	encounter,
	code,
	COUNT(*)
FROM bronze.conditions
GROUP BY patient,encounter,code
HAVING COUNT(*)>1

-- Composite key NULL check
SELECT
	patient,
	encounter,
	code
FROM bronze.conditions
WHERE patient IS NULL or encounter IS NULL or code IS NULL

-- Date casting check
SELECT
	start
FROM (SELECT
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop
FROM bronze.conditions)t
WHERE start IS NULL

-- Unexpected spaces
SELECT
	patient,
	encounter,
	code
FROM bronze.conditions
WHERE TRIM(patient) != patient or TRIM(encounter) != encounter or TRIM(code) != code

-- FK not existing keys check
SELECT patient
FROM bronze.conditions
WHERE patient NOT IN (SELECT id FROM bronze.patients)

SELECT encounter
FROM bronze.conditions
WHERE encounter NOT IN (SELECT id FROM bronze.encounters)

