.onLoad <- function(libname, pkgname) {
  
  op <- options()
  op.Rinstapkg <- list(
    Rinstapkg.private_base_url = "https://i.instagram.com/api/v1",
    Rinstapkg.ig_sig_key_version = "4",
    Rinstapkg.ig_sig_key = "937463b5272b5d60e9d20f0f8d7d192193dd95095a3ad43725d494300a5ea5fc",
    Rinstapkg.experiments = "ig_android_fci_onboarding_friend_search,ig_android_device_detection_info_upload,ig_android_autosubmit_password_recovery_universe,ig_growth_android_profile_pic_prefill_with_fb_pic_2,ig_account_identity_logged_out_signals_global_holdout_universe,ig_android_background_voice_phone_confirmation_prefilled_phone_number_only,ig_android_login_identifier_fuzzy_match,ig_android_one_tap_aymh_redesign_universe,ig_android_keyboard_detector_fix,ig_android_suma_landing_page,ig_android_direct_main_tab_universe,ig_android_aymh_signal_collecting_kill_switch,ig_android_login_forgot_password_universe,ig_android_smartlock_hints_universe,ig_android_smart_prefill_killswitch,ig_android_account_switch_infra_universe,ig_android_multi_tap_login_new,ig_android_email_one_tap_auto_login_during_reg,ig_android_category_search_in_sign_up,ig_android_report_nux_completed_device,ig_android_reg_login_profile_photo_universe,ig_android_caption_typeahead_fix_on_o_universe,ig_android_nux_add_email_device,ig_android_ci_opt_in_placement,ig_android_remember_password_at_login,ig_type_ahead_recover_account,ig_android_analytics_accessibility_event,ig_sem_resurrection_logging,ig_android_abandoned_reg_flow,ig_android_editable_username_in_reg,ig_android_account_recovery_auto_login,ig_android_sim_info_upload,ig_android_skip_signup_from_one_tap_if_no_fb_sso,ig_android_hide_fb_flow_in_add_account_flow,ig_android_mobile_http_flow_device_universe,ig_account_recovery_via_whatsapp_universe,ig_android_hide_fb_button_when_not_installed_universe,ig_prioritize_user_input_on_switch_to_signup,ig_android_gmail_oauth_in_reg,ig_android_login_safetynet,ig_android_gmail_autocomplete_account_over_one_tap,ig_android_background_voice_phone_confirmation,ig_android_phone_auto_login_during_reg,ig_android_hide_typeahead_for_logged_users,ig_android_hindi,ig_android_reg_modularization_universe,ig_android_bottom_sheet,ig_android_snack_bar_hiding,ig_android_one_tap_fallback_auto_login,ig_android_device_verification_separate_endpoint,ig_account_recovery_with_code_android_universe,ig_android_onboarding_skip_fb_connect,ig_android_phone_reg_redesign_universe,ig_android_universe_noticiation_channels,ig_android_media_cache_cleared_universe,ig_android_account_linking_universe,ig_android_hsite_prefill_new_carrier,ig_android_retry_create_account_universe,ig_android_family_apps_user_values_provider_universe,ig_android_reg_nux_headers_cleanup_universe,ig_android_dialog_email_reg_error_universe,ig_android_ci_fb_reg,ig_android_device_info_foreground_reporting,ig_fb_invite_entry_points,ig_android_device_verification_fb_signup,ig_android_suma_biz_account,ig_android_onetaplogin_optimization,ig_video_debug_overlay,ig_android_ask_for_permissions_on_reg,ig_android_display_full_country_name_in_reg_universe,ig_android_exoplayer_settings,ig_android_persistent_duplicate_notif_checker,ig_android_security_intent_switchoff,ig_android_background_voice_confirmation_block_argentinian_numbers,ig_android_do_not_show_back_button_in_nux_user_list,ig_android_passwordless_auth,ig_android_direct_main_tab_account_switch,ig_android_modularized_dynamic_nux_universe,ig_android_icon_perf2,ig_android_email_suggestions_universe,ig_android_fb_account_linking_sampling_freq_universe,ig_android_prefill_full_name_from_fb,ig_android_access_flow_prefill",
    Rinstapkg.useragent = "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)",
    Rinstapkg.client_id = NULL,
    Rinstapkg.client_secret = NULL,
    Rinstapkg.callback_url = "http://localhost:1410/",
    Rinstapkg.httr_oauth_cache = ".httr-oauth-Rinstapkg"
  )
  toset <- !(names(op.Rinstapkg) %in% names(op))
  if(any(toset)) options(op.Rinstapkg[toset])
  
  invisible()
}

# store state variables in the '.state' internal environment (created in ig_auth.R)
.state$auth_method <- NULL
.state$token <- NULL
.state$session_id <- NULL
