CLASS zpricingtypeclass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    METHODS add_user_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpricingtypeclass IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*  add_user_data(  ).
*  out->write(  ' Data inserted' ).
  ENDMETHOD.
  METHOD add_user_data.
*data pricing_type type STANDARD TABLE OF zpricingtype.
*pricing_type = VALUE #(
*( pricingtype = 'Fixed' )
*( pricingtype = 'Variable' )
*).
*insert zpricingtype from table @pricing_type.

  ENDMETHOD.

ENDCLASS.
