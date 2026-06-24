/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

/*
======================
bronze layer load proc
======================
I can execute this proc by writing one line : EXEC bronze.load_bronze;
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;

    BEGIN TRY  --error handling

        SET @batch_start_time = GETDATE();

        print '=================================';
        print 'Loading bronze layer..';
        print '=================================';

        print '---------------------------------';
        print 'Loading CRM tables';
        print '---------------------------------';
        --in case of re-run, we need to make the table empty first the reload it so we do not duplicate the loaded data
        SET @start_time = GETDATE();
        print '>> Truncating table : bronze.crm_cust_info';
        truncate table bronze.crm_cust_info;
        print '>> Inserting data into : bronze.crm_cust_info';
        bulk insert bronze.crm_cust_info
        from 'C:\Users\Sarah\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        with( --teling sql how to handle the file
           firstrow = 2,
           fieldterminator= ',',
           tablock --lock the table after loading

        );
        SET @end_time = GETDATE();
        print 'Loading duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        SET @start_time = GETDATE();
        print '>> Truncating table : bronze.crm_prd_info';
        truncate table bronze.crm_prd_info;
        print '>> Inserting data into : bronze.crm_prd_info';
        bulk insert bronze.crm_prd_info
        from 'C:\Users\Sarah\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        with(
           firstrow=2,
           fieldterminator=',', --bcz it's comma-separated
           tablock
        );
        SET @end_time = GETDATE();
        print 'Loading duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        SET @start_time = GETDATE();
        print '>> Truncating table : bronze.crm_sales_details';
        truncate table bronze.crm_sales_details;
        print '>> Inserting data into : bronze.crm_sales_details';
        bulk insert bronze.crm_sales_details
        from 'C:\Users\Sarah\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        with(
           firstrow=2,
           fieldterminator=',',
           tablock
        );
        SET @end_time = GETDATE();
        print 'Loading duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        print '---------------------------------';
        print 'Loading ERP tables';
        print '---------------------------------';

        SET @start_time = GETDATE();
        print '>> Truncating table : bronze.erp_cust_az12';
        truncate table bronze.erp_cust_az12;
        print '>> Inserting data into : bronze.erp_cust_az12';
        bulk insert bronze.erp_cust_az12
        from 'C:\Users\Sarah\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        with(
           firstrow=2,
           fieldterminator=',',
           tablock
        );
        SET @end_time = GETDATE();
        print 'Loading duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        SET @start_time = GETDATE();
        print '>> Truncating table : bronze.erp_loc_a101';
        truncate table bronze.erp_loc_a101;
        print '>> Inserting data into : bronze.erp_loc_a101';
        bulk insert bronze.erp_loc_a101
        from 'C:\Users\Sarah\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        with(
           firstrow=2,
           fieldterminator=',',
           tablock
        );
        SET @end_time = GETDATE();
        print 'Loading duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        SET @start_time = GETDATE();
        print '>> Truncating table : bronze.erp_px_cat_g1v2';
        truncate table bronze.erp_px_cat_g1v2;
        print '>> Inserting data into : bronze.erp_px_cat_g1v2';
        bulk insert bronze.erp_px_cat_g1v2
        from 'C:\Users\Sarah\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        with(
           firstrow=2,
           fieldterminator=',',
           tablock
        );
        SET @end_time = GETDATE();
        print 'Loading duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';

        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==========================================';
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END
