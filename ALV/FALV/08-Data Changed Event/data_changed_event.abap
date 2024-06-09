*&---------------------------------------------------------------------*
*& Report  ZFALV_DATA_CHANGED
*&
*&---------------------------------------------------------------------*

report  zfalv_data_changed.

type-pools: slis.

data: gt_fieldcat  type slis_t_fieldcat_alv,
      gs_fieldcat  type slis_fieldcat_alv,
      gt_events   type slis_t_event,
      gs_event    type slis_alv_event.

* 定义回调变量
data: gs_grid_settings type lvc_s_glay.


types: begin of t_spfli.
        include structure spfli.
types:  check type c.
types: end of t_spfli.

data: gt_spfli type standard table of t_spfli with header line.

data: begin of gs_cities,
         city like spfli-cityfrom,
      end of gs_cities.

data: gt_cities like standard table of gs_cities.


start-of-selection.
  perform frm_get_data.
  perform frm_disp_data.



*&---------------------------------------------------------------------*
*&      Form  frm_get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form frm_get_data.
  select * from spfli
    into table gt_spfli.

  select distinct cityfrom
    from spfli
    into corresponding fields of table gt_cities.
endform.                    "frm_get_data



*&---------------------------------------------------------------------*
*&      Form  frm_add_events
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form frm_add_events.
  clear gs_event.
  gs_event-name = slis_ev_data_changed.
  gs_event-form = 'FRM_ALV_DATA_CHANGED'.
  append gs_event to gt_events.
endform.                    "frm_add_events


*&---------------------------------------------------------------------*
*&      Form  frm_disp_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form frm_disp_data.
  call function 'Z_FALV_FIELD_CATALOG'
    exporting
      it_output     = gt_spfli[]
    tables
      field_catalog = gt_fieldcat[].

  perform frm_add_events.
  gs_grid_settings-edt_cll_cb = 'X'.

  " 使ALV可编辑
  loop at gt_fieldcat into gs_fieldcat.
    if gs_fieldcat-key = 'X'.
      gs_fieldcat-edit = ''.
    else.
      gs_fieldcat-edit = 'X'.
    endif.

    if gs_fieldcat-fieldname = 'CHECK'.
      gs_fieldcat-checkbox = 'X'.
      gs_fieldcat-seltext_m = '选择'.
      gs_fieldcat-outputlen = 6.
    endif.


    modify gt_fieldcat from gs_fieldcat.
    clear gs_fieldcat.
  endloop.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program = sy-repid
      i_grid_settings    = gs_grid_settings
      it_fieldcat        = gt_fieldcat[]
      it_events          = gt_events
    tables
      t_outtab           = gt_spfli[].
endform.                    "frm_disp_data


*&---------------------------------------------------------------------*
*&      Form  frm_alv_data_changed
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CHANGED_DATA  text
*----------------------------------------------------------------------*
form frm_alv_data_changed using p_changed_data type ref to cl_alv_changed_data_protocol.

  data: field_name(20),
        modified_cells type lvc_s_modi.

  data: l_city like spfli-cityto.
  field-symbols <field_value>.

  " 对 cityfrom 和cityto 字段进行校验
  loop at p_changed_data->mt_mod_cells into modified_cells where fieldname = 'CITYFROM' or fieldname = 'CITYTO'.
    read table gt_cities into gs_cities with table key city = modified_cells-value.
    if not sy-subrc is initial.
      call method p_changed_data->add_protocol_entry
        exporting
          i_msgid     = '00'
          i_msgty     = 'E'
          i_msgno     = '001'
          i_msgv1     = '您所输入的城市并不在范围内, 数据不会被保存. '
          i_fieldname = modified_cells-fieldname.
      return.
    endif.
  endloop.

  " ALV 界面修改的数据自动保存
  loop at p_changed_data->mt_mod_cells into modified_cells.
    clear gt_spfli.
    read table gt_spfli index modified_cells-row_id.
    concatenate 'GT_SPFLI-'  modified_cells-fieldname into field_name .
    assign (field_name) to <field_value>.
    <field_value> = modified_cells-value.

    modify gt_spfli index modified_cells-row_id.
  endloop.

  update spfli from table gt_spfli.
endform.                    "frm_alv_data_changed