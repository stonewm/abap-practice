DATA:   bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE. " BDC执行参数
DATA:   messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE. " BDC返回的消息
TABLES: t100.


*----------------------------------------------------------------------*
*        Start new transaction according to parameters                 *
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode ctumode TYPE mode.

  DATA: l_mstring(480).
  DATA: l_subrc LIKE sy-subrc.


  REFRESH messtab.
  CALL TRANSACTION tcode USING bdcdata
                   MODE   ctumode     
                   UPDATE 'A'         " A同步，B异步
                   MESSAGES INTO messtab.

  l_subrc = sy-subrc.
  WRITE: / 'CALL_TRANSACTION',
           tcode,
           'returncode:'(i05),
           l_subrc,
           'RECORD:',
           sy-index.

  LOOP AT messtab.
    SELECT SINGLE * FROM t100 WHERE sprsl = messtab-msgspra
                              AND   arbgb = messtab-msgid
                              AND   msgnr = messtab-msgnr.
    IF sy-subrc = 0.
      l_mstring = t100-text.
      IF l_mstring CS '&1'.
        REPLACE '&1' WITH messtab-msgv1 INTO l_mstring.
        REPLACE '&2' WITH messtab-msgv2 INTO l_mstring.
        REPLACE '&3' WITH messtab-msgv3 INTO l_mstring.
        REPLACE '&4' WITH messtab-msgv4 INTO l_mstring.
      ELSE.
        REPLACE '&' WITH messtab-msgv1 INTO l_mstring.
        REPLACE '&' WITH messtab-msgv2 INTO l_mstring.
        REPLACE '&' WITH messtab-msgv3 INTO l_mstring.
        REPLACE '&' WITH messtab-msgv4 INTO l_mstring.
      ENDIF.

      CONDENSE l_mstring.
      WRITE: / messtab-msgtyp, l_mstring(250).
    ELSE.
      WRITE: / messtab.
    ENDIF.

  ENDLOOP.
  REFRESH bdcdata.
ENDFORM.                    "BDC_TRANSACTION

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
ENDFORM.                    "BDC_FIELD