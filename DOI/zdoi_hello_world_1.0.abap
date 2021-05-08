*&---------------------------------------------------------------------*
*& Report  ZDOI_HELLO
*&
*&---------------------------------------------------------------------*
*& Written by Stone Wang
*& Version: 1.0
*& Dec. 16, 2016
*&---------------------------------------------------------------------*

report  zdoi_hello.

type-pools: soi.

data: gr_container type ref to cl_gui_container,
      gr_control type ref to i_oi_container_control,
      gr_document type ref to i_oi_document_proxy,
      gr_spreadsheet type ref to i_oi_spreadsheet.

start-of-selection.
  perform main.

*&---------------------------------------------------------------------*
*&      Form  get_container
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_container.
  gr_container = gr_container = cl_gui_container=>screen0.
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
      parent                   = gr_container.
endform.                    "create_container_control

*&---------------------------------------------------------------------*
*&      Form  create_excel_document
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form create_excel_document.
  call method gr_control->get_document_proxy
    exporting
      document_type  = 'Excel.Sheet'
      no_flush       = 'X'
    importing
      document_proxy = gr_document.

  call method gr_document->create_document
    exporting
      document_title = 'DOI test by Stone Wang '
      no_flush       = 'X '
      open_inplace   = 'X'.
endform.                    "create_excel_document

*&---------------------------------------------------------------------*
*&      Form  create_basic_objects
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form main.
  skip 1.

  perform get_container.
  perform create_container_control.
  perform create_excel_document.
endform.