*&---------------------------------------------------------------------*
*& Report  Z_FALV_010
*&
*&---------------------------------------------------------------------*
*& reference: http://saptechnical.com/Tutorials/ALV/Edit/demo.htm
*&
*&---------------------------------------------------------------------*

report  z_falv_010.


type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv,
      gs_fieldcat type slis_fieldcat_alv.

data: gt_index   type standard table of i with header line,
      table_name like dd02l-tabname.

data: report_id like sy-repid.

data: dy_table   type ref to data,
      dy_temptab type ref to data, " temporary table for saving to db
      dy_line    type ref to data.

field-symbols: <dyn_table>    type standard table,
               <dyn_wa>       type any,
               <dyn_field>    type any,
               <dyn_tab_temp> type standard table.

*------------------------------------------------------
* Screen
*------------------------------------------------------
parameters: p_tab(30) type c obligatory, " table name
            p_cri     type string.       " criteria

*------------------------------------------------------
* Events
*------------------------------------------------------
start-of-selection.
  report_id = sy-repid.
  table_name = p_tab. " table name

  perform frm_check_if_table_exists using table_name.
  perform frm_get_data.
  perform frm_disp_data.


*&---------------------------------------------------------------------*
*&      Form  frm_check_if_table_exists
*&---------------------------------------------------------------------*
form frm_check_if_table_exists using p_tabname like dd02l-tabname.
  data: l_tabname like dd02l-tabname.
  select single tabname from dd02l into l_tabname
    where tabname = table_name.

  if not sy-subrc is initial.
    message ' No table was found.' type 'E'.
    leave program.
  endif.
endform.                    "frm_check_if_table_exists

*&---------------------------------------------------------------------*
*&      Form  frm_get_data
*&---------------------------------------------------------------------*
form frm_get_data.
  " Create internal table dynamically from table name input in selection screen
  create data dy_table type standard table of (table_name).
  assign dy_table->* to <dyn_table>.

  " Create another temporary table
  create data dy_temptab type standard table of (table_name).
  assign dy_temptab->* to <dyn_tab_temp>.

  " Create work area for the table
  create data dy_line like line of <dyn_table>.
  assign dy_line->* to <dyn_wa>.

  select * from (table_name) into table <dyn_table>
    where (p_cri).

  refresh <dyn_tab_temp>.
endform.                    "frm_get_data


*&---------------------------------------------------------------------*
*&      Form  frm_disp_data
*&---------------------------------------------------------------------*
form frm_disp_data.
  sort gt_fieldcat by col_pos.

  " Display table in ALV
  call function 'REUSE_ALV_LIST_DISPLAY'
    exporting
      i_callback_program       = report_id
      i_structure_name         = table_name
      i_callback_user_command  = 'FRM_USER_COMMAND'
      i_callback_pf_status_set = 'FRM_SET_PF_STATUS'
    tables
      t_outtab                 = <dyn_table>
    exceptions
      program_error            = 1
      others                   = 2.
endform.                    "frm_disp_data


*&---------------------------------------------------------------------*
*&      Form  frm_set_pf_status
*&---------------------------------------------------------------------*
form frm_set_pf_status using rt_extab type slis_t_extab.
  set pf-status 'Z_STANDARD'.
endform.                    "SET_PF_STATUS


*&---------------------------------------------------------------------*
*&      Form  frm_user_command
*&---------------------------------------------------------------------*
form frm_user_command using r_ucomm     like sy-ucomm
                            rs_selfield type slis_selfield.

  data: li_tab type ref to data,
        l_line type ref to data.


  field-symbols:<l_tab> type table,
                <l_wa>  type any.

  " Create table
  create data li_tab type standard table of (table_name).
  assign li_tab->* to <l_tab>.

  " Create work area
  create data l_line like line of <l_tab>.
  assign l_line->* to <l_wa>.

  case r_ucomm.
      " When a record is selected
    when '&IC1'.
      " Read the selected record
      read table <dyn_table> assigning <dyn_wa> index rs_selfield-tabindex.
      if sy-subrc = 0.
        " Store the record in an internal table
        append <dyn_wa> to <l_tab>.

        " Fetch the field catalog info
        call function 'REUSE_ALV_FIELDCATALOG_MERGE'
          exporting
            i_program_name         = report_id
            i_structure_name       = table_name
          changing
            ct_fieldcat            = gt_fieldcat
          exceptions
            inconsistent_interface = 1
            program_error          = 2
            others                 = 3.
        if sy-subrc = 0.
          " Make all the fields input enabled except key fields
          gs_fieldcat-input = 'X'.
          modify gt_fieldcat from gs_fieldcat transporting input
          where key is initial.
        endif.

        " Display the record for editing purpose
        call function 'REUSE_ALV_LIST_DISPLAY'
          exporting
            i_callback_program    = report_id
            i_structure_name      = table_name
            it_fieldcat           = gt_fieldcat
            i_screen_start_column = 10
            i_screen_start_line   = 15
            i_screen_end_column   = 200
            i_screen_end_line     = 20
          tables
            t_outtab              = <l_tab>
          exceptions
            program_error         = 1
            others                = 2.

        if sy-subrc = 0.
          " Read the modified data
          read table <l_tab> index 1 into <l_wa>.

          " If the record is changed then track its index no.
          " and populate it in an internal table for future action
          if sy-subrc = 0 and <dyn_wa> <> <l_wa>.
            <dyn_wa> = <l_wa>.
            gt_index = rs_selfield-tabindex.
            append gt_index.
          endif.
        endif.
      endif.

    when 'SAVE'.
      " Sort the index table
      sort gt_index.

      " Delete all duplicate records
      delete adjacent duplicates from gt_index.

      loop at gt_index.
        " Find out the changes in the internal table
        " and populate these changes in another internal table
        read table <dyn_table> assigning <dyn_wa> index gt_index.
        if sy-subrc = 0.
          append <dyn_wa> to <dyn_tab_temp>.
        endif.
      endloop.

      " Lock the table
      call function 'ENQUEUE_E_TABLE'
        exporting
          mode_rstable   = 'E'
          tabname        = table_name
        exceptions
          foreign_lock   = 1
          system_failure = 2
          others         = 3.      
      
      if sy-subrc = 0.
        " Modify the database table with the changes
        modify (table_name) from table <dyn_tab_temp>.
        refresh <dyn_tab_temp>.

        " Unlock the table
        call function 'DEQUEUE_E_TABLE'
          exporting
            mode_rstable = 'E'
            tabname      = table_name.

        message 'Data was saved successfully' type 'S'.
      endif.
  endcase.

  rs_selfield-refresh = 'X'.
endform.                    "user_command