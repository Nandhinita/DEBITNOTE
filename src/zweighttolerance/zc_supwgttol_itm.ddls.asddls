@EndUserText.label: 'Consumption View - WeightTolItem'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_SUPWGTTOL_ITM as projection on ZI_SUPWGTTOL_ITM
{
    key ZId,
    ZWeightTolID,
    ZToleranceweight,
    ZTolerancefrom,
    ZToleranceto,
    ZCreatedBy,
    ZCreatedAt,
    ZLastChangedBy,
    ZLastChangedAt,
    ZLocalLastChangedAt,
    /* Associations */

    _Root:redirected to parent ZC_SUPWGTTOLERANCE
}
