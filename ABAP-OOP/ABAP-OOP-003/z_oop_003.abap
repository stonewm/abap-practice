*&---------------------------------------------------------------------*
*& Report  Z_OOP_003
*&
*&---------------------------------------------------------------------*


REPORT  z_oop_003.

INCLUDE z_inc_vehicle_class.

START-OF-SELECTION.
  DATA: vehicle1 TYPE REF TO lcl_vehicle,
        vehicle2 TYPE REF TO lcl_vehicle.

  CREATE OBJECT vehicle1.
  vehicle1->accelerate( 35 ).
  vehicle1->show_speed( ).

  CREATE OBJECT vehicle2.
  vehicle2->accelerate( 40 ).
  vehicle2->show_speed( ).