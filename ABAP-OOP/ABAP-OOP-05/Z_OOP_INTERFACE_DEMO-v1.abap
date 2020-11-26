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
CLASS savings_account DEFINITION.
  PUBLIC SECTION.
    INTERFACES account.

    METHODS: constructor.
ENDCLASS .                   "account DEFINITION

*----------------------------------------------------------------------*
*       CLASS current_account IMPLEMENTATION
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


START-OF-SELECTION.
  DATA: account1 TYPE REF TO savings_account.

  CREATE OBJECT account1.
  " 初始情况下，余额balance 为0
  WRITE: account1->account~balance.

  account1->account~deposit( '120.00' ) .
  WRITE: / account1->account~balance.

  new-line.
  account1->account~withdraw( 800 ).