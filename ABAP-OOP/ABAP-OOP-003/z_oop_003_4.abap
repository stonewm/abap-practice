REPORT  z_oop_003.

* Class defintion
CLASS lcl_vehicle DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS create RETURNING value(ref_vehicle) TYPE REF TO lcl_vehicle.

    METHODS: accelerate IMPORTING delta TYPE i,
             show_speed.

  PRIVATE SECTION.
    DATA speed TYPE i.
ENDCLASS.                    "lcl_vehicle DEFINITION

* Class implementation
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ref_vehicle.
  ENDMETHOD.                    "create

  METHOD accelerate.
    me->speed = me->speed + delta.
  ENDMETHOD.                    "accelerate

  METHOD show_speed.
    DATA: output TYPE string.

    output = me->speed.
    MESSAGE output TYPE 'I'.
  ENDMETHOD.                    "show_speed
ENDCLASS.                    "lcl_vehicle IMPLEMENTATION

START-OF-SELECTION.
  DATA: vehicle1 TYPE REF TO lcl_vehicle.

  vehicle1 = lcl_vehicle=>create( ).
  vehicle1->accelerate( 35 ).
  vehicle1->show_speed( ).