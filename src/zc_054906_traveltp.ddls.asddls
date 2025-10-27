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

      @Consumption.valueHelpDefinition: [ { entity: { name: '/DMO/I_Agency_StdVH', element: 'AgencyID' } } ]
      AgencyId,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_054906_CustomerVH', element: 'CustomerId' } } ]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,

      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CurrencyStdVH', element: 'Currency' } } ]
      CurrencyCode,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Description,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_054906_StatusVH', element: 'Status' } } ]
      Status,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Transient Data */
      _CustomerText.Name    as CustomerName,
      BeginDateCriticality,
      StatusCriticality,

      /* Associations */
      _Bookings : redirected to composition child ZC_054906_BookingTP
}
