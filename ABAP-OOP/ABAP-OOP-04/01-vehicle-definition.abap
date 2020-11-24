REPORT  zoop_006.

*----------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: show_speed,
             accelerate IMPORTING delta TYPE i.

  PRIVATE SECTION.
    DATA: speed TYPE i.
ENDCLASS.                    "lcl_vehicle DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_vehilce IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD show_speed.
    WRITE : / me->speed.
  ENDMETHOD.                    "show_speed

  METHOD accelerate.
    me->speed = me->speed + delta.
  ENDMETHOD.                    "accelerate
ENDCLASS.                    "lcl_vehilce IMPLEMENTATION

START-OF-SELECTION.
  DATA: v1 TYPE REF TO lcl_vehicle.
  CREATE OBJECT v1.

  v1->accelerate( 80 ).
  v1->show_speed( ).