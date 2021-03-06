REPORT  zoop_006_2.

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


*----------------------------------------------------------------------*
*       CLASS lcl_car DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_car DEFINITION INHERITING FROM lcl_vehicle.
ENDCLASS.                    "lcl_car DEFINITION


START-OF-SELECTION.
  DATA: v1 TYPE REF TO lcl_car.
  CREATE OBJECT v1.

  v1->accelerate( 80 ).                                                   
  v1->show_speed( ).