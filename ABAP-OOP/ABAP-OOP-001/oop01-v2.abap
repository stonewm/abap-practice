*&---------------------------------------------------------------------*
*& Report  Z_OOP_01
*&
*&---------------------------------------------------------------------*

REPORT  z_oop_01.

*----------------------------------------------------------------------*
*       CLASS book DEFINITION
*----------------------------------------------------------------------*
CLASS book DEFINITION.

  PUBLIC SECTION.
    TYPES: ty_price TYPE p LENGTH 10 DECIMALS 2.

    METHODS:
      constructor IMPORTING title     TYPE string
                            author    TYPE string
                            publisher TYPE string
                            price     TYPE ty_price,

      set_price IMPORTING new_price TYPE ty_price,
      print_info.

  PRIVATE SECTION.
    DATA: title     TYPE string,
          author    TYPE string,
          publisher TYPE string,
          price     TYPE p DECIMALS 2.
ENDCLASS.                    "book DEFINITION

*----------------------------------------------------------------------*
*       CLASS book IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS book IMPLEMENTATION.

  METHOD constructor.
    me->title = title.
    me->author = author.
    me->publisher = publisher.
    me->price = price.
  ENDMETHOD.                    "constructor

  METHOD set_price.
    me->price = new_price.
  ENDMETHOD.                    "set_price

  METHOD print_info.
    WRITE: / 'Title:', title.
    WRITE: / 'Author:', author.
    WRITE: / 'Publisher:', publisher.
    WRITE: / 'Price:', price.
  ENDMETHOD.                    "print_info

ENDCLASS.                    "Book IMPLEMENTATION


START-OF-SELECTION.
  DATA: book1 TYPE REF TO book,
        book2 TYPE REF TO book.

  CREATE OBJECT book1
    EXPORTING title     = '窗边的小豆豆'
              author    = '黑柳彻子'
              publisher = '南海出版公司'
              price = '39.5'.

  CREATE OBJECT book2
    EXPORTING title     = '人间失格'
              author    = '太宰治'
              publisher = '作家出版社'
              price = '18.8'.

  book1->print_info( ).

  book2->set_price( '22.0' ).
  book2->print_info( ).