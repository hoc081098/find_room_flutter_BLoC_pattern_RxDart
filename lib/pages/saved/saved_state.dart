import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SavedListState {}

class Loading implements SavedListState {}

class SavedList implements SavedListState {
  final List<RoomItem> roomItems;

  const SavedList(this.roomItems);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedList &&
          runtimeType == other.runtimeType &&
          const ListEquality<RoomItem>().equals(roomItems, other.roomItems);

  @override
  int get hashCode => const ListEquality<RoomItem>().hash(roomItems);

  @override
  String toString() => 'SavedList{roomItems: $roomItems}';
}

@immutable
class RoomItem {
  final String id;
  final String title;
  final String price;
  final String address;
  final String districtName;
  final String image;
  final DateTime savedTime;

  const RoomItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.address,
    @required this.districtName,
    @required this.image,
    @required this.savedTime,
  });

  @override
  String toString() =>
      'RoomItem{id: $id, title: $title, price: $price, address: $address,'
      ' districtName: $districtName, image: $image, savedTime: $savedTime}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          address == other.address &&
          districtName == other.districtName &&
          image == other.image &&
          savedTime == other.savedTime;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      address.hashCode ^
      districtName.hashCode ^
      image.hashCode ^
      savedTime.hashCode;
}
