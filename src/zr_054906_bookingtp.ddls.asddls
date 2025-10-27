@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Booking'

define view entity ZR_054906_BookingTP
  as select from ZI_054906_Booking

  association to parent ZR_054906_TravelTP as _Travel on $projection.TravelUuid = _Travel.TravelUuid

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
      _Travel
}
