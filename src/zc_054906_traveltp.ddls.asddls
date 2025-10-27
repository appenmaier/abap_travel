@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Travel'

@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZC_054906_TravelTP
  provider contract transactional_query
  as projection on ZR_054906_TravelTP

{
  key TravelUuid,

      TravelId,
      AgencyId,
      CustomerId,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      CurrencyCode,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Description,

      Status,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Associations */
      _Bookings : redirected to composition child ZC_054906_BookingTP
}
