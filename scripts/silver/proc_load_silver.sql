TRUNCATE TABLE silver.allergies;

INSERT INTO silver.allergies (
	start,
	stop,
	patient_id,
	encounter_id,
	code,
	description
	)
SELECT
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop,
	TRIM(patient) patient_id,
	TRIM(encounter) encounter_id,
	TRIM(code) code,
	description
FROM bronze.allergies;

GO

TRUNCATE TABLE silver.careplans;

INSERT INTO silver.careplans (
	id,
	start,
	stop,
	patient_id,
	encounter_id,
	code,
	description,
	reasoncode,
	reasondescription
	)

SELECT 
	TRIM(id) id,
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop,
	TRIM(patient) patient_id,
	TRIM(encounter) encounter_id,
	TRIM(code) code,
	description,
	TRIM(reasoncode) reasoncode,
	reasondescription
FROM bronze.careplans;

GO
	
TRUNCATE TABLE silver.conditions;

INSERT INTO silver.conditions (
	start,
	stop,
	patient_id,
	encounter_id,
	code,
	description
	)
SELECT
	TRY_CAST(start as DATE) start, -- Turning data into date if possible
	TRY_CAST(stop as DATE) stop,
	TRIM(patient) patient_id,
	TRIM(encounter) encounter_id,
	TRIM(code) code,
	description
FROM bronze.conditions;
