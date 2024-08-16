@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view - SupplierweightTol'
define root view entity ZI_SUPWGTTOL as select from zsupwgttolerance
composition [0..*] of ZI_SUPWGTTOLITM as _Item
{
    key z_id as ZId,
    z_created_by as ZCreatedBy,
    z_created_at as ZCreatedAt,
    z_last_changed_by as ZLastChangedBy,
    z_last_changed_at as ZLastChangedAt,
    z_local_last_changed_at as ZLocalLastChangedAt,
    _Item // Make association public
}
