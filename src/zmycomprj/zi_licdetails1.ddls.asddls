@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck:#CHECK
@EndUserText.label: 'LISCENCE DETAILS 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LICDETAILS1 as select from I_BillingDocument
{
    key BillingDocument,
    SDDocumentCategory,
    BillingDocumentCategory,
    BillingDocumentType,
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
    TransactionCurrency,
    StatisticsCurrency, 
    CustomerPriceGroup,
    PriceListType,
    TaxDepartureCountry,
    VATRegistration,
    VATRegistrationOrigin,
    VATRegistrationCountry,
    HierarchyTypePricing,
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
    SDPricingProcedure,
    ShippingCondition,
    PlantSupplier,
    IncotermsVersion,
    IncotermsClassification,
    IncotermsTransferLocation,
    IncotermsLocation1,
    IncotermsLocation2,
    PayerParty,
    ContractAccount,
    CustomerPaymentTerms,
    PaymentMethod,
    PaymentReference,
    FixedValueDate,
    AdditionalValueDays,
    SEPAMandate,
    CompanyCode,
    FiscalYear,
    AccountingDocument,
    FiscalPeriod,
    CustomerAccountAssignmentGroup,
    AccountingExchangeRateIsSet,
    AccountingExchangeRate,
    ExchangeRateDate,
    ExchangeRateType,
    DocumentReferenceID,
    AssignmentReference,
    ReversalReason,
    DunningArea,
    DunningBlockingReason,
    DunningKey,
    InternalFinancialDocument,
    IsRelevantForAccrual,
    SoldToParty,
    PartnerCompany,
    PurchaseOrderByCustomer,
    CustomerGroup,
    Country,
    CityCode,
    SalesDistrict,
    Region,
    County,
    CreditControlArea,
    CustomerRebateAgreement,
    PricingDocument,
    OverallSDProcessStatus,
    OverallBillingStatus,
    AccountingPostingStatus,
    AccountingTransferStatus,
    BillingIssueType,
    InvoiceListStatus,
    OvrlItmGeneralIncompletionSts,
    OverallPricingIncompletionSts,
    InvoiceClearingStatus,
    InvoiceListBillingDate,
    YY1_EPCGLICENSESH_BDH,
    /* Associations */
    _AccountingDocument,
    _AccountingPostingStatus,
    _AccountingTransferStatus,
    _BillingDocumentCategory,
    _BillingDocumentType,
    _BillingIssueType,
    _CityCode,
    _CompanyCode,
    _Country,

    _SoldToParty,
    _StatisticsCurrency,
    _TaxDepartureCountry,
    _TransactionCurrency,
    _VATRegistrationCountry,
    _VATRegistrationOrigin,
    _YY1_EPCGLICENSESH_BDH
}
