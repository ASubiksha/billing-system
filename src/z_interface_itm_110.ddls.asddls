@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_INTERFACE_ITM_110
  as select from zdata_table_it
  association to parent Z_INTERFACE_HDR_110 as _Header
    on $projection.bill_uuid = _Header.bill_uuid
{
  key item_uuid,
      bill_uuid,
      item_position,
      product_id,
      quantity,
      unit_price,
      subtotal,

      _Header
}
