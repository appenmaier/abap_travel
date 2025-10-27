CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS showtestmessage FOR MODIFY
      IMPORTING keys FOR ACTION travel~showtestmessage.

    METHODS validateagency FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validateagency.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatecustomer.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatedates.

    METHODS determinestatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~determinestatus.

    METHODS determinetravelid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~determinetravelid.

    METHODS canceltravel FOR MODIFY
      IMPORTING keys FOR ACTION travel~canceltravel RESULT result.

    METHODS maintainbookingfee FOR MODIFY
      IMPORTING keys FOR ACTION travel~maintainbookingfee RESULT result.
ENDCLASS.


CLASS lhc_travel IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD showtestmessage.
    DATA message TYPE REF TO zcm_054906_travel.

    message = NEW zcm_054906_travel( severity  = if_abap_behv_message=>severity-success
                                     textid    = zcm_054906_travel=>test_message
                                     user_name = sy-uname ).

    APPEND message TO reported-%other.
  ENDMETHOD.

  METHOD validateagency.
    DATA message TYPE REF TO zcm_054906_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_054906_TravelTP
         FIELDS ( AgencyId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels INTO DATA(travel).
      " Validate Agency and Create Error Message
      SELECT SINGLE FROM /dmo/agency FIELDS @abap_true WHERE agency_id = @travel-AgencyId INTO @DATA(exists).
      IF exists = abap_false.
        message = NEW zcm_054906_travel( textid    = zcm_054906_travel=>no_agency_found
                                         agency_id = travel-AgencyId ).
        APPEND VALUE #( %tky     = travel-%tky
                        %element = VALUE #( AgencyId = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatecustomer.
    DATA message TYPE REF TO zcm_054906_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_054906_TravelTP
         FIELDS ( CustomerId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels INTO DATA(travel).
      " Validate Customer and Create Error Message
      SELECT SINGLE FROM /dmo/customer FIELDS @abap_true WHERE customer_id = @travel-CustomerId INTO @DATA(exists).
      IF exists = abap_false.
        message = NEW zcm_054906_travel( textid      = zcm_054906_travel=>no_customer_found
                                         customer_id = travel-CustomerId ).
        APPEND VALUE #( %tky     = travel-%tky
                        %element = VALUE #( CustomerId = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatedates.
    DATA message TYPE REF TO zcm_054906_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_054906_TravelTP
         FIELDS ( BeginDate EndDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels INTO DATA(travel).
      " Validate Dates and Create Error Message
      IF travel-EndDate < travel-BeginDate.
        message = NEW zcm_054906_travel( textid = zcm_054906_travel=>invalid_dates ).
        APPEND VALUE #( %tky = travel-%tky
                        %msg = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD determinestatus.
    MODIFY ENTITY IN LOCAL MODE ZR_054906_TravelTP
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR key IN keys
                         ( %tky   = key-%tky
                           Status = 'N' ) ).
  ENDMETHOD.

  METHOD determinetravelid.
    DATA travel_id TYPE /dmo/travel_id.

    " Get Travel ID
    SELECT FROM /dmo/travel FIELDS MAX( travel_id ) INTO @DATA(max_travel_id).
    travel_id = max_travel_id + 1.

    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_054906_TravelTP
           UPDATE FIELDS ( TravelId )
           WITH VALUE #( FOR key IN keys
                         ( %tky     = key-%tky
                           TravelId = travel_id ) ).
  ENDMETHOD.

  METHOD canceltravel.
    DATA message TYPE REF TO zcm_054906_travel.

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_054906_TravelTP
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Process Travels
    LOOP AT travels REFERENCE INTO DATA(travel).
      " Validate Status and Create Error Message
      IF travel->Status = 'X'.
        message = NEW zcm_054906_travel( textid      = zcm_054906_travel=>travel_already_cancelled
                                         description = travel->Description ).
        APPEND VALUE #( %tky     = travel->%tky
                        %element = VALUE #( Status = if_abap_behv=>mk-on )
                        %msg     = message ) TO reported-travel.
        APPEND VALUE #( %tky = travel->%tky ) TO failed-travel.
        DELETE travels INDEX sy-tabix.
        CONTINUE.
      ENDIF.

      " Set Status to Cancelled and Create Success Message
      travel->Status = 'X'.
      message = NEW zcm_054906_travel( severity    = if_abap_behv_message=>severity-success
                                       textid      = zcm_054906_travel=>travel_cancelled_successfully
                                       description = travel->Description ).
      APPEND VALUE #( %tky     = travel->%tky
                      %element = VALUE #( Status = if_abap_behv=>mk-on )
                      %msg     = message ) TO reported-travel.
    ENDLOOP.

    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_054906_TravelTP
           UPDATE FIELDS ( Status )
           WITH VALUE #( FOR t IN travels
                         ( %tky = t-%tky Status = t-Status ) ).

    " Set Result
    result = VALUE #( FOR t IN travels
                      ( %tky   = t-%tky
                        %param = t ) ).
  ENDMETHOD.

  METHOD maintainbookingfee.
    " Modify Travels
    MODIFY ENTITY IN LOCAL MODE ZR_054906_TravelTP
           UPDATE FIELDS ( BookingFee CurrencyCode )
           WITH VALUE #( FOR key IN keys
                         ( %tky         = key-%tky
                           BookingFee   = key-%param-BookingFee
                           CurrencyCode = key-%param-CurrencyCode ) ).

    " Read Travels
    READ ENTITY IN LOCAL MODE ZR_054906_TravelTP
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(travels).

    " Set Result
    result = VALUE #( FOR t IN travels
                      ( %tky = t-%tky %param = t ) ).
  ENDMETHOD.
ENDCLASS.
