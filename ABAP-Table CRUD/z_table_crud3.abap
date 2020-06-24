
DATA: gs_emp LIKE zemployee1.

CLEAR gs_emp.
gs_emp-empid = '003'.
gs_emp-empname = 'Stone Wang'.
gs_emp-empaddr = 'Wuhan'.

update zemployee1 FROM gs_emp.

IF sy-subrc IS INITIAL.
  WRITE sy-dbcnt.
ELSE.
  WRITE 'Error'.
ENDIF.