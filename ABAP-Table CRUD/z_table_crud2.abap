REPORT  z_table_crud.

CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
  EXPORTING
    action                               = 'U'
    view_name                            = 'zemployee1' .

ENDIF.