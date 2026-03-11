-- Duplicate check
SELECT
	patient,
	encounter,
	code,
	COUNT(*)
FROM bronze.allergies
GROUP BY patient,encounter,code
HAVING COUNT(*)>1

-- NULL check
SELECT
	patient,
	encounter,
	code
FROM bronze.allergies
WHERE patient IS NULL or encounter IS NULL or code IS NULL

-- Date casting check
SELECT
	start
FROM (SELECT
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop
FROM bronze.allergies)t
WHERE start IS NULL

-- Unexpected spaces
SELECT
	patient,
	encounter,
	code
FROM bronze.allergies
WHERE TRIM(patient) != patient or TRIM(encounter) != encounter or TRIM(code) != code
