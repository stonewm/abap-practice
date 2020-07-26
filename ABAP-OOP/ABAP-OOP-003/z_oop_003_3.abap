*&---------------------------------------------------------------------*
*& Report  Z_OOP_003
*&
*&---------------------------------------------------------------------*


REPORT  z_oop_003.

" 类的定义和实现在include程序中
INCLUDE z_inc_vehicle_class.

START-OF-SELECTION.
  DATA: vehicle1 TYPE REF TO lcl_vehicle,
        vehicle2 TYPE REF TO lcl_vehicle.

  CREATE OBJECT vehicle1.
  vehicle1->accelerate( 35 ).
  vehicle1->show_speed( ).

  vehicle2 = vehicle1.
  vehicle1->accelerate( 5 ).

  vehicle1->show_speed( ).
  vehicle2->show_speed( ).