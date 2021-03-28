*&---------------------------------------------------------------------*
*& Report  Z_OOP_INTERFACE_DEMO
*& developed by Stone Wang (2020/11/26)
*&---------------------------------------------------------------------*


REPORT  z_oop_interface_demo.

*----------------------------------------------------------------------*
*       INTERFACE account
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
INTERFACE account.
  DATA: balance TYPE f.
  METHODS: deposit IMPORTING amount TYPE f,
           withdraw IMPORTING amount TYPE f.
ENDINTERFACE.                    "account

*----------------------------------------------------------------------*
*       CLASS current_account DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS savings_account DEFINITION.
  PUBLIC SECTION.
    INTERFACES account.

    METHODS: constructor.
ENDCLASS .                   "account DEFINITION

*----------------------------------------------------------------------*
*       CLASS current_account IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS savings_account IMPLEMENTATION.

  METHOD constructor.
    account~balance = 0.
  ENDMETHOD.                    "constructor

  METHOD account~deposit.
    account~balance = account~balance + amount.
  ENDMETHOD.                    "account~deposit

  METHOD account~withdraw.
    IF account~balance >= amount.
      account~balance = account~balance - amount.
    ELSE.
      WRITE 'You cannot withdraw amount greater than balance.'.
    ENDIF.
  ENDMETHOD.                    "account~withdraw

ENDCLASS.                    "current_account DEFINITION


*----------------------------------------------------------------------*
*       CLASS credit_account DEFINITION
*----------------------------------------------------------------------*
CLASS credit_account DEFINITION.
  PUBLIC SECTION.
    INTERFACES account.

    METHODS: constructor.
ENDCLASS.                    "credit_account DEFINITION


*----------------------------------------------------------------------*
*       CLASS credit_account IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS credit_account IMPLEMENTATION.
  METHOD constructor.
    account~balance = 0.
  ENDMETHOD.                    "constructor

  METHOD account~deposit.
    account~balance = account~balance + amount.
  ENDMETHOD.                    "deposit

  METHOD account~withdraw.
    account~balance = account~balance - amount.
  ENDMETHOD.                    "withdraw
ENDCLASS .                   "credit_account IMPLEMENTATION


START-OF-SELECTION.
  DATA: account1 TYPE REF TO savings_account,
        account2 TYPE REF TO credit_account.

  DATA: acc1 TYPE REF TO account,
        acc2 TYPE REF TO account.

  CREATE OBJECT account1.
  CREATE OBJECT account2.

  acc1 = account1.
  WRITE: acc1->balance.

  acc1->deposit( '120.00' ) .
  WRITE: / acc1->balance.

  acc2 = account2.
  acc2->withdraw( 800 ).
  WRITE :/ acc2->balance.