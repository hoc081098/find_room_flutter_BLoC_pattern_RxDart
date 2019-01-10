import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart' show ListEquality;

const kLimitRoom = 20;

const kBannerSliderInitial = <BannerItem>[];

const kLatestRoomsInitial = Tuple2(
  HeaderItem(
    seeAllQuery: SeeAllQuery.newest,
    title: 'Mới nhất',
  ),
  <RoomItem>[],
);

const kHottestInitial = Tuple2(
  HeaderItem(
    seeAllQuery: SeeAllQuery.hottest,
    title: 'Xem nhiều',
  ),
  <RoomItem>[],
);

const _kListRoomItemEquality = ListEquality<RoomItem>();

const _kListBannerItemEquality = ListEquality<BannerItem>();

bool tuple2Equals(
  Tuple2<HeaderItem, List<RoomItem>> previous,
  Tuple2<HeaderItem, List<RoomItem>> next,
) => previous.item1 == next.item1 &&
      _kListRoomItemEquality.equals(previous.item2, next.item2);

bool bannersListEquals(List<BannerItem> previous, List<BannerItem> next) => _kListBannerItemEquality.equals(previous, next);

enum BookmarkIconState { hide, showSaved, showNotSaved }

enum SeeAllQuery { newest, hottest }

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
  final int price;
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
}

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
