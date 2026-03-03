@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Consumption View'
define root view entity Z_CONSUMPTION_HDR_110
  provider contract transactional_query
  as projection on Z_INTERFACE_HDR_110
{
   key bill_uuid,
       bill_number,
       customer_name,
       billing_date,
       total_amount,
       currency,
       payment_status,

       _Item
}
