*&---------------------------------------------------------------------*
*&  Include           Z_INC_VEHICLE_CLASS
*&---------------------------------------------------------------------*


*----------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.
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