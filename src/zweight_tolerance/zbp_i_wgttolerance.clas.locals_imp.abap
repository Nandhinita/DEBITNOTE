CLASS lhc_zi_wgttolerance DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_wgttolerance RESULT result.

    METHODS weighttolerance FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_wgttolerance~weighttolerance.

ENDCLASS.

CLASS lhc_zi_wgttolerance IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD weighttolerance.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_wgttolerance DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_wgttolerance IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
