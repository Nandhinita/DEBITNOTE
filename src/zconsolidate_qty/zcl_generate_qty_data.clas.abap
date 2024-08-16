CLASS zcl_generate_qty_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generate_qty_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE from zqm_qty_cert.

    INSERT zqm_qty_cert from (
        SELECT FROM I_DeliveryDocument
            FIELDS
                DeliveryDocument as delivery_doc,
                YY1_CertificateNumber_DLH as certificate_num,
                YY1_CertificateDate_DLH as certificate_date,
                YY1_MaterialGrade_DLH as material_grade,
                YY1_PackingListNo_DLH as packaging_list,
                YY1_ContainerTruckNo_DLH as container_num
                ORDER BY delivery_doc UP TO 200 ROWS    ).
    commit WORK.

    out->write( 'fetching done' ).
  ENDMETHOD.
ENDCLASS.
