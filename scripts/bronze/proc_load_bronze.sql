/* 

=====================================================================

Stored Procedure: Load Bronze Layer (Source -> Bronze)

=====================================================================

Creating batch loading for bronze data. In this query we will define and bulk in each table from each csv in a controlled manner.
*/

-- Creating procedure for bronze batch data loading
CREATE OR ALTER PROCEDURE bronze.load_bronze  
AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; -- defining time variables so we can check each separate execution, along with total batch execution
-- Start of the procedure
BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '========================================' -- prints for nice viewing
	PRINT 'Loading Bronze Layer'
	PRINT '========================================'

	PRINT '----------------------------------------'
	PRINT 'Loading allergies'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE(); -- table exec measuring
	PRINT '>> Truncating Table: bronze.allergies'
	TRUNCATE TABLE bronze.allergies; -- truncating so tables are not duplicated once it is runned

	PRINT '>> Inserting Data Into Table: bronze.allergies'
	BULK INSERT bronze.allergies -- bulk insert per table
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\allergies.csv' -- source
		WITH ( FIRSTROW = 2, --where the bulk starts (first row is header)
		FIELDTERMINATOR = ',', -- what is separating each column data
		ROWTERMINATOR = '0x0a', 
		TABLOCK,
		CODEPAGE = '65001'); -- it locks in whole table while loading in - good with bulk
	SET @end_time = GETDATE(); -- catching end time
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; -- creating time difference between start and end as NVARCHAR in seconds
	PRINT '>> -----------------';

	PRINT '----------------------------------------' 
	PRINT 'Loading careplans'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.careplans'
	TRUNCATE TABLE bronze.careplans;

	PRINT '>> Inserting Data Into Table: bronze.careplans'
	BULK INSERT bronze.careplans
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\careplans.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading conditions'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.conditions'
	TRUNCATE TABLE bronze.conditions;

	PRINT '>> Inserting Data Into Table: bronze.conditions'
	BULK INSERT bronze.conditions
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\conditions.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading devices'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.devices'
	TRUNCATE TABLE bronze.devices;

	PRINT '>> Inserting Data Into Table: bronze.devices'
	BULK INSERT bronze.devices
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\devices.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading encounters'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.encounters'
	TRUNCATE TABLE bronze.encounters;

	PRINT '>> Inserting Data Into Table: bronze.encounters'
	BULK INSERT bronze.encounters
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\encounters.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading imaging_studies'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.imaging_studies'
	TRUNCATE TABLE bronze.imaging_studies;

	PRINT '>> Inserting Data Into Table: bronze.imaging_studies'
	BULK INSERT bronze.imaging_studies
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\imaging_studies.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading immunizations'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.immunizations'
	TRUNCATE TABLE bronze.immunizations;

	PRINT '>> Inserting Data Into Table: bronze.immunizations'
	BULK INSERT bronze.immunizations
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\immunizations.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading medications'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.medications'
	TRUNCATE TABLE bronze.medications;

	PRINT '>> Inserting Data Into Table: bronze.medications'
	BULK INSERT bronze.medications
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\medications.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading observations'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.observations'
	TRUNCATE TABLE bronze.observations;

	PRINT '>> Inserting Data Into Table: bronze.observations'
	BULK INSERT bronze.observations
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\observations.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading organizations'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.organizations'
	TRUNCATE TABLE bronze.organizations;

	PRINT '>> Inserting Data Into Table: bronze.organizations'
	BULK INSERT bronze.organizations
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\organizations.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading patients'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.patients'
	TRUNCATE TABLE bronze.patients;

	PRINT '>> Inserting Data Into Table: bronze.patients'
	BULK INSERT bronze.patients
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\patients.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading payer_transitions'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.payer_transitions'
	TRUNCATE TABLE bronze.payer_transitions;

	PRINT '>> Inserting Data Into Table: bronze.payer_transitions'
	BULK INSERT bronze.payer_transitions
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\payer_transitions.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading payers'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.payers'
	TRUNCATE TABLE bronze.payers;

	PRINT '>> Inserting Data Into Table: bronze.payers'
	BULK INSERT bronze.payers
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\payers.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading procedures'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.procedures'
	TRUNCATE TABLE bronze.procedures;

	PRINT '>> Inserting Data Into Table: bronze.procedures'
	BULK INSERT bronze.procedures
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\procedures.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading providers'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.providers'
	TRUNCATE TABLE bronze.providers;

	PRINT '>> Inserting Data Into Table: bronze.providers'
	BULK INSERT bronze.providers
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\providers.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	PRINT '----------------------------------------'
	PRINT 'Loading supplies'
	PRINT '----------------------------------------'

	SET @start_time = GETDATE()
	PRINT '>> Truncating Table: bronze.supplies'
	TRUNCATE TABLE bronze.supplies;

	PRINT '>> Inserting Data Into Table: bronze.supplies'
	BULK INSERT bronze.supplies
	FROM 'C:\Users\Dusan\Desktop\synthea_sample_data_csv_apr2020\csv\supplies.csv'
	WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK, CODEPAGE = '65001' );
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> -----------------';

	SET @batch_end_time = GETDATE()
	PRINT '========================================'
	PRINT 'Loading Bronze Layer is Completed';
	PRINT '		- Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
	PRINT '========================================'
	END TRY

	BEGIN CATCH -- Error catching
		PRINT '========================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE(); -- printing error message
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR); -- which number error was made
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR); -- printing at which line it occured
		PRINT '========================================'
	END CATCH
END;
GO

EXEC bronze.load_bronze; -- exec the whole load
GO
