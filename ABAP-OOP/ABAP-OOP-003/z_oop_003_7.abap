*&---------------------------------------------------------------------*
*& Report  Z_OOP_003
*&
*&---------------------------------------------------------------------*


REPORT  z_oop_003.

CLASS lcl_vehicle_mgr DEFINITION DEFERRED.

*----------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION CREATE PRIVATE FRIENDS lcl_vehicle_mgr.
  PUBLIC SECTION.
    METHODS: accelerate IMPORTING delta TYPE i,
             show_speed.

  PRIVATE SECTION.
    DATA speed TYPE i.
ENDCLASS.                    "lcl_vehicle DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_vehicle IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD accelerate.
    me->speed = me->speed + delta.
  ENDMETHOD.                    "accelerate

  METHOD show_speed.
    WRITE: / me->speed.
  ENDMETHOD.                    "show_speed
ENDCLASS.                    "lcl_vehicle IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS lcl_vehicle_mgr DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_vehicle_mgr DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_instance 
      RETURNING value(ref_vehicle) TYPE REF TO lcl_vehicle.
  PRIVATE SECTION.
    CLASS-DATA: vehicle_obj TYPE REF TO lcl_vehicle.
ENDCLASS.                    "lcl_vehicle_mgr DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_vehicle_mgr IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_vehicle_mgr IMPLEMENTATION.
  METHOD get_instance.
    IF vehicle_obj IS NOT BOUND.
      CREATE OBJECT vehicle_obj.
    ENDIF.
    ref_vehicle = vehicle_obj.
  ENDMETHOD.                    "create
ENDCLASS.                    "lcl_vehicle_mgr IMPLEMENTATION


START-OF-SELECTION.
  DATA: vehicle1 TYPE REF TO lcl_vehicle,
        vehicle2 TYPE REF TO lcl_vehicle.

  vehicle1 = lcl_vehicle_mgr=>get_instance( ).
  vehicle1->accelerate( 35 ).
  vehicle1->show_speed( ).

  vehicle2 = lcl_vehicle_mgr=>get_instance( ).
  vehicle2->accelerate( 20 ).
  vehicle2->show_speed( ).

  vehicle1->show_speed( ).