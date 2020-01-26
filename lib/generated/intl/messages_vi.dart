// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
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
  String get localeName => 'vi';

  static m0(error) => "Lỗi khi thay đổi ngôn ngữ: ${error}";

  static m1(messageText) => "Thay đổi mật khẩu không thành công, lỗi: ${messageText}";

  static m2(provinceName) => "Lỗi xảy ra khi chuyển sang \'${provinceName}\'";

  static m3(provinceName) => "Chuyển sang \'${provinceName}\' thành công";

  static m4(date) => "Tạo: ${date}";

  static m5(date) => "Cập nhật: ${date}";

  static m6(title) => "Xóa \'${title}\' khỏi danh sách đã lưu thành công";

  static m7(title) => "Xem tất cả: ${title}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "account_exists_with_difference_credential_error" : MessageLookupByLibrary.simpleMessage("Tài khoản tồn tại với khác nhau"),
    "active" : MessageLookupByLibrary.simpleMessage("Hoạt động"),
    "add_or_remove_saved_room_error" : MessageLookupByLibrary.simpleMessage("Đã có lỗi xảy ra. Hãy thử lại"),
    "add_saved_room_success" : MessageLookupByLibrary.simpleMessage("Thêm vào danh sách đã lưu thành công"),
    "add_to_saved" : MessageLookupByLibrary.simpleMessage("Thêm vào đã lưu"),
    "address" : MessageLookupByLibrary.simpleMessage("Địa chỉ"),
    "app_title" : MessageLookupByLibrary.simpleMessage("Phòng trọ tốt"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Hủy"),
    "change_language" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ"),
    "change_language_error" : m0,
    "change_language_failure" : MessageLookupByLibrary.simpleMessage("Lỗi khi thay đổi ngôn ngữ"),
    "change_language_success" : MessageLookupByLibrary.simpleMessage("Thay đổi ngôn ngữ thành công"),
    "change_password" : MessageLookupByLibrary.simpleMessage("Thay đổi mật khẩu"),
    "change_password_not_successfully_error_messagetext" : m1,
    "change_password_successfully" : MessageLookupByLibrary.simpleMessage("Thay đổi mật khẩu thành công"),
    "change_province_error" : m2,
    "change_province_success" : m3,
    "created_date" : m4,
    "detail_title" : MessageLookupByLibrary.simpleMessage("Chi tiết"),
    "edit_profile" : MessageLookupByLibrary.simpleMessage("Chỉnh sửa thông tin"),
    "email" : MessageLookupByLibrary.simpleMessage("Email"),
    "email_already_in_user_error" : MessageLookupByLibrary.simpleMessage("Địa chỉ email đã được một tài khoản khác sử dụng"),
    "empty_address" : MessageLookupByLibrary.simpleMessage("Địa chỉ trống"),
    "empty_rooms" : MessageLookupByLibrary.simpleMessage("Chưa có nhà trọ nào..."),
    "error_occurred" : MessageLookupByLibrary.simpleMessage("Có lỗi xảy ra"),
    "exit" : MessageLookupByLibrary.simpleMessage("Thoát"),
    "exit_app" : MessageLookupByLibrary.simpleMessage("Thoát khỏi ứng dụng"),
    "exit_login" : MessageLookupByLibrary.simpleMessage("Bạn muốn thoát đăng nhập"),
    "exit_login_message" : MessageLookupByLibrary.simpleMessage("Đang xử lí đăng nhập... bạn có chắc chắn muốn thoát?"),
    "exit_register" : MessageLookupByLibrary.simpleMessage("Bạn muốn thoát đăng kí"),
    "exit_register_message" : MessageLookupByLibrary.simpleMessage("Đang xử lí đăng kí... bạn có chắc chắn muốn thoát?"),
    "exit_send_email" : MessageLookupByLibrary.simpleMessage("Bạn muốn thoát gửi email reset mật khẩu?"),
    "exit_send_email_message" : MessageLookupByLibrary.simpleMessage("Đang xử lí gửi email reset mật khẩu... bạn có chắc chắn muốn thoát?"),
    "exit_update_password" : MessageLookupByLibrary.simpleMessage("Thoát cập nhật mật khẩu"),
    "exit_update_user_info" : MessageLookupByLibrary.simpleMessage("Thoát cập nhật thông tin người dùng"),
    "facebook_login_cancelled_by_user" : MessageLookupByLibrary.simpleMessage("Đăng nhập bằng facebook bị hủy bởi người dùng"),
    "forgot_password" : MessageLookupByLibrary.simpleMessage("Bạn quên mật khẩu?"),
    "forgot_password_title" : MessageLookupByLibrary.simpleMessage("Quên mật khẩu"),
    "full_name" : MessageLookupByLibrary.simpleMessage("Họ tên"),
    "full_name_at_least_6_characters" : MessageLookupByLibrary.simpleMessage("Tên ít nhất 6 kí tự"),
    "google_sign_in_canceled_error" : MessageLookupByLibrary.simpleMessage("Đăng nhập bằng google bị hủy"),
    "home_page_title" : MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "inactive" : MessageLookupByLibrary.simpleMessage("Không hoạt động"),
    "invalid_credential_error" : MessageLookupByLibrary.simpleMessage("Thông tin đăng nhập không hợp lệ"),
    "invalid_email_address" : MessageLookupByLibrary.simpleMessage("Sai định dạng email"),
    "invalid_email_error" : MessageLookupByLibrary.simpleMessage("Địa chỉ email bị định dạng sai"),
    "invalid_information" : MessageLookupByLibrary.simpleMessage("Thông tin không hợp lệ"),
    "invalid_password" : MessageLookupByLibrary.simpleMessage("Mật khẩu không hợp lệ"),
    "invalid_phone_number" : MessageLookupByLibrary.simpleMessage("Sai định dạng SĐT"),
    "joined_date" : MessageLookupByLibrary.simpleMessage("Ngày tham gia"),
    "last_updated" : MessageLookupByLibrary.simpleMessage("Cập nhật"),
    "last_updated_date" : m5,
    "loading" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "login_now" : MessageLookupByLibrary.simpleMessage("Đăng nhập ngay"),
    "login_success" : MessageLookupByLibrary.simpleMessage("Đăng nhập thành công"),
    "login_title" : MessageLookupByLibrary.simpleMessage("Đăng nhập"),
    "logout" : MessageLookupByLibrary.simpleMessage("Đăng xuất"),
    "logout_error" : MessageLookupByLibrary.simpleMessage("Lỗi xảy ra khi đăng xuất"),
    "logout_success" : MessageLookupByLibrary.simpleMessage("Đăng xuất thành công"),
    "mostViewed" : MessageLookupByLibrary.simpleMessage("Xem nhiều"),
    "network_error" : MessageLookupByLibrary.simpleMessage("Lỗi kết nối mạng"),
    "newest" : MessageLookupByLibrary.simpleMessage("Mới nhất"),
    "no" : MessageLookupByLibrary.simpleMessage("Không"),
    "no_account" : MessageLookupByLibrary.simpleMessage("Chưa có tài khoản?"),
    "operation_not_allowed" : MessageLookupByLibrary.simpleMessage("Hoạt động không cho phép"),
    "operation_not_allowed_error" : MessageLookupByLibrary.simpleMessage("Hoạt động không được cho phép"),
    "or_connect_through" : MessageLookupByLibrary.simpleMessage("hoặc kết nối qua"),
    "password" : MessageLookupByLibrary.simpleMessage("Mật khẩu *"),
    "password_at_least_6_characters" : MessageLookupByLibrary.simpleMessage("Mật khẩu ít nhất 6 kí tự"),
    "phone" : MessageLookupByLibrary.simpleMessage("Điện thoại"),
    "phone_number" : MessageLookupByLibrary.simpleMessage("SĐT"),
    "posted_rooms_" : MessageLookupByLibrary.simpleMessage("Phòng đã đăng:"),
    "processing_update_infoare_you_sure_you_want_to_exit" : MessageLookupByLibrary.simpleMessage("Xử lý thông tin cập nhật ... Bạn có chắc chắn muốn thoát?"),
    "processing_update_passwordare_you_sure_you_want_to_exit" : MessageLookupByLibrary.simpleMessage("Xử lý mật khẩu cập nhật ... Bạn có chắc chắn muốn thoát?"),
    "register" : MessageLookupByLibrary.simpleMessage("Đăng kí"),
    "register_now" : MessageLookupByLibrary.simpleMessage("Đăng kí ngay"),
    "register_success" : MessageLookupByLibrary.simpleMessage("Đăng kí thành công"),
    "remove_from_saved" : MessageLookupByLibrary.simpleMessage("Xóa khỏi đã lưu"),
    "remove_saved_room_error" : MessageLookupByLibrary.simpleMessage("Lỗi khi xóa khỏi danh sách đã lưu"),
    "remove_saved_room_success" : MessageLookupByLibrary.simpleMessage("Xóa khỏi danh sách đã lưu thành công"),
    "remove_saved_room_success_with_title" : m6,
    "removed" : MessageLookupByLibrary.simpleMessage("Xóa"),
    "require_login" : MessageLookupByLibrary.simpleMessage("Bạn cần phải đăng nhập"),
    "requires_recent_login" : MessageLookupByLibrary.simpleMessage("Yêu cầu đăng nhập gần đây"),
    "saved_list_empty" : MessageLookupByLibrary.simpleMessage("Bạn chưa lưu nhà trọ nào"),
    "saved_rooms_title" : MessageLookupByLibrary.simpleMessage("Đã lưu"),
    "see_all" : MessageLookupByLibrary.simpleMessage("Xem tất cả"),
    "see_all_" : m7,
    "send_email" : MessageLookupByLibrary.simpleMessage("Gửi"),
    "send_password_reset_email_success" : MessageLookupByLibrary.simpleMessage("Gửi email reset mật khẩu thành công"),
    "settings" : MessageLookupByLibrary.simpleMessage("Cài đặt"),
    "settings_title" : MessageLookupByLibrary.simpleMessage("Cài đặt"),
    "status" : MessageLookupByLibrary.simpleMessage("Trạng thái"),
    "submit_changes" : MessageLookupByLibrary.simpleMessage("Gửi thay đổi"),
    "sure_want_to_exit_app" : MessageLookupByLibrary.simpleMessage("Bạn chắc chắn muốn thoát khỏi ứng dụng?"),
    "sure_want_to_logout" : MessageLookupByLibrary.simpleMessage("Bạn chắc chắn muốn đăng xuất?"),
    "too_many_requests_error" : MessageLookupByLibrary.simpleMessage("Quá nhiều request"),
    "uknown_error" : MessageLookupByLibrary.simpleMessage("Lỗi không rõ"),
    "unknown_error" : MessageLookupByLibrary.simpleMessage("Lỗi không rõ"),
    "update_successfully" : MessageLookupByLibrary.simpleMessage("Cập nhật thành công"),
    "update_user_info" : MessageLookupByLibrary.simpleMessage("Cập nhật thông tin người dùng"),
    "user_disabled" : MessageLookupByLibrary.simpleMessage("Người dùng bị vô hiệu hóa"),
    "user_disabled_error" : MessageLookupByLibrary.simpleMessage("Tài khoản người dùng đã bị quản trị viên vô hiệu hóa"),
    "user_information" : MessageLookupByLibrary.simpleMessage("Thông tin người dùng"),
    "user_not_found" : MessageLookupByLibrary.simpleMessage("Không tìm thấy người dùng"),
    "user_not_found_error" : MessageLookupByLibrary.simpleMessage("Không có người dùng nào tương ứng với số nhận dạng này. Người dùng có thể đã bị xóa"),
    "user_profile" : MessageLookupByLibrary.simpleMessage("Thông tin tài khoản"),
    "weak_password" : MessageLookupByLibrary.simpleMessage("Mật khẩu yếu"),
    "weak_password_error" : MessageLookupByLibrary.simpleMessage("Mật khẩu đã cho không hợp lệ"),
    "wrong_password_error" : MessageLookupByLibrary.simpleMessage("Mật khẩu không hợp lệ hoặc người dùng không có mật khẩu")
  };
}
