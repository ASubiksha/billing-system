CLASS zbp_interface_hdr_110 DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF z_interface_hdr_110.
 PUBLIC SECTION.

    CLASS-DATA:
      mt_hdr_create TYPE STANDARD TABLE OF zdata_table_hdr,
      mt_hdr_update TYPE STANDARD TABLE OF zdata_table_hdr,
      mt_hdr_delete TYPE STANDARD TABLE OF sysuuid_x16,

      mt_itm_create TYPE STANDARD TABLE OF zdata_table_it,
      mt_itm_update TYPE STANDARD TABLE OF zdata_table_it,
      mt_itm_delete TYPE STANDARD TABLE OF sysuuid_x16.
ENDCLASS.

CLASS zbp_interface_hdr_110 IMPLEMENTATION.
ENDCLASS.
