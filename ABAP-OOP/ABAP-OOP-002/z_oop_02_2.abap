REPORT  z_oop_02_2.

*----------------------------------------------------------------------*
*       CLASS lcl_student DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_student DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING sid           TYPE string
                                   name          TYPE string
                                   age           TYPE int2
                                   current_class TYPE string.

    METHODS: set_age   IMPORTING new_age   TYPE int2,
             set_class IMPORTING new_class TYPE string,
             to_string RETURNING value(rv) TYPE string .


  PRIVATE SECTION.
    DATA: sid           TYPE string,
          name          TYPE string,
          age           TYPE int2,
          current_class TYPE string.
ENDCLASS.                    "lcl_student DEFINITION

CLASS lcl_student IMPLEMENTATION.
  METHOD constructor.
    me->sid = sid.
    me->name = name.
    me->age = age.
    me->current_class = current_class.
  ENDMETHOD.                    "constructor

  METHOD set_age.
    me->age = new_age.
  ENDMETHOD.                    "set_age

  METHOD set_class.
    me->current_class = new_class.
  ENDMETHOD.                    "set_class

  METHOD to_string.
    DATA: result TYPE string.
    data: age_str type string.

    age_str = me->age.

    CONCATENATE '<Student: (ID:' me->sid ',Name:' me->name ',Age:' age_str ',Class:' me->current_class ')>'
      INTO result.

    rv = result.
  ENDMETHOD.                    "to_string
ENDCLASS.                    "lcl_student IMPLEMENTATION


START-OF-SELECTION.
  DATA: s1 TYPE REF TO lcl_student.

  DATA: stu_info TYPE string.

  CREATE OBJECT s1 EXPORTING sid = '001'
                             name = '小王'
                             age = 15
                             current_class = '高一(5)班'.

  CALL METHOD s1->set_age
    EXPORTING
      new_age = 16.

  CALL METHOD s1->set_class
    EXPORTING
      new_class = '高二(5)班'.

  call method s1->to_string
    receiving rv = stu_info.

  write: / stu_info.