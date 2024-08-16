@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view - SupplierweightTolItm'
define view entity ZI_SUPWGTTOL_ITM
  as select from zsupwgtitm
  association to parent ZI_SUPWGTTOLERANCE as _Root on $projection.ZId = _Root.ZId
{
      @EndUserText.label: 'ID'
  key z_id                    as ZId,

      z_weighttolid           as ZWeightTolID,
      @EndUserText.label: 'Tolerance Weight'
      z_toleranceweight       as ZToleranceweight,
      @EndUserText.label: 'Tolerance From'
      z_tolerancefrom         as ZTolerancefrom,
      @EndUserText.label: 'Tolerance To'
      z_toleranceto           as ZToleranceto,

      z_created_by            as ZCreatedBy,
      z_created_at            as ZCreatedAt,
      z_last_changed_by       as ZLastChangedBy,
      z_last_changed_at       as ZLastChangedAt,
      z_local_last_changed_at as ZLocalLastChangedAt,
      _Root

}
