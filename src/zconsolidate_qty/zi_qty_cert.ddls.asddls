@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root CDS view for quality certificate'
@Metadata.allowExtensions: true
define root view entity ZI_QTY_CERT as select from zqm_qty_cert
{
    
    @EndUserText.label: 'Delivery Number'
    key delivery_doc as delivery_doc,
    @EndUserText.label: 'Certificate'
    certificate_num as CertificateNum,
    @EndUserText.label: 'Certificate Date'
    certificate_date as CertificateDate,
    @EndUserText.label: 'Grade'
    material_grade as MaterialGrade,
    @EndUserText.label: 'Packaging List Number'
    packing_list_num as PackingListNum,
    @EndUserText.label: 'Container Number'
    container_num as ContainerNum
     // Make association public
}
