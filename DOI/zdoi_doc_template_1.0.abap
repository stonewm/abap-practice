*&---------------------------------------------------------------------*
*& Report  ZDOI_DOC_TEMPLATE
*&
*&---------------------------------------------------------------------*
*&
*& Written by Stone Wang
*& Version 1.0 on Dec 16, 2016
*&---------------------------------------------------------------------*

report  zdoi_doc_template.

data: gr_custom_container type ref to cl_gui_custom_container.
data: gr_container type ref to cl_gui_container,
      gr_control type ref to i_oi_container_control,
      gr_document type ref to i_oi_document_proxy,
      gr_spreadsheet type ref to i_oi_spreadsheet.

* business document system
data: gr_bds_documents type ref to cl_bds_document_set,
      g_classname type sbdst_classname,
      g_classtype type sbdst_classtype,
      g_objectkey type sbdst_object_key,
      g_doc_components type sbdst_components,
      g_doc_signature type sbdst_signature.

* template url
data: gt_bds_uris type sbdst_uri,
      gs_bds_url like line of gt_bds_uris,
      g_template_url(256) type c.

data: ok_code type sy-ucomm,
      save_ok like ok_code.

* output internale table
data: begin of gs_spfli,
        carrid like spfli-carrid,
        connid like spfli-connid,
        cityfrom like spfli-cityfrom,
        cityto like spfli-cityto,
      end of gs_spfli.
data: gt_spfli like standard table of gs_spfli.

* Required for writing data to Excel
data: gt_ranges type soi_range_list,
      gs_range type soi_range_item,
      gt_contents type soi_generic_table,
      gs_content type soi_generic_item.

initialization.
  g_classname = 'HRFPM_EXCEL_STANDARD'.
  g_classtype = 'OT'.
  g_objectkey = 'DOITEST'.

start-of-selection.
  perform get_data.
  call screen 100.

  define write_content_cell.
    gs_content-row = &1.
    gs_content-column = &2.
    gs_content-value = &3.
    append gs_content to gt_contents.
    clear gs_content.
  end-of-definition.

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_data.
  select * from spfli
    into corresponding fields of table gt_spfli up to 5 rows.
endform.                    "get_data

*&---------------------------------------------------------------------*
*&      Form  get_container
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_container.
  create object gr_custom_container
    exporting
      container_name = 'CONTAINER1'.
endform.                    "get_container

*&---------------------------------------------------------------------*
*&      Form  create_container_control
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form create_container_control.
* create container control
  call method c_oi_container_control_creator=>get_container_control
    importing
      control = gr_control.

* initialize control
  call method gr_control->init_control
    exporting
      inplace_enabled          = 'X '
      inplace_scroll_documents = 'X'
      register_on_close_event  = 'X'
      register_on_custom_event = 'X'
      r3_application_name      = 'DOI demo by Stone Wang'
      parent                   = gr_custom_container.
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

  read table gt_bds_uris into gs_bds_url index 1.
  g_template_url = gs_bds_url-uri.
endform.                    "get_template_url

*&---------------------------------------------------------------------*
*&      Form  open_excel_doc
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form open_excel_doc.
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
      document_url = g_template_url.

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
endform.                    "open_excel_doc

*&---------------------------------------------------------------------*
*&      Form  fill_contents
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form fill_contents.
  data: row_index type i.
  row_index = 1.

  loop at gt_spfli into gs_spfli.
    clear gs_content.

    write_content_cell row_index 1 gs_spfli-carrid.
    write_content_cell row_index 2 gs_spfli-connid.
    write_content_cell row_index 3 gs_spfli-cityfrom.
    write_content_cell row_index 4 gs_spfli-cityto.

    row_index = row_index + 1.
  endloop.
endform.                    "fill_contents

*&---------------------------------------------------------------------*
*&      Form  write_data_to_excel
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form write_data_to_excel.
  check not gt_spfli is initial.

  data: line_count type i.
  describe table gt_spfli lines line_count.

* fill gt_ranges[]
  clear gs_range.
  clear gt_ranges[].
  gs_range-name = 'cell'.
  gs_range-rows = line_count.
  gs_range-columns = 4.
  gs_range-code = 4.
  append gs_range to gt_ranges.

* output itab to gt_contents

  perform fill_contents.

  call method gr_spreadsheet->insert_range_dim
    exporting
      name     = 'cell'
      no_flush = 'X'
      top      = 2
      left     = 1
      rows     = line_count
      columns  = 4.

  call method gr_spreadsheet->set_ranges_data
    exporting
      ranges   = gt_ranges
      contents = gt_contents
      no_flush = 'X'.

endform.                    "write_data_to_excel

*&---------------------------------------------------------------------*
*&      Form  release_objects
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form release_objects.
  if not gr_document is initial.
    call method gr_document->close_document.
    free gr_document.
  endif.

  if not gr_control is initial.
    call method gr_control->destroy_control.
    free gr_control.
  endif.

  if gr_container is not initial.
    call method gr_container->free.
  endif.
endform.                    "release_objects



*&---------------------------------------------------------------------*
*&      Form  main
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form main.
  perform get_container.
  perform create_container_control.
  perform get_template_url..
  perform open_excel_doc.
  perform write_data_to_excel.
endform.                    "main

*&---------------------------------------------------------------------*
*&      Module  exit_program  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module exit_program input.
  save_ok = ok_code.
  clear ok_code.

  if save_ok = 'EXIT'.
    perform release_objects.
    leave program.
  endif.
endmodule.                 " exit_program  INPUT
*&---------------------------------------------------------------------*
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0100 output.
  set pf-status '100'.
  perform main.
endmodule.                 " status_0100  OUTPUT