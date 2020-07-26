FUNCTION Z_SKA1_READ.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(KTOPL) TYPE  SKA1-KTOPL
*"  TABLES
*"      CONTENT STRUCTURE  SKA1
*"----------------------------------------------------------------------
  CLEAR CONTENT.
  REFRESH CONTENT.

  SELECT * FROM SKA1
    INTO CORRESPONDING FIELDS OF TABLE CONTENT
    WHERE KTOPL EQ KTOPL.

ENDFUNCTION.
