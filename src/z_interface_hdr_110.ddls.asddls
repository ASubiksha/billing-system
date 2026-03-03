@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Interface View (Root View)'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z_INTERFACE_HDR_110
  as select from zdata_table_hdr
  composition [0..*] of Z_INTERFACE_ITM_110 as _Item
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
