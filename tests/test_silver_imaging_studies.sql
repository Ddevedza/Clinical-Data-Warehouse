-- PK NULL check
SELECT id FROM bronze.imaging_studies
WHERE id IS NULL
-- Duplicate check
SELECT
    patient,
    id,
    encounter,
    COUNT(*) counted
FROM bronze.imaging_studies
GROUP BY patient,id,encounter
HAVING COUNT(*)>1
-- Value check
SELECT DISTINCT bodysite_description FROM bronze.imaging_studies;
SELECT DISTINCT modality_code FROM bronze.imaging_studies;
SELECT DISTINCT modality_description FROM bronze.imaging_studies;
-- Date check
SELECT id
FROM (SELECT id, TRY_CAST([date] AS DATE) AS date
      FROM bronze.imaging_studies) t
WHERE date IS NULL
-- FK check
SELECT patient FROM bronze.imaging_studies
WHERE patient NOT IN (SELECT id FROM bronze.patients)

SELECT encounter FROM bronze.imaging_studies
WHERE encounter NOT IN (SELECT id FROM bronze.encounters)
-- Unexpected spaces
SELECT
    id,
    patient,
    encounter
FROM bronze.imaging_studies
WHERE TRIM(patient) != patient or TRIM(id) != id or TRIM(encounter) != encounter or TRIM(bodysite_code) != bodysite_code or TRIM(bodysite_description) != bodysite_description or TRIM(modality_code) != modality_code
