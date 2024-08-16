@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view - SupplierweightTolerance'
define root view entity ZI_SUPWGTTOLERANCE
  as select from zsupwgttolerance
  composition [0..*] of ZI_SUPWGTTOL_ITM as _Item
{
  key  z_id                    as ZId,
    z_weighttolid           as ZWeightTolID,
       z_created_by            as ZCreatedBy,
       z_created_at            as ZCreatedAt,
       z_last_changed_by       as ZLastChangedBy,
       z_last_changed_at       as ZLastChangedAt,
       z_local_last_changed_at as ZLocalLastChangedAt,
       _Item
}
