@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Booking'

define view entity ZI_054906_Booking
  as select from z054906booking_a

{
  key booking_uuid  as BookingUuid,

      travel_uuid   as TravelUuid,
      booking_id    as BookingId,
      booking_date  as BookingDate,
      carrier_id    as CarrierId,
      connection_id as ConnectionId,
      flight_date   as FlightDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price  as FlightPrice,

      currency_code as CurrencyCode
}
