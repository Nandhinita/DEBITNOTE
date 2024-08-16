CLASS lhc_zins_char_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setProductName FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZINS_CHAR_ITEM~setProductName.

ENDCLASS.

CLASS lhc_zins_char_item IMPLEMENTATION.

  METHOD setProductName.
    LOOP AT keys INTO DATA(ls_key).

   READ ENTITIES OF zi_ins_char  IN LOCAL MODE
           ENTITY zins_char_item
           FIELDS ( ZSubProductID ZSubproductUuid ) WITH CORRESPONDING #( keys )
           RESULT DATA(resinschar).
            LOOP AT resinschar INTO DATA(ls_resinschar).
            if ls_resinschar-ZProductName is INITIAL and ls_resinschar-ZSubProductID is not INITIAL.
            DATA: lv_sub_matnr TYPE string.
                  CLEAR lv_sub_matnr.
           lv_sub_matnr = ls_resinschar-ZSubProductID.  " Example material number with leading zeros

" Loop to remove leading zeros
WHILE lv_sub_matnr+0(1) = '0'.
  SHIFT lv_sub_matnr BY 1 PLACES LEFT.
ENDWHILE.
   SELECT SINGLE FROM I_ProductDescription
        FIELDS ProductDescription
        WHERE Product = @ls_resinschar-ZSubProductID
       INTO @DATA(ltpodata).

      MODIFY ENTITIES OF zi_ins_char IN LOCAL MODE
      ENTITY zins_char_item
      UPDATE SET FIELDS WITH VALUE #( ( %tky = ls_key-%tky
      ZProductName = ltpodata
      ZMainproductid = lv_sub_matnr ) )
      REPORTED DATA(update_reported).
      reported = CORRESPONDING #( DEEP update_reported ).

ENDIf.

            ENDLOOP.
DATA(x) = keys.
DATA(y) = 0.
  ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_ins_char DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_ins_char IMPLEMENTATION.

  METHOD save_modified.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_INS_CHAR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ins_char RESULT result.
    METHODS createitemcharacteristics FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_ins_char~createitemcharacteristics.
    METHODS setmainproductname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ins_char~setmainproductname.


ENDCLASS.

CLASS lhc_ZI_INS_CHAR IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.



  METHOD CreateItemCharacteristics.

  DATA(x) = 0.

  ENDMETHOD.

  METHOD setMainProductName.
      LOOP AT keys INTO DATA(ls_key).

   READ ENTITIES OF zi_ins_char  IN LOCAL MODE
           ENTITY zi_ins_char
           FIELDS ( ZMainproductid ZProductUuid ) WITH CORRESPONDING #( keys )
           RESULT DATA(resinschar).
            LOOP AT resinschar INTO DATA(ls_resinschar).

            if ls_resinschar-ZCurrMainProductName is INITIAL and ls_resinschar-ZCurrMainProductID is not INITIAL.



DATA(lv_matnr) = ls_resinschar-ZCurrMainProductID.  " Example material number with leading zeros

" Loop to remove leading zeros
WHILE lv_matnr+0(1) = '0'.
  SHIFT lv_matnr BY 1 PLACES LEFT.
ENDWHILE.
   SELECT SINGLE FROM I_ProductDescription
        FIELDS ProductDescription
        WHERE Product = @ls_resinschar-ZCurrMainProductID
       INTO @DATA(ltpodata).
      MODIFY ENTITIES OF zi_ins_char IN LOCAL MODE
      ENTITY zi_ins_char
      UPDATE SET FIELDS WITH VALUE #( ( %tky = ls_key-%tky
      ZCurrMainProductName = ltpodata
      ZMainproductid = lv_matnr
 ) )
      REPORTED DATA(update_reported).
      reported = CORRESPONDING #( DEEP update_reported ).
      DATA(x) = 0.

ENDIf.
            ENDLOOP.

  ENDLOOP.
  ENDMETHOD.

ENDCLASS.
