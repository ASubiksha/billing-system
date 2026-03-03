
CLASS lhc_Bill DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Bill.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Bill.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Bill.

    METHODS read FOR READ
      IMPORTING keys FOR READ Bill RESULT result.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ Bill\_Item
      FULL result_requested
      RESULT result
      LINK association_links.

ENDCLASS.



CLASS lhc_Bill IMPLEMENTATION.

  METHOD create.

    LOOP AT entities INTO DATA(ls_entity).

      APPEND VALUE zdata_table_hdr(
        bill_uuid      = ls_entity-bill_uuid
        bill_number    = ls_entity-bill_number
        customer_name  = ls_entity-customer_name
        billing_date   = ls_entity-billing_date
        total_amount   = ls_entity-total_amount
        currency       = ls_entity-currency
        payment_status = ls_entity-payment_status
      ) TO zbp_interface_hdr_110=>mt_hdr_create.

    ENDLOOP.

  ENDMETHOD.



  METHOD update.

    LOOP AT entities INTO DATA(ls_entity).

      APPEND VALUE zdata_table_hdr(
        bill_uuid      = ls_entity-bill_uuid
        bill_number    = ls_entity-bill_number
        customer_name  = ls_entity-customer_name
        billing_date   = ls_entity-billing_date
        total_amount   = ls_entity-total_amount
        currency       = ls_entity-currency
        payment_status = ls_entity-payment_status
      ) TO zbp_interface_hdr_110=>mt_hdr_update.

    ENDLOOP.

  ENDMETHOD.



  METHOD delete.

    LOOP AT keys INTO DATA(ls_key).
      APPEND ls_key-bill_uuid
        TO zbp_interface_hdr_110=>mt_hdr_delete.
    ENDLOOP.

  ENDMETHOD.



  METHOD read.

    DATA lt_hdr TYPE STANDARD TABLE OF zdata_table_hdr.

    LOOP AT keys INTO DATA(ls_key).

      SELECT *
        FROM zdata_table_hdr
        WHERE bill_uuid = @ls_key-bill_uuid
        INTO TABLE @DATA(lt_single).

      APPEND LINES OF lt_single TO lt_hdr.

    ENDLOOP.

    result = CORRESPONDING #( lt_hdr ).

  ENDMETHOD.



  METHOD rba_Item.

    DATA lt_items TYPE STANDARD TABLE OF zdata_table_it.

    LOOP AT keys_rba INTO DATA(ls_key).

      SELECT *
        FROM zdata_table_it
        WHERE bill_uuid = @ls_key-bill_uuid
        INTO TABLE @DATA(lt_single).

      APPEND LINES OF lt_single TO lt_items.

    ENDLOOP.

    result = CORRESPONDING #( lt_items ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_BillItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE BillItem.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE BillItem.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE BillItem.

    METHODS read FOR READ
      IMPORTING keys FOR READ BillItem RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ BillItem\_Header
      FULL result_requested
      RESULT result
      LINK association_links.

ENDCLASS.



CLASS lhc_BillItem IMPLEMENTATION.

  METHOD create.

    LOOP AT entities INTO DATA(ls_entity).

      DATA lv_subtotal TYPE zdata_table_it-subtotal.
      lv_subtotal = ls_entity-quantity * ls_entity-unit_price.

      APPEND VALUE zdata_table_it(
        item_uuid     = ls_entity-item_uuid
        bill_uuid     = ls_entity-bill_uuid
        item_position = ls_entity-item_position
        product_id    = ls_entity-product_id
        quantity      = ls_entity-quantity
        unit_price    = ls_entity-unit_price
        subtotal      = lv_subtotal
      ) TO zbp_interface_hdr_110=>mt_itm_create.

    ENDLOOP.

  ENDMETHOD.



  METHOD update.

    LOOP AT entities INTO DATA(ls_entity).

      DATA lv_subtotal TYPE zdata_table_it-subtotal.
      lv_subtotal = ls_entity-quantity * ls_entity-unit_price.

      APPEND VALUE zdata_table_it(
        item_uuid     = ls_entity-item_uuid
        bill_uuid     = ls_entity-bill_uuid
        item_position = ls_entity-item_position
        product_id    = ls_entity-product_id
        quantity      = ls_entity-quantity
        unit_price    = ls_entity-unit_price
        subtotal      = lv_subtotal
      ) TO zbp_interface_hdr_110=>mt_itm_update.

    ENDLOOP.

  ENDMETHOD.



  METHOD delete.

    LOOP AT keys INTO DATA(ls_key).
      APPEND ls_key-item_uuid
        TO zbp_interface_hdr_110=>mt_itm_delete.
    ENDLOOP.

  ENDMETHOD.



  METHOD read.

    DATA lt_itm TYPE STANDARD TABLE OF zdata_table_it.

    LOOP AT keys INTO DATA(ls_key).

      SELECT *
        FROM zdata_table_it
        WHERE item_uuid = @ls_key-item_uuid
        INTO TABLE @DATA(lt_single).

      APPEND LINES OF lt_single TO lt_itm.

    ENDLOOP.

    result = CORRESPONDING #( lt_itm ).

  ENDMETHOD.



  METHOD rba_Header.

    DATA lt_hdr TYPE STANDARD TABLE OF zdata_table_hdr.

    LOOP AT keys_rba INTO DATA(ls_key).

      SELECT SINGLE *
        FROM zdata_table_it
        WHERE item_uuid = @ls_key-item_uuid
        INTO @DATA(ls_item).

      IF sy-subrc = 0.

        SELECT *
          FROM zdata_table_hdr
          WHERE bill_uuid = @ls_item-bill_uuid
          INTO TABLE @DATA(lt_single).

        APPEND LINES OF lt_single TO lt_hdr.

      ENDIF.

    ENDLOOP.

    result = CORRESPONDING #( lt_hdr ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_INTERFACE_HDR_110 DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.

ENDCLASS.



CLASS lsc_Z_INTERFACE_HDR_110 IMPLEMENTATION.

  METHOD save.

    INSERT zdata_table_hdr FROM TABLE @zbp_interface_hdr_110=>mt_hdr_create.
    UPDATE zdata_table_hdr FROM TABLE @zbp_interface_hdr_110=>mt_hdr_update.

    LOOP AT zbp_interface_hdr_110=>mt_hdr_delete INTO DATA(lv_hdr).
      DELETE FROM zdata_table_hdr WHERE bill_uuid = @lv_hdr.
    ENDLOOP.

    INSERT zdata_table_it FROM TABLE @zbp_interface_hdr_110=>mt_itm_create.
    UPDATE zdata_table_it FROM TABLE @zbp_interface_hdr_110=>mt_itm_update.

    LOOP AT zbp_interface_hdr_110=>mt_itm_delete INTO DATA(lv_itm).
      DELETE FROM zdata_table_it WHERE item_uuid = @lv_itm.
    ENDLOOP.

  ENDMETHOD.



  METHOD cleanup.

    CLEAR:
      zbp_interface_hdr_110=>mt_hdr_create,
      zbp_interface_hdr_110=>mt_hdr_update,
      zbp_interface_hdr_110=>mt_hdr_delete,
      zbp_interface_hdr_110=>mt_itm_create,
      zbp_interface_hdr_110=>mt_itm_update,
      zbp_interface_hdr_110=>mt_itm_delete.

  ENDMETHOD.

ENDCLASS.
