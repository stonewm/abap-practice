
REPORT  z_oop_003.

* Class defintion
CLASS lcl_vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: accelerate IMPORTING delta TYPE i,
             show_speed.

  PRIVATE SECTION.
    DATA speed TYPE i.
ENDCLASS.                    "lcl_vehicle DEFINITION

* Class implementation
CLASS lcl_vehicle IMPLEMENTATION.
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
  DATA: vehicle1 TYPE REF TO lcl_vehicle,
        vehicle2 TYPE REF TO lcl_vehicle.

  CREATE OBJECT vehicle1.
  vehicle2 = vehicle1.

  vehicle1->accelerate( 35 ).
  vehicle2->accelerate( 5 ).

  vehicle1->show_speed( ).
  vehicle1->show_speed( ).