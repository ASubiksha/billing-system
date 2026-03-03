CLASS zutility_110 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    " Header Structure
    TYPES: BEGIN OF ty_hdr,
             bill_uuid      TYPE sysuuid_x16,
             bill_number    TYPE zdata_table_hdr-bill_number,
             customer_name  TYPE zdata_table_hdr-customer_name,
             billing_date   TYPE zdata_table_hdr-billing_date,
             total_amount   TYPE zdata_table_hdr-total_amount,
             currency       TYPE zdata_table_hdr-currency,
             payment_status TYPE zdata_table_hdr-payment_status,
           END OF ty_hdr.

    " Item Structure
    TYPES: BEGIN OF ty_itm,
             item_uuid     TYPE sysuuid_x16,
             bill_uuid     TYPE sysuuid_x16,
             item_position TYPE zdata_table_it-item_position,
             product_id    TYPE zdata_table_it-product_id,
             quantity      TYPE zdata_table_it-quantity,
             unit_price    TYPE zdata_table_it-unit_price,
             subtotal      TYPE zdata_table_it-subtotal,
           END OF ty_itm.

    TYPES:
      tt_hdr TYPE STANDARD TABLE OF ty_hdr,
      tt_itm TYPE STANDARD TABLE OF ty_itm.

    " UUID Generator
    CLASS-METHODS generate_uuid
      RETURNING VALUE(rv_uuid) TYPE sysuuid_x16.

    " Subtotal Calculator
    CLASS-METHODS calculate_subtotal
      IMPORTING
        iv_quantity   TYPE zdata_table_it-quantity
        iv_unit_price TYPE zdata_table_it-unit_price
      RETURNING VALUE(rv_subtotal) TYPE zdata_table_it-subtotal.

    " Buffer Handling
    METHODS:
      set_hdr  IMPORTING is_hdr TYPE ty_hdr,
      get_hdr  EXPORTING es_hdr TYPE ty_hdr,
      set_itm  IMPORTING is_itm TYPE ty_itm,
      get_itm  EXPORTING es_itm TYPE ty_itm,
      clear_buffer.

  PRIVATE SECTION.

    DATA: gs_hdr TYPE ty_hdr,
          gs_itm TYPE ty_itm.

ENDCLASS.

CLASS zutility_110 IMPLEMENTATION.

  METHOD generate_uuid.
    rv_uuid = cl_system_uuid=>create_uuid_x16_static( ).
  ENDMETHOD.

  METHOD calculate_subtotal.
    rv_subtotal = iv_quantity * iv_unit_price.
  ENDMETHOD.

  METHOD set_hdr.
    gs_hdr = is_hdr.
  ENDMETHOD.

  METHOD get_hdr.
    es_hdr = gs_hdr.
  ENDMETHOD.

  METHOD set_itm.
    gs_itm = is_itm.
  ENDMETHOD.

  METHOD get_itm.
    es_itm = gs_itm.
  ENDMETHOD.

  METHOD clear_buffer.
    CLEAR: gs_hdr, gs_itm.
  ENDMETHOD.

ENDCLASS.
