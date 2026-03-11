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
