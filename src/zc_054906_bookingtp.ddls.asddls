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
      CarrierId,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,

      /* Associations */
      _Travel : redirected to parent ZC_054906_TravelTP
}
