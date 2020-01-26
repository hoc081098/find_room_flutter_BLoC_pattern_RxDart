// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(error) => "Error when chane language: ${error}";

  static m1(messageText) => "Change password not successfully, error: ${messageText}";

  static m2(provinceName) => "Error when change to \'${provinceName}\'";

  static m3(provinceName) => "Change to \'${provinceName}\' successfully";

  static m4(date) => "Created: ${date}";

  static m5(date) => "Updated: ${date}";

  static m6(title) => "Remove room \'${title}\' from saved list successfully";

  static m7(title) => "See all: ${title}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "account_exists_with_difference_credential_error" : MessageLookupByLibrary.simpleMessage("Account exists with difference credential error"),
    "active" : MessageLookupByLibrary.simpleMessage("Active"),
    "add_or_remove_saved_room_error" : MessageLookupByLibrary.simpleMessage("An error occurred. Try again later"),
    "add_saved_room_success" : MessageLookupByLibrary.simpleMessage("Added to saved list successfully"),
    "add_to_saved" : MessageLookupByLibrary.simpleMessage("Add to saved"),
    "address" : MessageLookupByLibrary.simpleMessage("Address"),
    "app_title" : MessageLookupByLibrary.simpleMessage("Find room"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Change language"),
    "change_language_error" : m0,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Error when chane language"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Change language successfully"),
    "change_password" : MessageLookupByLibrary.simpleMessage("Change password"),
    "change_password_not_successfully_error_messagetext" : m1,
    "change_password_successfully" : MessageLookupByLibrary.simpleMessage("Change password successfully"),
    "change_province_error" : m2,
    "change_province_success" : m3,
    "created_date" : m4,
    "detail_title" : MessageLookupByLibrary.simpleMessage("Detail"),
    "edit_profile" : MessageLookupByLibrary.simpleMessage("Edit profile"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "email_already_in_user_error" : MessageLookupByLibrary.simpleMessage("The email address is already in use by another account"),
    "empty_address" : MessageLookupByLibrary.simpleMessage("Address must be not empty"),
    "empty_rooms" : MessageLookupByLibrary.simpleMessage("Empty rooms..."),
    "error_occurred" : MessageLookupByLibrary.simpleMessage("An error occurred"),
    "exit" : MessageLookupByLibrary.simpleMessage("Exit"),
    "exit_app" : MessageLookupByLibrary.simpleMessage("Exit app"),
    "exit_login" : MessageLookupByLibrary.simpleMessage("Exit login"),
    "exit_login_message" : MessageLookupByLibrary.simpleMessage("Processing login...Are you sure you want to exit?"),
    "exit_register" : MessageLookupByLibrary.simpleMessage("Exit register"),
    "exit_register_message" : MessageLookupByLibrary.simpleMessage("Processing register...Are you sure you want to exit?"),
    "exit_send_email" : MessageLookupByLibrary.simpleMessage("Exit reset password"),
    "exit_send_email_message" : MessageLookupByLibrary.simpleMessage("Processing send email...Are you sure you want to exit?"),
    "exit_update_password" : MessageLookupByLibrary.simpleMessage("Exit update password"),
    "exit_update_user_info" : MessageLookupByLibrary.simpleMessage("Exit update user info"),
    "facebook_login_cancelled_by_user" : MessageLookupByLibrary.simpleMessage("Facebook sign in canceled by user"),
    "forgot_password" : MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "forgot_password_title" : MessageLookupByLibrary.simpleMessage("Forgot password"),
    "full_name" : MessageLookupByLibrary.simpleMessage("Full name"),
    "full_name_at_least_6_characters" : MessageLookupByLibrary.simpleMessage("Full name at least 6 characters"),
    "google_sign_in_canceled_error" : MessageLookupByLibrary.simpleMessage("Google sign in canceled"),
    "home_page_title" : MessageLookupByLibrary.simpleMessage("Home page"),
    "inactive" : MessageLookupByLibrary.simpleMessage("Inactive"),
    "invalid_credential_error" : MessageLookupByLibrary.simpleMessage("Invalid credential"),
    "invalid_email_address" : MessageLookupByLibrary.simpleMessage("Invalid email address"),
    "invalid_email_error" : MessageLookupByLibrary.simpleMessage("The email address is badly formatted"),
    "invalid_information" : MessageLookupByLibrary.simpleMessage("Invalid information"),
    "invalid_password" : MessageLookupByLibrary.simpleMessage("Invalid password"),
    "invalid_phone_number" : MessageLookupByLibrary.simpleMessage("Invalid phone number"),
    "joined_date" : MessageLookupByLibrary.simpleMessage("Joined date"),
    "last_updated" : MessageLookupByLibrary.simpleMessage("Last updated"),
    "last_updated_date" : m5,
    "loading" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "login_now" : MessageLookupByLibrary.simpleMessage("Login now"),
    "login_success" : MessageLookupByLibrary.simpleMessage("Login successfully"),
    "login_title" : MessageLookupByLibrary.simpleMessage("Login"),
    "logout" : MessageLookupByLibrary.simpleMessage("Logout"),
    "logout_error" : MessageLookupByLibrary.simpleMessage("An error occurred when logout"),
    "logout_success" : MessageLookupByLibrary.simpleMessage("Logout successfully"),
    "mostViewed" : MessageLookupByLibrary.simpleMessage("Most viewed"),
    "network_error" : MessageLookupByLibrary.simpleMessage("A network error (such as timeout, interrupted connection or unreachable host) has occurred"),
    "newest" : MessageLookupByLibrary.simpleMessage("Newest"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "no_account" : MessageLookupByLibrary.simpleMessage("No account?"),
    "operation_not_allowed" : MessageLookupByLibrary.simpleMessage("Operation not allowed"),
    "operation_not_allowed_error" : MessageLookupByLibrary.simpleMessage("Operation not allowed"),
    "or_connect_through" : MessageLookupByLibrary.simpleMessage("Or connect through"),
    "password" : MessageLookupByLibrary.simpleMessage("Password *"),
    "password_at_least_6_characters" : MessageLookupByLibrary.simpleMessage("Password at least 6 characters"),
    "phone" : MessageLookupByLibrary.simpleMessage("Phone"),
    "phone_number" : MessageLookupByLibrary.simpleMessage("Phone number"),
    "posted_rooms_" : MessageLookupByLibrary.simpleMessage("Posted rooms:"),
    "processing_update_infoare_you_sure_you_want_to_exit" : MessageLookupByLibrary.simpleMessage("Processing update info...Are you sure you want to exit?"),
    "processing_update_passwordare_you_sure_you_want_to_exit" : MessageLookupByLibrary.simpleMessage("Processing update password...Are you sure you want to exit?"),
    "register" : MessageLookupByLibrary.simpleMessage("Register"),
    "register_now" : MessageLookupByLibrary.simpleMessage("Register now"),
    "register_success" : MessageLookupByLibrary.simpleMessage("Register successfully"),
    "remove_from_saved" : MessageLookupByLibrary.simpleMessage("Remove from saved"),
    "remove_saved_room_error" : MessageLookupByLibrary.simpleMessage("Error when remove room from saved list"),
    "remove_saved_room_success" : MessageLookupByLibrary.simpleMessage("Remove from saved list successfully"),
    "remove_saved_room_success_with_title" : m6,
    "removed" : MessageLookupByLibrary.simpleMessage("Removed"),
    "require_login" : MessageLookupByLibrary.simpleMessage("You must be signed in"),
    "requires_recent_login" : MessageLookupByLibrary.simpleMessage("Requires recent login"),
    "saved_list_empty" : MessageLookupByLibrary.simpleMessage("Saved list is empty"),
    "saved_rooms_title" : MessageLookupByLibrary.simpleMessage("Saved rooms"),
    "see_all" : MessageLookupByLibrary.simpleMessage("See all"),
    "see_all_" : m7,
    "send_email" : MessageLookupByLibrary.simpleMessage("Send email"),
    "send_password_reset_email_success" : MessageLookupByLibrary.simpleMessage("Send password reset email success"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settings_title" : MessageLookupByLibrary.simpleMessage("Settings"),
    "status" : MessageLookupByLibrary.simpleMessage("Status"),
    "submit_changes" : MessageLookupByLibrary.simpleMessage("Submit changes"),
    "sure_want_to_exit_app" : MessageLookupByLibrary.simpleMessage("Are you sure you want to exit the application?"),
    "sure_want_to_logout" : MessageLookupByLibrary.simpleMessage("Are you sure you want to logout?"),
    "too_many_requests_error" : MessageLookupByLibrary.simpleMessage("Too many requests"),
    "uknown_error" : MessageLookupByLibrary.simpleMessage("Unknown error"),
    "unknown_error" : MessageLookupByLibrary.simpleMessage("Unknown error"),
    "update_successfully" : MessageLookupByLibrary.simpleMessage("Update successfully"),
    "update_user_info" : MessageLookupByLibrary.simpleMessage("Update user info"),
    "user_disabled" : MessageLookupByLibrary.simpleMessage("User disabled"),
    "user_disabled_error" : MessageLookupByLibrary.simpleMessage("The user account has been disabled by an administrator"),
    "user_information" : MessageLookupByLibrary.simpleMessage("User information"),
    "user_not_found" : MessageLookupByLibrary.simpleMessage("User not found"),
    "user_not_found_error" : MessageLookupByLibrary.simpleMessage("There is no user record corresponding to this identifier. The user may have been deleted"),
    "user_profile" : MessageLookupByLibrary.simpleMessage("User profile"),
    "weak_password" : MessageLookupByLibrary.simpleMessage("Weak password"),
    "weak_password_error" : MessageLookupByLibrary.simpleMessage("The given password is invalid"),
    "wrong_password_error" : MessageLookupByLibrary.simpleMessage("The password is invalid or the user does not have a password")
  };
}
