*&---------------------------------------------------------------------*
*& Report  Z_OOP_01_1
*&
*&---------------------------------------------------------------------*

report  z_oop_01_1.

class book definition.
  public section.
    types: ty_price type p length 10 decimals 2.

    methods constructor importing
        title     type string
        author    type string
        publisher type string
        price     type ty_price.

    methods print_info.

  private section.
    data: title     type string,
          author    type string,
          publisher type string,
          price     type ty_price.
endclass.                    "book DEFINITION

class book implementation.
  method constructor.
    me->title = title.
    me->author = author.
    me->publisher = publisher.
    me->price = price.
  endmethod.                    "constructor

  method print_info.
    write: / 'title:', me->title,
           / 'author:', me->author,
           / 'publisher:', me->publisher,
           / 'price:',me->price.
  endmethod.                    "print_info
endclass.                    "book IMPLEMENTATION


start-of-selection.
  data: book1 type ref to book,
        book2 type ref to book.

  create object book1 exporting
    title = '窗边的小豆豆'
    author = '黑柳彻子'
    publisher = '南海出版公司'
    price = '39.5'.


  create object book2 exporting
    title = '人间失格'
    author = '太宰治'
    publisher = '作家出版社'
    price = '18.8'.

  book1->print_info( ).
  book2->print_info( ).