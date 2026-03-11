-- Date casting check
SELECT
	start
FROM (SELECT
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop
FROM bronze.careplans)t
WHERE start IS NULL

-- Unexpected spaces
SELECT
	id,
	patient,
	encounter,
	code
FROM bronze.careplans
WHERE TRIM(id) != id or TRIM(patient) != patient or TRIM(encounter) != encounter or TRIM(code) != code

-- PK NULL check
SELECT
	id
FROM bronze.careplans
WHERE id IS NULL

-- Duplicate check
SELECT
	id,
	COUNT(*)
FROM bronze.careplans
GROUP BY id
HAVING COUNT(*)>1

-- FK not existing keys check
SELECT patient
FROM bronze.careplans
WHERE patient NOT IN (SELECT id FROM bronze.patients)

SELECT encounter
FROM bronze.careplans
WHERE encounter NOT IN (SELECT id FROM bronze.encounters)
