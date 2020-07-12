
REPORT  z_oop_01.

CLASS book DEFINITION.

  PUBLIC SECTION.
    TYPES: ty_price TYPE p LENGTH 10 DECIMALS 2.

    DATA: title     TYPE string,
          author    TYPE string,
          publisher TYPE string,
          price     TYPE p DECIMALS 2.

    METHODS:
      print_info.
ENDCLASS.                    "lcl_book DEFINITION


CLASS book IMPLEMENTATION.

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

  CREATE OBJECT book1.

  book1->title = '窗边的小豆豆'.
  book1->author = '黑柳彻子'.
  book1->publisher = '南海出版公司'.
  book1->price = '39.5'.

  CREATE OBJECT book2.

  book2->title = '人间失格'.
  book2->author = '太宰治'.
  book2->publisher = '作家出版社'.
  book2->price = '18.8'.

  book1->print_info( ).
  book2->print_info( ).