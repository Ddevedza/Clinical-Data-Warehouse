IF OBJECT_ID('silver.allergies','U') IS NOT NULL
	DROP TABLE silver.allergies; -- drop it

CREATE TABLE silver.allergies( -- then create it
	-- defining data for each table
	start DATE,
	stop DATE,
	patient_id NVARCHAR(255),
	encounter_id NVARCHAR(255),
	code NVARCHAR(50),
	description NVARCHAR(500),
	dwh_create_date DATETIME2 DEFAULT GETDATE() -- metadata when the table was created
);

GO
