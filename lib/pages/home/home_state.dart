import 'package:meta/meta.dart';

enum BookmarkIconState { hide, showSaved, showNotSaved }

enum SeeAllQuery { newest, mostViewed }

@immutable
class HeaderItem {
  final String title;
  final SeeAllQuery seeAllQuery;

  const HeaderItem({@required this.title, @required this.seeAllQuery});

  @override
  String toString() => 'HeaderItem{title: $title, seeAllQuery: $seeAllQuery}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaderItem &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          seeAllQuery == other.seeAllQuery;

  @override
  int get hashCode => title.hashCode ^ seeAllQuery.hashCode;
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
