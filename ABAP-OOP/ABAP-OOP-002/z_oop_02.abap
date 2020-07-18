
REPORT  z_oop_002.

CLASS lcl_math DEFINITION.
  PUBLIC SECTION.
    TYPES: ty_double TYPE p LENGTH 10 DECIMALS 2.
    CLASS-DATA pi TYPE p LENGTH 10 DECIMALS 7 VALUE '3.1415926'.

    CLASS-METHODS: pow IMPORTING x TYPE ty_double
                                 y TYPE ty_double
                       RETURNING value(pow_value) TYPE ty_double.
ENDCLASS. 

CLASS lcl_math IMPLEMENTATION.
  METHOD pow.
    pow_value = x ** y.
  ENDMETHOD.                   
ENDCLASS.                    

START-OF-SELECTION.
  DATA: result TYPE p DECIMALS 2.

  CALL METHOD lcl_math=>pow
    EXPORTING
      x         = 25
      y         = 3
    RECEIVING
      pow_value = result.

  WRITE: / lcl_math=>pi LEFT-JUSTIFIED,
         / result LEFT-JUSTIFIED .