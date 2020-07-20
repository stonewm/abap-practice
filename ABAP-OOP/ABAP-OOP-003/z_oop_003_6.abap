REPORT  z_oop_003.

* class defintion
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
    WRITE: / output.
  ENDMETHOD.                    "show_speed
ENDCLASS.                    "lcl_vehicle IMPLEMENTATION


START-OF-SELECTION.
  DATA: vehicle     TYPE REF TO lcl_vehicle,
        vehicle_tab TYPE TABLE OF REF TO lcl_vehicle,
        speed       TYPE i.

  speed = 10.
  DO 5 TIMES.
    CREATE OBJECT vehicle.
    vehicle->accelerate( speed ).
    APPEND vehicle TO vehicle_tab.

    speed = speed + 10.
  ENDDO.

  LOOP AT vehicle_tab INTO vehicle.
    vehicle->show_speed( ).
  ENDLOOP.