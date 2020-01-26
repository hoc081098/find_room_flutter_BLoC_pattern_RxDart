// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get app_title {
    return Intl.message(
      'Find room',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  String get saved_rooms_title {
    return Intl.message(
      'Saved rooms',
      name: 'saved_rooms_title',
      desc: '',
      args: [],
    );
  }

  String get login_title {
    return Intl.message(
      'Login',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  String get detail_title {
    return Intl.message(
      'Detail',
      name: 'detail_title',
      desc: '',
      args: [],
    );
  }

  String get change_language {
    return Intl.message(
      'Change language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  String get or_connect_through {
    return Intl.message(
      'Or connect through',
      name: 'or_connect_through',
      desc: '',
      args: [],
    );
  }

  String get no_account {
    return Intl.message(
      'No account?',
      name: 'no_account',
      desc: '',
      args: [],
    );
  }

  String get register_now {
    return Intl.message(
      'Register now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  String get password {
    return Intl.message(
      'Password *',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  String get exit_app {
    return Intl.message(
      'Exit app',
      name: 'exit_app',
      desc: '',
      args: [],
    );
  }

  String get sure_want_to_exit_app {
    return Intl.message(
      'Are you sure you want to exit the application?',
      name: 'sure_want_to_exit_app',
      desc: '',
      args: [],
    );
  }

  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  String see_all_(dynamic title) {
    return Intl.message(
      'See all: $title',
      name: 'see_all_',
      desc: '',
      args: [title],
    );
  }

  String get see_all {
    return Intl.message(
      'See all',
      name: 'see_all',
      desc: '',
      args: [],
    );
  }

  String get add_to_saved {
    return Intl.message(
      'Add to saved',
      name: 'add_to_saved',
      desc: '',
      args: [],
    );
  }

  String get remove_from_saved {
    return Intl.message(
      'Remove from saved',
      name: 'remove_from_saved',
      desc: '',
      args: [],
    );
  }

  String get empty_rooms {
    return Intl.message(
      'Empty rooms...',
      name: 'empty_rooms',
      desc: '',
      args: [],
    );
  }

  String get login_now {
    return Intl.message(
      'Login now',
      name: 'login_now',
      desc: '',
      args: [],
    );
  }

  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get sure_want_to_logout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'sure_want_to_logout',
      desc: '',
      args: [],
    );
  }

  String get home_page_title {
    return Intl.message(
      'Home page',
      name: 'home_page_title',
      desc: '',
      args: [],
    );
  }

  String get mostViewed {
    return Intl.message(
      'Most viewed',
      name: 'mostViewed',
      desc: '',
      args: [],
    );
  }

  String get newest {
    return Intl.message(
      'Newest',
      name: 'newest',
      desc: '',
      args: [],
    );
  }

  String get saved_list_empty {
    return Intl.message(
      'Saved list is empty',
      name: 'saved_list_empty',
      desc: '',
      args: [],
    );
  }

  String get change_language_success {
    return Intl.message(
      'Change language successfully',
      name: 'change_language_success',
      desc: '',
      args: [],
    );
  }

  String change_language_error(dynamic error) {
    return Intl.message(
      'Error when chane language: $error',
      name: 'change_language_error',
      desc: '',
      args: [error],
    );
  }

  String get change_language_failure {
    return Intl.message(
      'Error when chane language',
      name: 'change_language_failure',
      desc: '',
      args: [],
    );
  }

  String remove_saved_room_success_with_title(dynamic title) {
    return Intl.message(
      'Remove room \'$title\' from saved list successfully',
      name: 'remove_saved_room_success_with_title',
      desc: '',
      args: [title],
    );
  }

  String get remove_saved_room_error {
    return Intl.message(
      'Error when remove room from saved list',
      name: 'remove_saved_room_error',
      desc: '',
      args: [],
    );
  }

  String get removed {
    return Intl.message(
      'Removed',
      name: 'removed',
      desc: '',
      args: [],
    );
  }

  String get error_occurred {
    return Intl.message(
      'An error occurred',
      name: 'error_occurred',
      desc: '',
      args: [],
    );
  }

  String get require_login {
    return Intl.message(
      'You must be signed in',
      name: 'require_login',
      desc: '',
      args: [],
    );
  }

  String change_province_success(dynamic provinceName) {
    return Intl.message(
      'Change to \'$provinceName\' successfully',
      name: 'change_province_success',
      desc: '',
      args: [provinceName],
    );
  }

  String change_province_error(dynamic provinceName) {
    return Intl.message(
      'Error when change to \'$provinceName\'',
      name: 'change_province_error',
      desc: '',
      args: [provinceName],
    );
  }

  String get add_saved_room_success {
    return Intl.message(
      'Added to saved list successfully',
      name: 'add_saved_room_success',
      desc: '',
      args: [],
    );
  }

  String get remove_saved_room_success {
    return Intl.message(
      'Remove from saved list successfully',
      name: 'remove_saved_room_success',
      desc: '',
      args: [],
    );
  }

  String get add_or_remove_saved_room_error {
    return Intl.message(
      'An error occurred. Try again later',
      name: 'add_or_remove_saved_room_error',
      desc: '',
      args: [],
    );
  }

  String get logout_error {
    return Intl.message(
      'An error occurred when logout',
      name: 'logout_error',
      desc: '',
      args: [],
    );
  }

  String get logout_success {
    return Intl.message(
      'Logout successfully',
      name: 'logout_success',
      desc: '',
      args: [],
    );
  }

  String get login_success {
    return Intl.message(
      'Login successfully',
      name: 'login_success',
      desc: '',
      args: [],
    );
  }

  String get password_at_least_6_characters {
    return Intl.message(
      'Password at least 6 characters',
      name: 'password_at_least_6_characters',
      desc: '',
      args: [],
    );
  }

  String get invalid_email_address {
    return Intl.message(
      'Invalid email address',
      name: 'invalid_email_address',
      desc: '',
      args: [],
    );
  }

  String get network_error {
    return Intl.message(
      'A network error (such as timeout, interrupted connection or unreachable host) has occurred',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  String get too_many_requests_error {
    return Intl.message(
      'Too many requests',
      name: 'too_many_requests_error',
      desc: '',
      args: [],
    );
  }

  String get user_not_found_error {
    return Intl.message(
      'There is no user record corresponding to this identifier. The user may have been deleted',
      name: 'user_not_found_error',
      desc: '',
      args: [],
    );
  }

  String get wrong_password_error {
    return Intl.message(
      'The password is invalid or the user does not have a password',
      name: 'wrong_password_error',
      desc: '',
      args: [],
    );
  }

  String get invalid_email_error {
    return Intl.message(
      'The email address is badly formatted',
      name: 'invalid_email_error',
      desc: '',
      args: [],
    );
  }

  String get email_already_in_user_error {
    return Intl.message(
      'The email address is already in use by another account',
      name: 'email_already_in_user_error',
      desc: '',
      args: [],
    );
  }

  String get weak_password_error {
    return Intl.message(
      'The given password is invalid',
      name: 'weak_password_error',
      desc: '',
      args: [],
    );
  }

  String get user_disabled_error {
    return Intl.message(
      'The user account has been disabled by an administrator',
      name: 'user_disabled_error',
      desc: '',
      args: [],
    );
  }

  String get invalid_credential_error {
    return Intl.message(
      'Invalid credential',
      name: 'invalid_credential_error',
      desc: '',
      args: [],
    );
  }

  String get account_exists_with_difference_credential_error {
    return Intl.message(
      'Account exists with difference credential error',
      name: 'account_exists_with_difference_credential_error',
      desc: '',
      args: [],
    );
  }

  String get operation_not_allowed_error {
    return Intl.message(
      'Operation not allowed',
      name: 'operation_not_allowed_error',
      desc: '',
      args: [],
    );
  }

  String get google_sign_in_canceled_error {
    return Intl.message(
      'Google sign in canceled',
      name: 'google_sign_in_canceled_error',
      desc: '',
      args: [],
    );
  }

  String get facebook_login_cancelled_by_user {
    return Intl.message(
      'Facebook sign in canceled by user',
      name: 'facebook_login_cancelled_by_user',
      desc: '',
      args: [],
    );
  }

  String get full_name_at_least_6_characters {
    return Intl.message(
      'Full name at least 6 characters',
      name: 'full_name_at_least_6_characters',
      desc: '',
      args: [],
    );
  }

  String get full_name {
    return Intl.message(
      'Full name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  String get invalid_phone_number {
    return Intl.message(
      'Invalid phone number',
      name: 'invalid_phone_number',
      desc: '',
      args: [],
    );
  }

  String get empty_address {
    return Intl.message(
      'Address must be not empty',
      name: 'empty_address',
      desc: '',
      args: [],
    );
  }

  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  String get phone_number {
    return Intl.message(
      'Phone number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  String get exit_register {
    return Intl.message(
      'Exit register',
      name: 'exit_register',
      desc: '',
      args: [],
    );
  }

  String get exit_register_message {
    return Intl.message(
      'Processing register...Are you sure you want to exit?',
      name: 'exit_register_message',
      desc: '',
      args: [],
    );
  }

  String get register_success {
    return Intl.message(
      'Register successfully',
      name: 'register_success',
      desc: '',
      args: [],
    );
  }

  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  String get exit_login {
    return Intl.message(
      'Exit login',
      name: 'exit_login',
      desc: '',
      args: [],
    );
  }

  String get exit_login_message {
    return Intl.message(
      'Processing login...Are you sure you want to exit?',
      name: 'exit_login_message',
      desc: '',
      args: [],
    );
  }

  String get send_email {
    return Intl.message(
      'Send email',
      name: 'send_email',
      desc: '',
      args: [],
    );
  }

  String get forgot_password_title {
    return Intl.message(
      'Forgot password',
      name: 'forgot_password_title',
      desc: '',
      args: [],
    );
  }

  String get exit_send_email {
    return Intl.message(
      'Exit reset password',
      name: 'exit_send_email',
      desc: '',
      args: [],
    );
  }

  String get exit_send_email_message {
    return Intl.message(
      'Processing send email...Are you sure you want to exit?',
      name: 'exit_send_email_message',
      desc: '',
      args: [],
    );
  }

  String get send_password_reset_email_success {
    return Intl.message(
      'Send password reset email success',
      name: 'send_password_reset_email_success',
      desc: '',
      args: [],
    );
  }

  String get edit_profile {
    return Intl.message(
      'Edit profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  String get user_profile {
    return Intl.message(
      'User profile',
      name: 'user_profile',
      desc: '',
      args: [],
    );
  }

  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  String get exit_update_password {
    return Intl.message(
      'Exit update password',
      name: 'exit_update_password',
      desc: '',
      args: [],
    );
  }

  String get processing_update_passwordare_you_sure_you_want_to_exit {
    return Intl.message(
      'Processing update password...Are you sure you want to exit?',
      name: 'processing_update_passwordare_you_sure_you_want_to_exit',
      desc: '',
      args: [],
    );
  }

  String get change_password_successfully {
    return Intl.message(
      'Change password successfully',
      name: 'change_password_successfully',
      desc: '',
      args: [],
    );
  }

  String get unknown_error {
    return Intl.message(
      'Unknown error',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  String get weak_password {
    return Intl.message(
      'Weak password',
      name: 'weak_password',
      desc: '',
      args: [],
    );
  }

  String get user_disabled {
    return Intl.message(
      'User disabled',
      name: 'user_disabled',
      desc: '',
      args: [],
    );
  }

  String get user_not_found {
    return Intl.message(
      'User not found',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  String get requires_recent_login {
    return Intl.message(
      'Requires recent login',
      name: 'requires_recent_login',
      desc: '',
      args: [],
    );
  }

  String get operation_not_allowed {
    return Intl.message(
      'Operation not allowed',
      name: 'operation_not_allowed',
      desc: '',
      args: [],
    );
  }

  String change_password_not_successfully_error_messagetext(dynamic messageText) {
    return Intl.message(
      'Change password not successfully, error: $messageText',
      name: 'change_password_not_successfully_error_messagetext',
      desc: '',
      args: [messageText],
    );
  }

  String get invalid_password {
    return Intl.message(
      'Invalid password',
      name: 'invalid_password',
      desc: '',
      args: [],
    );
  }

  String get submit_changes {
    return Intl.message(
      'Submit changes',
      name: 'submit_changes',
      desc: '',
      args: [],
    );
  }

  String get exit_update_user_info {
    return Intl.message(
      'Exit update user info',
      name: 'exit_update_user_info',
      desc: '',
      args: [],
    );
  }

  String get processing_update_infoare_you_sure_you_want_to_exit {
    return Intl.message(
      'Processing update info...Are you sure you want to exit?',
      name: 'processing_update_infoare_you_sure_you_want_to_exit',
      desc: '',
      args: [],
    );
  }

  String get invalid_information {
    return Intl.message(
      'Invalid information',
      name: 'invalid_information',
      desc: '',
      args: [],
    );
  }

  String get uknown_error {
    return Intl.message(
      'Unknown error',
      name: 'uknown_error',
      desc: '',
      args: [],
    );
  }

  String get update_successfully {
    return Intl.message(
      'Update successfully',
      name: 'update_successfully',
      desc: '',
      args: [],
    );
  }

  String get update_user_info {
    return Intl.message(
      'Update user info',
      name: 'update_user_info',
      desc: '',
      args: [],
    );
  }

  String get user_information {
    return Intl.message(
      'User information',
      name: 'user_information',
      desc: '',
      args: [],
    );
  }

  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  String get inactive {
    return Intl.message(
      'Inactive',
      name: 'inactive',
      desc: '',
      args: [],
    );
  }

  String get joined_date {
    return Intl.message(
      'Joined date',
      name: 'joined_date',
      desc: '',
      args: [],
    );
  }

  String get last_updated {
    return Intl.message(
      'Last updated',
      name: 'last_updated',
      desc: '',
      args: [],
    );
  }

  String get posted_rooms_ {
    return Intl.message(
      'Posted rooms:',
      name: 'posted_rooms_',
      desc: '',
      args: [],
    );
  }

  String created_date(dynamic date) {
    return Intl.message(
      'Created: $date',
      name: 'created_date',
      desc: '',
      args: [date],
    );
  }

  String last_updated_date(dynamic date) {
    return Intl.message(
      'Updated: $date',
      name: 'last_updated_date',
      desc: '',
      args: [date],
    );
  }

  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', ''), Locale('vi', ''),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}