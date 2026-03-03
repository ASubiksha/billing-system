@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Consumption View'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_CONSUMPTION_ITM_110
  provider contract transactional_query
  as projection on Z_INTERFACE_ITM_110
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
