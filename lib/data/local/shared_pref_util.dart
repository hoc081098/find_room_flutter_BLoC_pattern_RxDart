import 'package:find_room/data/local/local_data_source.dart';
import 'package:find_room/models/province.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil implements LocalDataSource {
  static const _kSelectedProvinceId = 'com.hoc.findroom.selected_province_id';
  static const _kSelectedProvinceName =
      'com.hoc.findroom.selected_province_name';
  static const _kSelectedLanguageCode =
      'com.hoc.findroom.selected_language_code';

  static const _kDaNangId = 'NtHjwobYdIi0YwTUHz05';
  static const _kDaNangName = 'TP. Đà Nẵng';

  static const _kDaNang = Province(id: _kDaNangId, name: _kDaNangName);
  static const _kEnglishCode = 'en';

  final _selectedProvinceController = BehaviorSubject<Province>();
  final _selectedLanguageCodeController = BehaviorSubject<String>();
  final Future<SharedPreferences> _prefsFuture;

  SharedPrefUtil(this._prefsFuture) {
    _prefsFuture.then((preferences) {
      _loadSelectedProvince(preferences);
      _loadSelectedLanguageCode(preferences);
    });
  }

  void _loadSelectedProvince(SharedPreferences preferences) {
    final id = preferences.getString(_kSelectedProvinceId);
    final name = preferences.getString(_kSelectedProvinceName);
    final province =
        id != null && name != null ? Province(id: id, name: name) : _kDaNang;
    _selectedProvinceController.add(province);
    print('[DEBUG] selectedProvince=$province');
  }

  void _loadSelectedLanguageCode(SharedPreferences preferences) {
    final selectedLanguageCode =
        preferences.getString(_kSelectedLanguageCode) ?? _kEnglishCode;
    _selectedLanguageCodeController.add(selectedLanguageCode);
    print('[DEBUG] selectedLanguageCode=$selectedLanguageCode');
  }

  @override
  ValueStream<Province> get selectedProvince$ =>
      _selectedProvinceController.stream;

  @override
  ValueStream<String> get selectedLanguageCode$ =>
      _selectedLanguageCodeController.stream;

  @override
  Future<bool> saveSelectedProvince(Province province) async {
    final preferences = await _prefsFuture;
    final list = await Future.wait([
      preferences.setString(_kSelectedProvinceId, province.id),
      preferences.setString(_kSelectedProvinceName, province.name),
    ]);
    final result = list.reduce((acc, e) => acc && e);
    if (result) {
      print('[DEBUG] saveSelectedProvince(province=$province) [success]');
      _selectedProvinceController.add(province);
    } else {
      print('[DEBUG] saveSelectedProvince(province=$province) [error]');
    }
    return result;
  }

  @override
  Future<bool> saveSelectedLanguageCode(String languageCode) async {
    final preferences = await _prefsFuture;
    final result =
        await preferences.setString(_kSelectedLanguageCode, languageCode);
    if (result) {
      print(
          '[DEBUG] saveSelectedLanguageCode(languageCode=$languageCode) [success]');
      _selectedLanguageCodeController.add(languageCode);
    } else {
      print(
          '[DEBUG] saveSelectedLanguageCode(languageCode=$languageCode) [error]');
    }
    return result;
  }
}
