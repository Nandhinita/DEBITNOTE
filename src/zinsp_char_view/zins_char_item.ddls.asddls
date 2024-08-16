@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Character Item Interface View'
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINS_CHAR_ITEM as select from zinsp_charitm_db
association to parent ZI_INS_CHAR as _Item on 
$projection.ZProductUuid = _Item.ZProductUuid  and $projection.Z_Mainproduct_id = _Item.Z_Mainproduct_id
{
    key z_subproduct_uuid as ZSubproductUuid,
    z_product_uuid as ZProductUuid,
    @EndUserText.label: 'Components' 
    z_sup_productid as ZSupProductid,
      @EndUserText.label: 'Product Name' 
    z_product_name as ZProductName,
    @EndUserText.label: 'Product Type' 
    z_product_type as ZProductType,
    @EndUserText.label: 'Price' 
    z_supprd_price as ZSupprdPrice,
    @EndUserText.label: 'Currency' 
    z_supprd_cur as ZSupprdCur,
    @EndUserText.label: 'ProductID' 
    z_mainproduct_id as Z_Mainproduct_id,
    @EndUserText.label: 'Product ID' 
    z_mainproductid as ZMainproductid,
z_pricing_type as ZPricingType,
z_subproductid as ZSubProductID,
    z_created_by as ZCreatedBy,
    z_created_at as ZCreatedAt,
    z_last_changed_by as ZLastChangedBy,
    z_last_changed_at as ZLastChangedAt,
    z_local_last_changed_at as ZLocalLastChangedAt,
    _Item
}
