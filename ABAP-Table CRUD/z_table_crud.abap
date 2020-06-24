REPORT  z_table_crud.

DATA: gs_emp LIKE zemployee1.

CLEAR gs_emp.
gs_emp-empid = '003'.
gs_emp-empname = 'WANG'.
gs_emp-empaddr = 'Wuhan'.

INSERT zemployee1 FROM gs_emp.

IF sy-subrc IS INITIAL.
  WRITE sy-dbcnt.
ELSE.
  WRITE 'Error'.
ENDIF.