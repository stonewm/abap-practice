function z_bapi_glaccperiodbalances.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(COMPANYCODE) TYPE  ZGLACCBALANCE-COMPCODE
*"     VALUE(FISCALYEAR) TYPE  ZGLACCBALANCE-FISYEAR
*"     VALUE(FISCALPERIOD) TYPE  ZGLACCBALANCE-PERIOD
*"  TABLES
*"      ACC_BALANCES STRUCTURE  ZGLACCBALANCE
*"----------------------------------------------------------------------

  data: begin of lt_fag occurs 0,
              bukrs like faglflext-rbukrs,  "公司代码
              ryear like faglflext-ryear,   "会计年度
              racct like faglflext-racct,   "会计科目
              drcrk like faglflext-drcrk,   "借贷方
              hslvt like faglflext-hslvt,
              hsl01 like faglflext-hsl01,
              hsl02 like faglflext-hsl02,
              hsl03 like faglflext-hsl03,
              hsl04 like faglflext-hsl04,
              hsl05 like faglflext-hsl05,
              hsl06 like faglflext-hsl06,
              hsl07 like faglflext-hsl07,
              hsl08 like faglflext-hsl08,
              hsl09 like faglflext-hsl09,
              hsl10 like faglflext-hsl10,
              hsl11 like faglflext-hsl11,
              hsl12 like faglflext-hsl12,
              hsl13 like faglflext-hsl13,
              hsl14 like faglflext-hsl14,
              hsl15 like faglflext-hsl15,
              hsl16 like faglflext-hsl16,
      end of lt_fag.

  data lt_ret like zglaccbalance occurs 0 with header line.

  field-symbols: <field>.

  data: lv_idx type i,
        lv_times type i,
        lv_int type i,
        lv_rpmax(2) type c,
        lv_fieldname type string,
        lv_hslxx like faglflext-hslvt,
        lv_waers like t001-waers,
        lv_ktopl like t001-ktopl.

  "获取公司本位币
  select single waers ktopl
    into (lv_waers,lv_ktopl)
    from t001
   where bukrs = companycode.

  select rbukrs as bukrs
         ryear racct drcrk
         hslvt
         hsl01 hsl02 hsl03 hsl04
         hsl05 hsl06 hsl07 hsl08
         hsl09 hsl10 hsl11 hsl12
         hsl13 hsl14 hsl15 hsl16
    into corresponding fields of table lt_fag
    from faglflext
   where rbukrs = companycode
     and ryear = fiscalyear.

  sort lt_fag by bukrs ryear racct drcrk.
  loop at lt_fag.
    at new racct.
      clear lt_ret.
      lt_ret-compcode  = lt_fag-bukrs.
      lt_ret-glaccount = lt_fag-racct.
      lt_ret-fisyear  = lt_fag-ryear.
      lt_ret-period = fiscalperiod.
      lt_ret-curr       = lv_waers.
    endat.

    "年初余额
    lt_ret-yr_openbal = lt_ret-yr_openbal + lt_fag-hslvt.

    if fiscalperiod > 12.
      lv_times = 16.
    else.
      lv_times = fiscalperiod.
    endif.

    "计算期初余额
    lt_ret-open_balance = lt_ret-open_balance + lt_fag-hslvt."起始金额
    do lv_times times.

      move sy-index to lv_rpmax.
      shift lv_rpmax right deleting trailing space.
      overlay lv_rpmax with '00'.
      concatenate 'HSL' lv_rpmax into lv_fieldname.
      assign component lv_fieldname of structure lt_fag to <field>.
      move <field> to lv_hslxx.

      lt_ret-open_balance = lt_ret-open_balance + lv_hslxx.
    enddo.

    " 16期的发生额包括12-16，所以计算4+1
    if fiscalperiod > 12.
      lv_times = 1 + 4.
    else.
      lv_times = 1.
    endif.

    "期间发生额
    do lv_times times.
      lv_int = fiscalperiod + sy-index - 1.
      move lv_int to lv_rpmax.
      shift lv_rpmax right deleting trailing space.
      overlay lv_rpmax with '00'.
      concatenate 'HSL' lv_rpmax into lv_fieldname.
      assign component lv_fieldname of structure lt_fag to <field>.
      move <field> to lv_hslxx.

      if lt_fag-drcrk = 'S'. " 期间借方
        lt_ret-debit_per = lt_ret-debit_per + lv_hslxx.
      else.  "期间贷方
        lt_ret-credit_per = lt_ret-credit_per + lv_hslxx.
      endif.
    enddo.

    at end of racct.
      append lt_ret.
    endat.
  endloop.

  loop at lt_ret.
    lv_idx = sy-tabix.

    select single txt20 into lt_ret-acctext
    from skat
    where spras = '1' and saknr = lt_ret-glaccount and ktopl = lv_ktopl.

    "期间发生额（借方+贷方）
    lt_ret-per_amt = lt_ret-debit_per + lt_ret-credit_per.

    "期末余额
    lt_ret-balance = lt_ret-open_balance + lt_ret-per_amt.

    modify lt_ret index lv_idx.
  endloop.

  delete lt_ret where yr_openbal = 0
                and open_balance = 0
                and debit_per = 0
                and credit_per = 0.

  acc_balances[] = lt_ret[].
endfunction.