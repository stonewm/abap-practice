*&---------------------------------------------------------------------*
*& Report  Z_00P_01
*&
*&---------------------------------------------------------------------*

report  z_00p_01.

class book definition.
  public section.
    data: title type string,
          author type string,
          publisher type string,
          price type p decimals 2.

    methods: print_info.
endclass.                    "book DEFINITION

class book implementation.
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

  create object book1.

  book1->title = '窗边的小豆豆'.
  book1->author = '黑柳彻子'.
  book1->publisher = '南海出版公司'.
  book1->price = '39.5'.

  create object book2.

  book2->title = '人间失格'.
  book2->author = '太宰治'.
  book2->publisher = '作家出版社'.
  book2->price = '18.8'.

  book1->print_info( ).
  book2->print_info( ).