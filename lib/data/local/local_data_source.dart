import 'package:find_room/models/province.dart';
import 'package:rxdart/rxdart.dart';

abstract class LocalDataSource {
  ValueObservable<Province> get selectedProvince$;

  ValueObservable<String> get selectedLanguageCode$;

  Future<bool> saveSelectedProvince(Province province);

  Future<bool> saveSelectedLanguageCode(String languageCode);
}
