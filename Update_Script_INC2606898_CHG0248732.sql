/*---------------------------------------------------------------------------------------------
DESCRIPTION : The purpose of this file is to update records in xxgil_oims_invoices_stg table to
Sync status of invoices between OIMS & Oracle.
MODIFICATION HISTORY  
-------------------------------------------------------------------------------------------------
      Name               Date             Description
#  | -------------      ----------    ---------------------------------------------------------------
#  | N.Ramesh          26-Sep-2025     Created for : INC2606898
-------------------------------------------------------------------------------------------------*/
SET SERVEROUTPUT ON ;
DECLARE
  ln_exception_id   NUMBER;
  ln_exception_open NUMBER;
  lv_return_status  VARCHAR2 (100);
  lv_return_msg     VARCHAR2 (4000);
  lv_stg_hdr_id XXGIL_OIMS_INVOICES_STG.STG_HDR_ID%TYPE;
  l_message         VARCHAR2 (1000);
  l_processed       NUMBER := 0;
  l_processed_count NUMBER := 0;
  i                 NUMBER := 0 ;
  CURSOR c_oims_hdr
  IS
    SELECT *
    FROM xxgil_oims_invoices_stg
    WHERE STG_HDR_ID in (2407590);
   
BEGIN
  FOR i IN c_oims_hdr
  LOOP
    l_message       := '';
    l_processed     := '';
    lv_return_status:='';
    lv_return_msg   :='';
	
	
	--Close the exception in exception table
	UPDATE xxgil_oims_exceptions_stg
	SET
		exception_closed_date = sysdate,
		closed_by = - 1,
		last_update_date = sysdate,
		last_updated_by = - 1,
		manually_released = 'Y',
		last_update_login = - 1
	WHERE
		stg_hdr_id = i.STG_HDR_ID
		and exception_closed_date is null;	
		
	dbms_output.put_line(' Open exceptions are closed ....' );
	
	
	-- Status CHANGE	
    UPDATE xxgil_oims_invoices_stg
    SET invoice_status = 'EBS-PAID',
      owner_id         = NULL,
      owner            = NULL
    WHERE stg_hdr_id   = i.STG_HDR_ID;
	
	dbms_output.put_line('Status Changed to EBS-PAID and Release to AP ....' );
		

    xxgil_oims_comm_utils_pkg.log_audit_event ( p_stg_hdr_id => i.STG_HDR_ID, p_stg_line_id => NULL, p_audit_event_type => 'INV_STATUS_CHANGE', p_new_value => 'EBS-OK-TO-PAY', p_old_value => i.invoice_status, p_manaully_release => NULL, p_event_owner_id => NULL, p_exception_id => NULL, p_comments => 'Updated status through Data fix for : INC1264486', x_return_status => lv_return_status, x_return_msg => lv_return_msg );
	

    l_processed_count := l_processed_count+1;
  END LOOP;
  l_message :='Number of records updated in xxgil_oims_invoices_stg ' || l_processed_count ;
  DBMS_OUTPUT.put_line (l_message);
EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.put_line (SQLERRM);
END;
/
COMMIT;