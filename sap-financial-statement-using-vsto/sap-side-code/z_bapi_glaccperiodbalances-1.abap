function z_bapi_glaccperiodbalances.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(COMPANYCODE) TYPE  ZGLACCBALANCE-COMP_CODE
*"     VALUE(FISCALYEAR) TYPE  ZGLACCBALANCE-FISC_YEAR
*"     VALUE(FIS_PERIOD) TYPE  ZGLACCBALANCE-FIS_PERIOD
*"  TABLES
*"      ACCOUNT_BALANCES STRUCTURE  ZGLACCBALANCE
*"----------------------------------------------------------------------

  " 公司代码所有会计科目
  data: begin of lt_skb1 occurs 0,
          saknr like skb1-saknr,
        end of lt_skb1.

  data: lt_balance  type standard table of bapi1028_4 with header line,"单个科目调用BAPI返回值
        lt_balances type standard table of bapi1028_4 with header line."所有科目的发生额和余额

  data: lt_all     like standard table of account_balances with header line, " balances for all acocunts
        lt_per01   like standard table of account_balances with header line, " balances for period 01
        lt_current like standard table of account_balances with header line. " balances for current period


  data: lv_waers type waers.
  select single waers into lv_waers
   from  t001
  where  bukrs eq companycode.

  " 获取公司代码的所有科目
  select saknr into table lt_skb1
    from skb1
   where bukrs eq companycode.

  sort lt_skb1.

  " 依次调用BAPI获取科目余额
  loop at lt_skb1.
    clear lt_balance.
    call function 'BAPI_GL_GETGLACCPERIODBALANCES'
      exporting
        companycode      = companycode
        glacct           = lt_skb1-saknr
        fiscalyear       = fiscalyear
        currencytype     = '10'
      tables
        account_balances = lt_balance[].

    " 保留当期数据和01期数据,保留01期数据计算年初余额
    delete lt_balance where fis_period ne fis_period and fis_period ne '01'.
    if not lt_balance[] is initial.
      append lines of lt_balance to lt_balances.
    endif.
  endloop.

  " 期末余额赋值给 lt_all_bal
  loop at lt_balances.
    move-corresponding lt_balances to lt_all.
    append lt_all.
    clear lt_all.
  endloop.

  loop at lt_all.
    lt_all-curr = lv_waers.
    lt_all-open_balance = lt_all-balance - lt_all-credit_per - lt_all-debits_per. " 期初余额
    lt_all-per_amt = lt_all-debits_per + lt_all-credit_per. " 借方和贷方发生额合计
    modify lt_all.
  endloop.

  " 将01期数据和当期数据分开
  loop at lt_all.
    if lt_all-fis_period = '01'.
      append lt_all to lt_per01[].
    else.
      append lt_all to lt_current[].
    endif.
  endloop.

  loop at lt_current.
    read table lt_per01 with key gl_account = lt_current-gl_account.
    if sy-subrc is initial.
      lt_current-yr_beginbal = lt_per01-open_balance.
      modify lt_current.
    endif.
  endloop.

  account_balances[] = lt_current[].
endfunction.