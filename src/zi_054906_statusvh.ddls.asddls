@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Value Help for Status'

define view entity ZI_054906_StatusVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(
                   p_domain_name : '/DMO/STATUS') as Text

    inner join   DDCDS_CUSTOMER_DOMAIN_VALUE(
                   p_domain_name : '/DMO/STATUS') as Value
      on Text.domain_name = Value.domain_name and Text.value_position = Value.value_position

{
      @EndUserText.label: 'Status'
      @EndUserText.quickInfo: 'Status'
  key Value.value_low as Status,

      @EndUserText.label: 'Status Text'
      @EndUserText.quickInfo: 'Status Text'
      Text.text       as StatusText
}

where Text.language = $session.system_language
