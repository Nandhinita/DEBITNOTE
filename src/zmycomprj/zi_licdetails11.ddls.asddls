@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'LISCENCE DETAILS 111'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LICDETAILS11 as select from I_BillingDocumentBasic
{
    key BillingDocument,
    SDDocumentCategory,
    BillingDocumentCategory,
    ProposedBillingDocumentType,
    CreatedByUser,
    CreationDate,
    CreationTime,
    LastChangeDate,
    LastChangeDateTime,
    LogicalSystem,
    BillingDocumentDate,
    BillingDocumentIsCancelled,
    BillingDocCombinationCriteria,
    ManualInvoiceMaintIsRelevant,
    NmbrOfPages,
    IsIntrastatReportingRelevant,
    IsIntrastatReportingExcluded,
    BillingDocumentIsTemporary,
    TaxDepartureCountry,
    VATRegistration,
    VATRegistrationOrigin,
    VATRegistrationCountry,
    CustomerTaxClassification1,
    CustomerTaxClassification2,
    CustomerTaxClassification3,
    CustomerTaxClassification4,
    CustomerTaxClassification5,
    CustomerTaxClassification6,
    CustomerTaxClassification7,
    CustomerTaxClassification8,
    CustomerTaxClassification9,
    IsEUTriangularDeal,
    IncotermsTransferLocation,
    IncotermsLocation1,
    IncotermsLocation2,
    ContractAccount,
    CustomerPaymentTerms,
    PaymentReference,
    FixedValueDate,
    AdditionalValueDays,
    SEPAMandate,
    FiscalYear,
    AccountingDocument,
    FiscalPeriod,
    AccountingExchangeRateIsSet,
    AccountingExchangeRate,
    ExchangeRateDate,
    DocumentReferenceID,
    AssignmentReference,
    InternalFinancialDocument,
    IsRelevantForAccrual
}
