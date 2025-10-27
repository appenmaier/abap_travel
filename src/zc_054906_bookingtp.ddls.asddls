@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Booking'

@Metadata.allowExtensions: true

define view entity ZC_054906_BookingTP
  as projection on ZR_054906_BookingTP

{
  key BookingUuid,

      TravelUuid,
      BookingId,
      BookingDate,

      @Consumption.valueHelpDefinition: [ { entity: { name: '/DMO/I_Carrier_StdVH', element: 'AirlineID' } } ]
      CarrierId,

      ConnectionId,
      FlightDate,
      FlightPrice,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CurrencyStdVH', element: 'Currency' } } ]
      CurrencyCode,

      /* Associations */
      _Travel : redirected to parent ZC_054906_TravelTP
}
