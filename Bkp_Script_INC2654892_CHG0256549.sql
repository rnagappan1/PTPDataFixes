/*---------------------------------------------------------------------------------------------
FILENAME :  bkp_script_INC2654892.sql
DESCRIPTION : The purpose of this file is to create a backup for tables.

MODIFICATION HISTORY
-------------------------------------------------------------------------------------------------
     Name              Date             	     Description
#  | -------------     ---------- ---------------------------------------------------------------    
#  | N.Ramesh     13-Nov-2025       Backup Created...
-------------------------------------------------------------------------------------------------*/
SET SERVEROUTPUT ON

create table XXGIL.XXGIL_BKP_OIMS_INC2654892 as 
select * from xxgil_oims_invoices_stg
 where stg_hdr_id in(2425219);
