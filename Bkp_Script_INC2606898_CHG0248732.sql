/*---------------------------------------------------------------------------------------------
FILENAME :  bkp_script_INC2606898.sql
DESCRIPTION : The purpose of this file is to create a backup for tables.

MODIFICATION HISTORY
-------------------------------------------------------------------------------------------------
     Name              Date             Description
#  | -------------     ---------- ---------------------------------------------------------------    
#  | N.Ramesh          26-Sep-25        Backup Created...
-------------------------------------------------------------------------------------------------*/
SET SERVEROUTPUT ON

create table XXGIL.XXGIL_BKP_OIMS_INC1952624 as 
select * from xxgil_oims_invoices_stg
 where stg_hdr_id in(2407590);