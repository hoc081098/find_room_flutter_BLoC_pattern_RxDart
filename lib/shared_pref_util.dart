import 'package:find_room/models/province.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static const _kSelectedProvinceId = 'com.hoc.findroom.selected_province_id';
  static const _kSelectedProvinceName =
      'com.hoc.findroom.selected_province_name';

  static const _kDaNangId = 'NtHjwobYdIi0YwTUHz05';
  static const _kDaNangName = 'TP. Đà Nẵng';

  static final SharedPrefUtil instance = SharedPrefUtil._();

  final _selectedProvinceController = BehaviorSubject<Province>();

  ValueObservable<Province> get selectedProvince =>
      _selectedProvinceController.stream;

  SharedPrefUtil._() {
    SharedPreferences.getInstance().then((preferences) {
      final id = preferences.getString(_kSelectedProvinceId);
      final name = preferences.getString(_kSelectedProvinceName);
      final province = id != null && name != null
          ? Province(id: id, name: name)
          : Province(id: _kDaNangId, name: _kDaNangName);
      _selectedProvinceController.add(province);

      print('##DEBUG SharedPrefUtil._ added province=$province');
    });
  }

  Future<void> saveSelectedProvince(Province province) async {
    final preferences = await SharedPreferences.getInstance();
    final list = await Future.wait([
      preferences.setString(_kSelectedProvinceId, province.id),
      preferences.setString(_kSelectedProvinceName, province.name),
    ]);
    if (list.reduce((acc, e) => acc && e)) {
      print('##DEBUG saveSelectedProvince province=$province');
      _selectedProvinceController.add(province);
    } else {
      print('##DEBUG saveSelectedProvince error');
    }
  }
}
