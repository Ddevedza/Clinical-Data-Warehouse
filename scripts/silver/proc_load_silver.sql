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
	TRY_CAST(start as DATETIME) start, -- Turning data into date if possible
	TRY_CAST(stop as DATETIME) stop,
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
	TRY_CAST(start as DATETIME) start, -- Turning data into date if possible
	TRY_CAST(stop as DATETIME) stop,
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
	TRY_CAST(start as DATETIME) start, -- Turning data into date if possible
	TRY_CAST(stop as DATETIME) stop,
	TRIM(patient) patient_id,
	TRIM(encounter) encounter_id,
	TRIM(code) code,
	description
FROM bronze.conditions;

GO

TRUNCATE TABLE silver.devices;

INSERT INTO silver.devices (
    start,
    stop,
    patient_id,
    encounter_id,
    code,
    description,
    udi
    )
SELECT
    TRY_CAST(start as DATETIME) start, -- Turning data into date if possible
    TRY_CAST(stop as DATETIME) stop,
    TRIM(patient) patient_id,
    TRIM(encounter) encounter_id,
    TRIM(code) code,
    description,
    TRIM(udi)
FROM bronze.devices;

GO

TRUNCATE TABLE silver.encounters;

INSERT INTO silver.encounters (
    id,
    start,
    stop,
    patient_id,
    organization_id,
    payer_id,
    provider_id,
    encounterclass,
    code,
    description,
    base_encounter_cost,
    total_claim_cost,
    payer_coverage,
    reasoncode,
    reasondescription
)
SELECT
    TRIM(id) AS id,
    TRY_CAST(start AS DATETIME) AS start,
    TRY_CAST(stop AS DATETIME) AS stop,
    TRIM(patient) AS patient_id,
    TRIM(organization) organization_id,
    TRIM(payer) payer_id,
    TRIM(provider) provider_id,
    LOWER(TRIM(encounterclass)) encounterclass,
    TRIM(code) AS code,
    description,
    base_encounter_cost,
    total_claim_cost,
    payer_coverage,
    TRIM(reasoncode) AS reasoncode,
    reasondescription
FROM bronze.encounters;
