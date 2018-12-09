import 'package:find_room/bloc/home_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class SharedPrefUtil {
  static const _kSelectedProvinceId = 'com.hoc.findroom.selected_province_id';
  static const _kSelectedProvinceName =
      'com.hoc.findroom.selected_province_name';

  static const _kDaNangId = 'NtHjwobYdIi0YwTUHz05';
  static const _kDaNangName = 'TP. Đà Nẵng';

  Stream<Province> get selectedProvince => _selectedProvinceController.stream;
  final _selectedProvinceController = BehaviorSubject<Province>();

  static final SharedPrefUtil instance = SharedPrefUtil._();

  SharedPrefUtil._() {
    SharedPreferences.getInstance().then((preferences) {
      var id = preferences.getString(_kSelectedProvinceId);
      var name = preferences.getString(_kSelectedProvinceName);
      var province = id != null && name != null
          ? Province(
              id: id,
              name: name,
            )
          : Province(
              id: _kDaNangId,
              name: _kDaNangName,
            );
      _selectedProvinceController.add(province);
      debugPrint('##DEBUG SharedPrefUtil._ added province=$province');
    });
  }

  saveSelectedProvince(Province province) async {
    var preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setString(_kSelectedProvinceId, province.id),
      preferences.setString(_kSelectedProvinceName, province.name),
    ]);
    _selectedProvinceController.add(province);
  }
}
