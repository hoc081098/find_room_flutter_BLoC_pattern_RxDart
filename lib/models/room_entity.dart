import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utils/model_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'room_entity.g.dart';

@immutable
@JsonSerializable()
class RoomEntity implements FirebaseModel {
  final String documentID;
  final String title;
  final String description;
  final int price;
  @JsonKey(name: 'count_view')
  final int countView;
  final double size;
  final String address;
  @JsonKey(
    name: 'address_geopoint',
    fromJson: geoPointFromJson,
    toJson: geoPointToJson,
  )
  final GeoPoint addressGeoPoint;
  final List<String> images;
  final String phone;
  final bool available;
  final bool approve;
  final List<String> utilities;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference user;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference category;
  @JsonKey(name: 'category_name')
  final String categoryName;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference province;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference ward;
  @JsonKey(
    fromJson: documentReferenceFromJson,
    toJson: documentReferenceToJson,
  )
  final DocumentReference district;
  @JsonKey(name: 'district_name')
  final String districtName;
  @JsonKey(
    name: 'created_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
  )
  final Timestamp createdAt;
  @JsonKey(
    name: 'updated_at',
    fromJson: timestampFromJson,
    toJson: timestampToJson,
  )
  final Timestamp updatedAt;
  @JsonKey(
    name: 'user_ids_saved',
    fromJson: mapStringTimestampFromJson,
    toJson: mapStringTimestampToJson,
  )
  final Map<String, Timestamp> userIdsSaved;

  const RoomEntity({
    this.title,
    this.description,
    this.price,
    this.countView,
    this.size,
    this.address,
    this.addressGeoPoint,
    this.images,
    this.phone,
    this.available,
    this.approve,
    this.utilities,
    this.user,
    this.category,
    this.categoryName,
    this.province,
    this.ward,
    this.district,
    this.districtName,
    this.createdAt,
    this.updatedAt,
    this.userIdsSaved,
    this.documentID,
  });

  factory RoomEntity.fromDocumentSnapshot(DocumentSnapshot doc) =>
      _$RoomEntityFromJson(withId(doc));

  Map<String, dynamic> toJson() => _$RoomEntityToJson(this);

  @override
  String get id => this.documentID;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomEntity &&
          runtimeType == other.runtimeType &&
          documentID == other.documentID &&
          title == other.title &&
          description == other.description &&
          price == other.price &&
          countView == other.countView &&
          size == other.size &&
          address == other.address &&
          addressGeoPoint == other.addressGeoPoint &&
          kListStringEquality.equals(images, other.images) &&
          phone == other.phone &&
          available == other.available &&
          approve == other.approve &&
          kListStringEquality.equals(utilities, other.utilities) &&
          user == other.user &&
          category == other.category &&
          province == other.province &&
          ward == other.ward &&
          district == other.district &&
          districtName == other.districtName &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          kMapStringTimestampEquality.equals(userIdsSaved, other.userIdsSaved);

  @override
  int get hashCode =>
      documentID.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      countView.hashCode ^
      size.hashCode ^
      address.hashCode ^
      addressGeoPoint.hashCode ^
      kListStringEquality.hash(images) ^
      phone.hashCode ^
      available.hashCode ^
      approve.hashCode ^
      kListStringEquality.hash(utilities) ^
      user.hashCode ^
      category.hashCode ^
      province.hashCode ^
      ward.hashCode ^
      district.hashCode ^
      districtName.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      kMapStringTimestampEquality.hash(userIdsSaved);

  @override
  String toString() => 'RoomEntity{documentID: $documentID, title: $title, '
      'description: $description, price: $price, countView: $countView, size: $size,'
      ' address: $address, addressGeoPoint: $addressGeoPoint, images: $images,'
      ' phone: $phone, available: $available, approve: $approve, utilities: $utilities,'
      ' user: $user, category: $category, categoryName: $category, province: $province, ward: $ward,'
      ' district: $district, districtName: $districtName, createdAt: $createdAt,'
      ' updatedAt: $updatedAt, userIdsSaved: $userIdsSaved}';
}
