@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Travel'

define root view entity ZR_054906_TravelTP
  as select from ZI_054906_Travel

  composition [0..*] of ZR_054906_BookingTP    as _Bookings
  association [1..1] to ZI_054906_CustomerText as _CustomerText on $projection.CustomerId = _CustomerText.CustomerId

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
      Description,
      Status,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Transient Data */
      case when dats_days_between($session.user_date, BeginDate) >= 14 then 3
           when dats_days_between($session.user_date, BeginDate) >= 7 then 2
           when dats_days_between($session.user_date, BeginDate) >= 0 then 1
           else 0
      end            as BeginDateCriticality,

      case Status when 'B' then 3
                  when 'N' then 0
                  when 'X' then 1
                  else 0
      end            as StatusCriticality,

      /* Associations */
      _Bookings,
      _CustomerText
}
