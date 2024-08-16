@EndUserText.label: 'Consumption View - WeightTolRoot'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SUPWGTTOLERANCE 
provider contract transactional_query
as projection on ZI_SUPWGTTOLERANCE
{
    key ZId,   
     
ZWeightTolID,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
    /* Associations */
    _Item:redirected to composition child ZC_SUPWGTTOL_ITM
}
