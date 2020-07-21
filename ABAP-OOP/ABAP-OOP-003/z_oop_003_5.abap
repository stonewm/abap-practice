REPORT  z_oop_003.

* class using agent
CLASS lcl_vehicle_agent DEFINITION DEFERRED.
* class defintion
CLASS lcl_vehicle DEFINITION CREATE PRIVATE FRIENDS lcl_vehicle_agent.
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


* CLASS lcl_vehicle_agent DEFINITION
CLASS lcl_vehicle_agent DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS create RETURNING value(ref_vehicle) TYPE REF TO lcl_vehicle.
ENDCLASS.                    "lcl_vehicle_agent DEFINITION

* CLASS lcl_vehicle_agent IMPLEMENTATION
CLASS lcl_vehicle_agent IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT ref_vehicle.
  ENDMETHOD.                    "create
ENDCLASS.                    "lcl_vehicle_agent IMPLEMENTATION


START-OF-SELECTION.
  DATA: vehicle1 TYPE REF TO lcl_vehicle.

  vehicle1 = lcl_vehicle_agent=>create( ).
  vehicle1->accelerate( 35 ).
  vehicle1->show_speed( ).