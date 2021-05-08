*&---------------------------------------------------------------------*
*& Report  ZDOI_WRITE_SINGLE_CELL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zdoi_write_single_cell.

type-pools: soi, sbdst.

* desktop office integration interface
data: gr_container type ref to cl_gui_container,
      gr_control type ref to i_oi_container_control,
      gr_document type ref to i_oi_document_proxy,
      gr_spreadsheet type ref to i_oi_spreadsheet,
      gr_error type ref to i_oi_error.

* business document system
data: gr_bds_documents type ref to cl_bds_document_set,
      g_classname type sbdst_classname value 'HRFPM_EXCEL_STANDARD',
      g_classtype type sbdst_classtype value 'OT',
      g_objectkey type sbdst_object_key value 'DOITEST',
      g_doc_components type sbdst_components,
      g_doc_signature type sbdst_signature.

* template uri
data: gt_bds_uris type sbdst_uri,
      gs_bds_uri like line of gt_bds_uris,
      g_template_uri(256) type c.

* Required for writing to Excel
data: gt_ranges type soi_range_list,
      gs_range like line of gt_ranges,
      gt_contents type soi_generic_table,
      gs_content type soi_generic_item.

* output internale table
data: begin of gs_spfli,
        carrid like spfli-carrid,
        connid like spfli-connid,
        cityfrom like spfli-cityfrom,
        cityto like spfli-cityto,
      end of gs_spfli.
data: gt_spfli like standard table of gs_spfli.


start-of-selection.
  perform get_data.
  perform create_basic_objects.
  perform get_template_url.
  perform open_document.
  perform write_data_to_excel.


*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_data.
  select * from spfli
    into corresponding fields of table gt_spfli.
endform.                    "get_data

*&---------------------------------------------------------------------*
*&      Form  create_basic_objects
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form create_basic_objects.
  skip 1.

* check GUI ActiveX support
  data: has_activex type c.
  call function 'GUI_HAS_ACTIVEX'
    importing
      return = has_activex.

  if has_activex is initial.
    message e007(demoofficeintegratio).
  endif.

  perform get_container.
  perform create_container_control.

* Use this method to dispatch application events
* to the event handlers registered for the events.
  call method cl_gui_cfw=>dispatch.
endform.                    "create_basic_objects

*&---------------------------------------------------------------------*
*&      Form  get_coantainer
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_container.
  gr_container = gr_container = cl_gui_container=>screen0.
endform.                    "get_coantainer


*&---------------------------------------------------------------------*
*&      Form  create_container_control
*&---------------------------------------------------------------------*
*       create container control and initialize
*----------------------------------------------------------------------*
form create_container_control.
* create container control
  call method c_oi_container_control_creator=>get_container_control
    importing
      control = gr_control.

* initialize control
  call method gr_control->init_control
    exporting
      inplace_enabled     = 'X '
      no_flush            = 'X '
      r3_application_name = 'DOI demo'
      parent              = gr_container.
endform.                    "create_container_control

*&---------------------------------------------------------------------*
*&      Form  get_template_url
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_template_url.

  create object gr_bds_documents.

  call method cl_bds_document_set=>get_info
    exporting
      classname  = g_classname
      classtype  = g_classtype
      object_key = g_objectkey
    changing
      components = g_doc_components
      signature  = g_doc_signature.

  call method cl_bds_document_set=>get_with_url
    exporting
      classname  = g_classname
      classtype  = g_classtype
      object_key = g_objectkey
    changing
      uris       = gt_bds_uris
      signature  = g_doc_signature.

  free gr_bds_documents.

  read table gt_bds_uris into gs_bds_uri index 1.
  g_template_uri = gs_bds_uri-uri.
endform.                    "get_template_url

*&---------------------------------------------------------------------*
*&      Form  open_document
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form open_document.
  call method gr_control->get_document_proxy
    exporting
      document_type      = 'Excel.Sheet'
      no_flush           = 'X'
      register_container = 'X'
    importing
      document_proxy     = gr_document.

  call method gr_document->open_document
    exporting
      open_inplace = 'X'
      document_url = g_template_uri.

  data: available type i.
  call method gr_document->has_spreadsheet_interface
    exporting
      no_flush     = 'X'
    importing
      is_available = available.

  call method gr_document->get_spreadsheet_interface
    exporting
      no_flush        = 'X'
    importing
      sheet_interface = gr_spreadsheet.

  call method gr_spreadsheet->select_sheet
    exporting
      name     = 'Sheet1'
      no_flush = 'X'.
endform.                    "open_document


*&---------------------------------------------------------------------*
*&      Form  write_cell_value
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->ROW        row index
*      -->COL        column index
*      -->VAL        value
*----------------------------------------------------------------------*
form write_cell_value using row col val.
  data: lt_ranges type soi_range_list,
        ls_rangeitem type soi_range_item,
        lt_contents type soi_generic_table,
        ls_content type soi_generic_item.

  clear ls_rangeitem.
  clear lt_ranges[].
  ls_rangeitem-name = 'cell' .
  ls_rangeitem-columns = 1.
  ls_rangeitem-rows = 1.
  ls_rangeitem-code = 4.
  append ls_rangeitem to lt_ranges.

  clear ls_content.
  clear lt_contents[].
  ls_content-column = 1.
  ls_content-row = 1.
  ls_content-value = val.
  append ls_content to lt_contents.

* 每次只写一行一列
  call method gr_spreadsheet->insert_range_dim
    exporting
      name     = 'cell'
      no_flush = 'X'
      top      = row
      left     = col
      rows     = 1
      columns  = 1 .

    call method gr_spreadsheet->set_ranges_data
    exporting
      ranges   = lt_ranges
      contents = lt_contents
      no_flush = 'X' .
endform.                    "write_cell_value

*&---------------------------------------------------------------------*
*&      Form  write_data_to_excel
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form write_data_to_excel .
  data: row_index type i value 1.

  check not gt_spfli is initial.

  loop at gt_spfli into gs_spfli.
    perform write_cell_value using row_index 1 gs_spfli-carrid.
    perform write_cell_value using row_index 2 gs_spfli-connid.
    perform write_cell_value using row_index 3 gs_spfli-cityfrom.
    perform write_cell_value using row_index 4 gs_spfli-cityto.
    clear gs_spfli.

    row_index = row_index + 1.
  endloop.

endform.                    " write_data_to_excel