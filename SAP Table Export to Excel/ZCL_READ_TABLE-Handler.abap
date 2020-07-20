
METHOD if_http_extension~handle_request.
    DATA: lv_verb      TYPE string,
          url          TYPE string,
          path         TYPE string,
          query_string TYPE string.
  
    DATA: table_name   TYPE string,
          table_key    TYPE string.
  
  
    DATA: tabledescr_ref TYPE REF TO cl_abap_tabledescr,
          descr_ref      TYPE REF TO cl_abap_structdescr,
          comp_descr     TYPE        abap_compdescr.
  
    DATA dref TYPE REF TO data.
    FIELD-SYMBOLS <fs> TYPE STANDARD TABLE.
  
    DATA: req_json TYPE string.
  
    DATA: serializer   TYPE REF TO zcl_trex_json_serializer,
          deserializer TYPE REF TO zcl_trex_json_deserializer,
          lv_json      TYPE string.
  
    lv_json = '{"error": "Not implemented"}'.
  
    lv_verb = server->request->get_header_field( '~request_method' ).
    url     = server->request->get_header_field( '~request_uri' ).
    SPLIT url AT '?' INTO path query_string.
    SPLIT query_string AT '=' INTO table_key table_name.
  
    lv_json = table_name.
  
    IF lv_verb = 'GET' AND path = '/sap/ztables'.
  
      CREATE DATA dref TYPE STANDARD TABLE OF (table_name).
      ASSIGN dref->* TO <fs>.
  
      tabledescr_ref ?= cl_abap_typedescr=>describe_by_data( <fs> ).
      descr_ref ?= tabledescr_ref->get_table_line_type( ).
  
      SELECT * FROM (table_name) INTO TABLE <fs>.
  
      CREATE OBJECT serializer
        EXPORTING
          DATA   = <fs> .
  
      serializer->serialize( ).
      lv_json = serializer->get_data( ).
    ENDIF.
  
    server->response->set_status( code = 200 reason = 'OK' ).
    server->response->set_content_type( 'application/json' ).
    server->response->set_cdata( lv_json ).
  
  ENDMETHOD.