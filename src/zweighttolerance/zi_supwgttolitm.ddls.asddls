@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view - SupplierweightToItm'
define view entity ZI_SUPWGTTOLITM as select from zsupwgtitm
association to parent ZI_SUPWGTTOL as _Root
    on $projection.ZId = _Root.ZId
{
    key z_id as ZId,
    z_toleranceweight as ZToleranceweight,
    z_tolerancefrom as ZTolerancefrom,
    z_toleranceto as ZToleranceto,
    z_created_by as ZCreatedBy,
    z_created_at as ZCreatedAt,
    z_last_changed_by as ZLastChangedBy,
    z_last_changed_at as ZLastChangedAt,
    z_local_last_changed_at as ZLocalLastChangedAt,
    _Root // Make association public
}
