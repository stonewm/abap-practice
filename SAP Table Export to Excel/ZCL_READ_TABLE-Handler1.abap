
METHOD if_http_extension~handle_request.
  DATA: lv_verb      TYPE string,
        url          TYPE string,
        path         TYPE string,
        query_string TYPE string.
        
  DATA: t_ska1 TYPE STANDARD TABLE OF ska1.
  
  DATA: serializer   TYPE REF TO zcl_trex_json_serializer,
        deserializer TYPE REF TO zcl_trex_json_deserializer,
        lv_json      TYPE string.

  lv_json = '{"error": "Not implemented"}'.

  lv_verb = server->request->get_header_field( '~request_method' ).
  url     = server->request->get_header_field( '~request_uri' ).

  path = url.

  IF lv_verb = 'GET' AND path = '/sap/ztables/ska1'.
    SELECT * FROM ska1 INTO CORRESPONDING FIELDS OF TABLE t_ska1
      WHERE ktopl = 'Z900'.

    CREATE OBJECT serializer
      EXPORTING
        DATA   = t_ska1[] .

    serializer->serialize( ).
    lv_json = serializer->get_data( ).
  ENDIF.

  server->response->set_status( code = 200 reason = 'OK' ).
  server->response->set_content_type( 'application/json' ).
  server->response->set_cdata( lv_json ).

ENDMETHOD. 
