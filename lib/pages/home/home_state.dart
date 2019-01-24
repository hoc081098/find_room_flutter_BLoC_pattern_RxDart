import 'package:meta/meta.dart';

enum BookmarkIconState { hide, showSaved, showNotSaved }

enum SeeAllQuery { newest, mostViewed }

class NotLoginError {
  const NotLoginError();
}

@immutable
class RoomItem {
  final String id;
  final String title;
  final String price;
  final String address;
  final String districtName;
  final String image;
  final BookmarkIconState iconState;

  const RoomItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.address,
    @required this.districtName,
    @required this.iconState,
    @required this.image,
  });

  @override
  String toString() => 'RoomItem{id: $id, title: $title, price: $price, '
      'address: $address, districtName: $districtName, image: $image, iconState: $iconState}';

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
          iconState == other.iconState;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      address.hashCode ^
      districtName.hashCode ^
      image.hashCode ^
      iconState.hashCode;

  RoomItem withIconState(BookmarkIconState iconState) {
    return RoomItem(
      iconState: iconState,
      address: address,
      price: price,
      id: id,
      districtName: districtName,
      image: image,
      title: title,
    );
  }
}

@immutable
class BannerItem {
  final String image;
  final String description;

  const BannerItem({
    @required this.image,
    @required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerItem &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          description == other.description;

  @override
  int get hashCode => image.hashCode ^ description.hashCode;

  @override
  String toString() => 'BannerItem{image: $image, description: $description}';
}

@immutable
abstract class HomeMessage {
  const HomeMessage();
}

abstract class ChangeSelectedProvinceMessage implements HomeMessage {
  final String provinceName;

  const ChangeSelectedProvinceMessage(this.provinceName);
}

abstract class AddOrRemovedSavedMessage implements HomeMessage {
  const AddOrRemovedSavedMessage();
}

class ChangeSelectedProvinceMessageSuccess
    extends ChangeSelectedProvinceMessage {
  const ChangeSelectedProvinceMessageSuccess(String provinceName)
      : super(provinceName);
}

class ChangeSelectedProvinceMessageError extends ChangeSelectedProvinceMessage {
  const ChangeSelectedProvinceMessageError(String provinceName)
      : super(provinceName);
}

class AddSavedMessageSuccess implements AddOrRemovedSavedMessage {
  const AddSavedMessageSuccess();
}

class RemoveSavedMessageSuccess implements AddOrRemovedSavedMessage {
  const RemoveSavedMessageSuccess();
}

class AddOrRemovedSavedMessageError implements AddOrRemovedSavedMessage {
  final Object error;

  const AddOrRemovedSavedMessageError(this.error);
}
