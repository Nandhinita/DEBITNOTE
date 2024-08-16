
CLASS lsc_zi_quality_inspection_root DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_quality_inspection_root IMPLEMENTATION.

  METHOD save_modified.
*    DATA: lt_ZI_QUALITY_INSPECTION_ROOT TYPE STANDARD TABLE OF zi_quality_inspection_root,
*
*          ls_item1                      TYPE zi_quality_inspection_item,
*          total_price                   TYPE p DECIMALS 2 VALUE 0,
*          total_price_up                TYPE p DECIMALS 2 VALUE 0.
*
*    " Handle creation if required
*    IF create-qualityinsroot IS NOT INITIAL.
*      lt_ZI_QUALITY_INSPECTION_ROOT = CORRESPONDING #( create-qualityinsroot ).
*    ENDIF.
*
*    " Handle updates
*    IF update-qualityinsroot IS NOT INITIAL.
*      lt_ZI_QUALITY_INSPECTION_ROOT = CORRESPONDING #( update-qualityinsroot ).
*LOOP AT lt_ZI_QUALITY_INSPECTION_ROOT INTO DATA(ls_ZI_QUALITY_INSPECTION_ROOT).
*        CLEAR: total_price, total_price_up.
*
*
*
*          READ ENTITIES OF zi_quality_inspection_root  IN LOCAL MODE
*           ENTITY QualityInsRoot ALL FIELDS
*           WITH CORRESPONDING #( update-qualityinsroot )
*           RESULT DATA(lt_zr_yso_hdr_e022).
*          IF lt_zr_yso_hdr_e022 IS NOT INITIAL.
*
*
*UPDATE zqualityins_root SET z_after_qc = '2345' WHERE z_inspectionlot_uuid
*= @ls_ZI_QUALITY_INSPECTION_ROOT-ZInspectionlotUuid.
*
*


*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.



  ENDMETHOD.



ENDCLASS.

CLASS lhc_qualityinsitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS createitmaction FOR DETERMINE ON SAVE                       "Item Creation time
      IMPORTING keys FOR qualityinsitem~createitmaction.

ENDCLASS.

CLASS lhc_qualityinsitem IMPLEMENTATION.

  METHOD createitmaction.
    "Item creation time - Set the InfoField1 values
*    LOOP AT keys INTO DATA(ls_key).
*
*      MODIFY ENTITIES OF zi_quality_inspection_root IN LOCAL MODE
*      ENTITY QualityInsItem
*      UPDATE SET FIELDS WITH VALUE #( ( ZItemUuid = ls_key-ZItemUuid
*      ZTotalWeight = '752' ) )
*      REPORTED DATA(update_reported).
*      reported = CORRESPONDING #( DEEP update_reported ).
*   ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_qualityinsroot DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR qualityinsroot RESULT result.
    METHODS calculatetotalweight FOR MODIFY
      IMPORTING keys FOR ACTION qualityinsroot~calculatetotalweight.
    METHODS createdebitnote FOR MODIFY
      IMPORTING keys FOR ACTION qualityinsroot~createdebitnote.
    METHODS createitemcharacteristics FOR DETERMINE ON SAVE
      IMPORTING keys FOR qualityinsroot~createitemcharacteristics.
    METHODS inspectionlotvalidate FOR VALIDATE ON SAVE
      IMPORTING keys FOR qualityinsroot~inspectionlotvalidate.



ENDCLASS.

CLASS lhc_qualityinsroot IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.



  METHOD calculatetotalweight.

    LOOP AT keys INTO DATA(ls_key).




*Current Root Instance
      READ ENTITIES OF zi_quality_inspection_root IN LOCAL MODE
       ENTITY qualityinsroot ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(insproot).
      IF insproot IS NOT INITIAL.
        LOOP AT insproot INTO DATA(ls_insproot).

*retrieves only the first row that matches the selection criteria
*Inspection Lot Details
          SELECT SINGLE FROM i_inspectionlot
          FIELDS purchasingdocument,purchasingdocumentitem,inspectionlotactualquantity,inspectionlotsamplequantity,
          insplotqtytofree,material,materialdocument,materialdocumentitem,
          inspectionlotsampleunit,\_insplotusagedecision-insplotusgedcsnselectedset,\_insplotusagedecision-inspectionlotusagedecisioncode
          WHERE inspectionlot = @ls_insproot-zinspectionlotid
          INTO @DATA(ltdata).

*Purchase Order Details
          SELECT SINGLE FROM i_purchaseorderitemapi01
        FIELDS netpriceamount,documentcurrency,orderquantity
        WHERE purchaseorder = @ltdata-purchasingdocument AND purchaseorderitem = @ltdata-purchasingdocumentitem
       INTO @DATA(ltpodata).

*Material Document Details
          SELECT SINGLE FROM i_materialdocumentitem_2
          FIELDS quantityinentryunit,totalgoodsmvtamtincccrcy,entryunit,companycodecurrency
          WHERE materialdocument = @ltdata-materialdocument AND materialdocumentitem = @ltdata-materialdocumentitem
          INTO @DATA(matdocitem).

*Update Root table with the above details
          MODIFY ENTITIES OF zi_quality_inspection_root IN LOCAL MODE
           ENTITY qualityinsroot
           UPDATE SET FIELDS WITH VALUE #( ( %tky = ls_key-%tky
           zpurchaseorderid = ltdata-purchasingdocument
           zunrestrictedqty = ltdata-insplotqtytofree
           zsamplesize = ltdata-inspectionlotsamplequantity
           zsamplesizeunit = ltdata-inspectionlotsampleunit
            zgrnqty = matdocitem-quantityinentryunit
            zgrnqtyunit = matdocitem-entryunit
           zgrnid = ltdata-materialdocument
           zpoprice = ltpodata-netpriceamount
           zpopricecurrency = ltpodata-documentcurrency
           zinitialbillamnt = matdocitem-totalgoodsmvtamtincccrcy
           zinitialbillamntcurrency = matdocitem-companycodecurrency ) )
           REPORTED DATA(update_reported).
          reported = CORRESPONDING #( DEEP update_reported ).


*Inspection Characteristics details (Result Record)
*Consider only info fields 1
          SELECT FROM i_inspectioncharacteristic
            FIELDS inspspecinformationfield1,inspspecinformationfield2,inspspecinformationfield3,inspectioncharacteristic,inspectioncharacteristictext,
            \_inspectionresult-inspectionresultmeanvalue,\_inspectionresult-inspresulthasmaximumvalue
            WHERE inspectionlot = @ls_insproot-zinspectionlotid AND inspspecinformationfield1 IN ('DNMP', 'DNSP', 'DNOP')
           INTO TABLE @DATA(lt_customeritems1).

          DATA : mainprd TYPE string.
*DELETE ADJACENT DUPLICATES FROM lt_customeritems1 COMPARING InspSpecInformationField1.
          LOOP AT lt_customeritems1 INTO DATA(ls_item1).
            IF ls_item1-inspspecinformationfield1 = 'DNMP'.



              mainprd = ls_item1-inspspecinformationfield2.
            ENDIF.
          ENDLOOP.

*Create the item table using above data
          LOOP AT lt_customeritems1 INTO DATA(ls_item).

            DATA: resultmean    TYPE p DECIMALS 2,   " Packed number with 2 decimal places
                  unrestricted  TYPE p DECIMALS 2,   " Packed number with 2 decimal places
                  sample        TYPE p DECIMALS 2,   " Packed number with 2 decimal places
                  div           TYPE p DECIMALS 2,   " Packed number with 2 decimal places
                  poprice       TYPE p DECIMALS 2,   " Packed number with 2 decimal places
                  popricecurr   TYPE c LENGTH 3,      " 3-character string for currency code
                  suppprice     TYPE p DECIMALS 2,   " Packed number with 2 decimal places
                  supppricecurr TYPE c LENGTH 3,      " 3-character string for currency code
                  totalamnt     TYPE p DECIMALS 2,
                  totalamntcurr TYPE c LENGTH 3,
                  poorderqty    TYPE p DECIMALS 2,
                  calwgttol     TYPE p DECIMALS 2.





            poorderqty = ltpodata-orderquantity.
            poprice = ltpodata-netpriceamount.
            popricecurr = ltpodata-documentcurrency.

            CLEAR: resultmean,unrestricted,sample,div,suppprice,supppricecurr,totalamnt,totalamntcurr.

            resultmean = ls_item-inspectionresultmeanvalue.


            IF ls_item-inspspecinformationfield1 = 'DNMP'.



              calwgttol = poorderqty - resultmean.
              IF calwgttol LE 25.
                div = calwgttol.
              ELSEIF calwgttol GE 25.
                SELECT SINGLE FROM zweighttolerance
     FIELDS weightid,uuid
     WHERE weightid = 'ROOT'
    INTO @DATA(resweightroot).

                READ ENTITY zi_wgttolerance
              BY \_item
              ALL FIELDS
               WITH VALUE #( (  %key-uuid = resweightroot-uuid
                                ) )
               RESULT DATA(lt_weight_tol)
               FAILED DATA(failed_rba_weight_tol).
* Check if data is found
                IF sy-subrc = 0.
                  LOOP AT lt_weight_tol INTO DATA(ls_wgt_tol).
                    DATA: lv_int    TYPE i,
                          lv_from   TYPE i,
                          lv_to     TYPE i,
                          lv_weight TYPE i.


                    lv_int = CONV i( calwgttol ).
                    lv_from = CONV i( ls_wgt_tol-ztolerancefrom ).

                    lv_weight = CONV i( ls_wgt_tol-ztoleranceweight ).


lv_to = COND i( WHEN ls_wgt_tol-ztoleranceto = 'above' THEN 999999999
                ELSE CONV i( ls_wgt_tol-ztoleranceto ) ).

IF lv_int BETWEEN lv_from AND lv_to.
  div = calwgttol - lv_weight.
ENDIF.

                  ENDLOOP.
                ENDIF.

              ENDIF.

                suppprice = poprice.
              supppricecurr = popricecurr.
            ENDIF.

            DATA: lt_product_table TYPE TABLE OF zinsp_charitm_db,
                  ls_product_table TYPE zinsp_charitm_db,
                  lv_product_id    TYPE matnr,
                  lv_supproductid  TYPE purchasingdocument.
            IF ls_item-inspspecinformationfield1 = 'DNOP'.

            unrestricted = ltdata-insplotqtytofree.
            sample = ltdata-inspectionlotsamplequantity.
            div = ( resultmean * unrestricted ) / sample.
* Set the product ID you are querying for
              lv_product_id = mainprd.  " Replace with actual product ID
              lv_supproductid = ls_item-inspspecinformationfield2.


* Query the custom table



              SELECT SINGLE FROM zinsp_char_db
               FIELDS z_mainproductid,z_product_uuid
               WHERE z_mainproductid = @lv_product_id
              INTO @DATA(inschar).


              READ ENTITY zi_ins_char
            BY \_root
            ALL FIELDS
             WITH VALUE #( (  %key-zproductuuid = inschar-z_product_uuid
                              ) )
             RESULT DATA(lt_product_table1)
             FAILED DATA(failed_rba_fields_with).
* Check if data is found
              IF sy-subrc = 0.
                LOOP AT lt_product_table1 INTO DATA(tab).
                  IF tab-zmainproductid = lv_supproductid.
                    IF tab-zpricingtype = 'Variable'.
                      suppprice =   poprice + tab-zsupprdprice.
                    ELSEIF tab-zpricingtype = 'Fixed'.
                      suppprice =   tab-zsupprdprice.

                    ENDIF.


                  ENDIF.
                ENDLOOP.


              ENDIF.

            ENDIF.

            IF ls_item-inspspecinformationfield1 = 'DNSP'.
                        unrestricted = ltdata-insplotqtytofree.
            sample = ltdata-inspectionlotsamplequantity.
            div = ( resultmean * unrestricted ) / sample.
              div = ls_item-inspectionresultmeanvalue.
* Set the product id you are querying for
              lv_product_id = mainprd.  " Replace with actual product ID
              lv_supproductid = ls_item-inspspecinformationfield2.
* Clear the product table
              CLEAR lt_product_table.

* Query the custom table


              SELECT SINGLE FROM zinsp_char_db
                   FIELDS z_mainproductid,z_product_uuid
                   WHERE z_mainproductid = @lv_product_id
                  INTO @DATA(inschar1).


              READ ENTITY zi_ins_char
            BY \_root
            ALL FIELDS
             WITH VALUE #( (  %key-zproductuuid = inschar1-z_product_uuid
                              ) )
             RESULT DATA(lt_product_table2)
             FAILED DATA(failed_rba_fields_with1).



* Check if data is found
              IF sy-subrc = 0.
                LOOP AT lt_product_table2 INTO DATA(tab1).
                  IF tab1-zmainproductid = lv_supproductid.
                    IF tab1-zpricingtype = 'Variable'.
                      suppprice =   poprice + tab1-zsupprdprice.
                    ELSEIF tab1-zpricingtype = 'Fixed'.
                      suppprice =   tab1-zsupprdprice.

                    ENDIF.
                  ENDIF.

                ENDLOOP.


              ENDIF.
            ENDIF.


            totalamnt = div * suppprice.

            SELECT SINGLE FROM zqualityins_item
                         FIELDS z_infofield2,z_item_uuid,z_inspectionlot_uuid
                         WHERE z_infofield2 = @ls_item-inspspecinformationfield2 AND z_inspectionlot_uuid = @ls_key-zinspectionlotuuid
                        INTO @DATA(resquality).

* Update Case
            IF resquality IS NOT INITIAL.

              IF div IS NOT INITIAL.
                MODIFY ENTITIES OF zi_quality_inspection_root IN LOCAL MODE
   ENTITY qualityinsitem
   UPDATE SET FIELDS WITH VALUE #( ( zitemuuid = resquality-z_item_uuid
    ztotalweight = div
    ztotalprice = suppprice
   ztotalamount = totalamnt
    ) )
   REPORTED DATA(update_reported_itm).
                reported = CORRESPONDING #( DEEP update_reported_itm ).
              ENDIF.
*Insert new line
            ELSEIF resquality IS INITIAL.
              MODIFY ENTITIES OF zi_quality_inspection_root IN LOCAL MODE
                ENTITY qualityinsroot

                CREATE BY \_inspectionlotitm FROM VALUE #( (

                                 zinspectionlotuuid = ls_key-zinspectionlotuuid
                                 %target = VALUE #( ( %cid = '080'

                                                      zmatdescription = ls_item-inspectioncharacteristictext
                                                      zinspectionlotuuid = ls_key-zinspectionlotuuid
                                                      zinfofield1 = ls_item-inspspecinformationfield1
                                                      zinfofield2 = ls_item-inspspecinformationfield2
                                                      ztotalweight = div
                                                      ztotalprice = suppprice
                                                      ztotalamount = totalamnt
                                                      %control = VALUE #(
                                                                            zmatdescription = if_abap_behv=>mk-on
                                                                          zinspectionlotuuid = if_abap_behv=>mk-on
                                                                          zinfofield1 = if_abap_behv=>mk-on
                                                                          zinfofield2 = if_abap_behv=>mk-on
                                                                          ztotalweight = if_abap_behv=>mk-on
                                                                          ztotalprice = if_abap_behv=>mk-on
                                                                          ztotalamount = if_abap_behv=>mk-on
                                                                        )
                                                    )
                                                )
                                            ) )
          MAPPED DATA(lt_mapped)
          FAILED DATA(lt_failed)
          REPORTED DATA(lt_reported).
            ENDIF.
            DATA: total_price      TYPE p DECIMALS 2 VALUE 0,
                  total_price_supp TYPE p DECIMALS 2 VALUE 0.
            IF ls_item-inspspecinformationfield1 <> 'DNSP'.
              total_price = total_price + totalamnt.  " Example calculation
              DATA(x1) = 0.
            ELSEIF ls_item-inspspecinformationfield1 = 'DNSP'.
              total_price_supp = total_price_supp + totalamnt.
            ENDIF.






          ENDLOOP.

        ENDLOOP.

* calculateZafterac
*    DATA: total_price_up TYPE p DECIMALS 2 VALUE 0,
        DATA: diff         TYPE p DECIMALS 2 VALUE 0,
              supp_prd_add TYPE p DECIMALS 2 VALUE 0.

        IF suppprice IS NOT INITIAL.
          DATA: lt_quality_inspection_root TYPE TABLE OF zi_quality_inspection_root,
                ls_quality_inspection_root TYPE zi_quality_inspection_root.






          zbp_i_quality_inspection_root=>total_price_up = total_price.  " Example calculation
          IF zbp_i_quality_inspection_root=>total_price_up IS NOT INITIAL.

            supp_prd_add = zbp_i_quality_inspection_root=>total_price_up + total_price_supp.
            diff = matdocitem-totalgoodsmvtamtincccrcy - supp_prd_add.

            MODIFY ENTITIES OF zi_quality_inspection_root IN LOCAL MODE
              ENTITY qualityinsroot
              UPDATE SET FIELDS WITH VALUE #( ( %tky = ls_key-%tky
                                                     zafterqc =  supp_prd_add
                                                     zdifferencedebit = diff
                                                     ) )
                    REPORTED DATA(update_reported1).
            reported = CORRESPONDING #( DEEP update_reported1 ).
          ENDIF.



        ENDIF.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.



  METHOD createdebitnote.

    "ROOT STRUCTURE
    DATA: BEGIN OF root,
            debitmemorequesttype TYPE string,
            salesorganization    TYPE string,
            distributionchannel  TYPE string,
            organizationdivision TYPE string,
            soldtoparty          TYPE string,
            totalnetamount       TYPE string,
            transactioncurrency  TYPE string,
          END OF root.

    "ITEM STRUCTURE
    DATA: BEGIN OF item,
            debitmemorequestitem TYPE string,
            material             TYPE string,
            requestedquantity    TYPE string,
          END OF item.

    "INTERNAL TABLES
    DATA it_root LIKE TABLE OF root.
    DATA it_item LIKE TABLE OF item.

    "WORK AREAS
    DATA wa_root LIKE root.
    DATA wa_item LIKE item.

    "ROOT DATA
    wa_root-debitmemorequesttype = 'DR'.
    wa_root-salesorganization =  'SCSO'.
    wa_root-distributionchannel = 'C1'.
    wa_root-organizationdivision = 'D1'.
    wa_root-soldtoparty = '1000002'.
    wa_root-totalnetamount = '100'.
    wa_root-transactioncurrency = 'INR'.
    APPEND wa_root TO it_root.
    CLEAR wa_root.

    "ITEM DATA
    wa_item-material = '30002'.
    wa_item-debitmemorequestitem = '10'.
    wa_item-requestedquantity = '2'.
    APPEND wa_item TO it_item.
    CLEAR wa_item.

    wa_item-material = '30002'.
    wa_item-debitmemorequestitem = '20'.
    wa_item-requestedquantity = '2'.
    APPEND wa_item TO it_item.
    CLEAR wa_item.

    wa_item-material = '30002'.
    wa_item-debitmemorequestitem = '30'.
    wa_item-requestedquantity = '2'.
    APPEND wa_item TO it_item.
    CLEAR wa_item.

    "JSON (ROOT)
    DATA jsonbody_root TYPE string.

    LOOP AT it_root INTO DATA(lwa_root).
      IF lwa_root IS NOT INITIAL.
        jsonbody_root =  '"DebitMemoRequestType": "' &&  lwa_root-debitmemorequesttype && '",' && '"SalesOrganization": "' &&  lwa_root-salesorganization && '",' && '"DistributionChannel": "' &&  lwa_root-distributionchannel && '",' &&
'"OrganizationDivision": "' &&  lwa_root-organizationdivision && '",' && '"SoldToParty": "' &&  lwa_root-soldtoparty && '",' && '"TotalNetAmount": "' &&  lwa_root-totalnetamount && '",' && '"TransactionCurrency": "' &&  lwa_root-transactioncurrency &&
'",'.
      ENDIF.
    ENDLOOP.

    "JSON (ITEM)
    DATA jsonbody_item TYPE string.
    LOOP AT it_item INTO DATA(lwa_item).
      IF lwa_item IS NOT INITIAL.
        IF jsonbody_item IS NOT INITIAL.
          jsonbody_item = jsonbody_item && ',{"DebitMemoRequestItem": "' &&  lwa_item-debitmemorequestitem && '",' && '"Material": "' &&  lwa_item-material && '",' && '"RequestedQuantity": "' &&  lwa_item-requestedquantity && '"}'.
        ELSE.
          jsonbody_item =  '{"DebitMemoRequestItem": "' &&  lwa_item-debitmemorequestitem && '",' && '"Material": "' &&  lwa_item-material && '",' && '"RequestedQuantity": "' &&  lwa_item-requestedquantity && '"}'.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF jsonbody_item IS NOT INITIAL.
      jsonbody_item = '"to_Item": [' && jsonbody_item && ']'.
    ENDIF.


    "PREPARING JSON
    jsonbody_root = '{' && jsonbody_root && jsonbody_item && '}'.


    DATA: lo_http_destination       TYPE REF TO if_http_destination,
          lo_web_http_client        TYPE REF TO if_web_http_client,
          lo_web_http_get_request   TYPE REF TO if_web_http_request,
          lo_web_http_get_response  TYPE REF TO if_web_http_response,
          lo_web_http_post_request  TYPE REF TO if_web_http_request,
          lo_web_http_post_response TYPE REF TO if_web_http_response,
          lv_response               TYPE string,
          lv_response_code          TYPE string,
          lv_csrf_token             TYPE string.

    TRY.
        lo_http_destination = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZDEBITNOTE_CS' ).

        lo_web_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ).

        lo_web_http_get_request = lo_web_http_client->get_http_request( ).

        lo_web_http_get_request->set_header_fields( VALUE #( ( name = 'x-csrf-token' value = 'fetch' ) ) ).

        lo_web_http_get_response = lo_web_http_client->execute( if_web_http_client=>get ).

        lv_csrf_token = lo_web_http_get_response->get_header_field( i_name = 'x-csrf-token' ).

        IF lv_csrf_token IS NOT INITIAL.

          lo_web_http_post_request = lo_web_http_client->get_http_request( ).

          lo_web_http_post_request->set_header_fields( VALUE #( ( name = 'x-csrf-token' value = lv_csrf_token ) ) ).

          lo_web_http_post_request->set_content_type( content_type = 'application/json' ).
          IF jsonbody_root IS NOT INITIAL.
            lo_web_http_post_request->set_text( jsonbody_root ).

            lo_web_http_post_response = lo_web_http_client->execute( if_web_http_client=>post ).

            lv_response = lo_web_http_post_response->get_text( ).
            lv_response_code = lo_web_http_post_response->get_status( )-code.
          ENDIF.
        ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.

    ENDTRY.

  ENDMETHOD.

  METHOD createitemcharacteristics.


  ENDMETHOD.



  METHOD inspectionlotvalidate.
    READ ENTITIES OF zi_quality_inspection_root  IN LOCAL MODE
           ENTITY qualityinsroot
           FIELDS ( zinspectionlotid ) WITH CORRESPONDING #( keys )
           RESULT DATA(inspids).
    LOOP AT inspids INTO DATA(inspid).
      SELECT SINGLE FROM zqualityins_root
             FIELDS z_inspectionlot_id
             WHERE z_inspectionlot_id = @inspid-zinspectionlotid
            INTO @DATA(resinspid).
      IF resinspid IS NOT INITIAL.
        APPEND VALUE #( %tky = inspid-%tky ) TO failed-qualityinsroot.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text = |This Inspection ( { resinspid } ) is already created.|
                         )  )
                         TO reported-qualityinsroot.
        DATA(y) = '4'.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
