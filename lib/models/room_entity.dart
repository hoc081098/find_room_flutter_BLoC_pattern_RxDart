import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/models/firebase_model.dart';
import 'package:find_room/utitls/collection_equality_const.dart';
import 'package:find_room/utitls/model_json_convert.dart';
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
  @JsonKey(name: 'is_active')
  final bool isActive;
  final bool approve;
  final Map<String, Object> utilities;
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
  @JsonKey(name: 'user_ids_saved', defaultValue: <String>[])
  final List<String> userIdsSaved;

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
    this.isActive,
    this.approve,
    this.utilities,
    this.user,
    this.category,
    this.province,
    this.ward,
    this.district,
    this.districtName,
    this.createdAt,
    this.updatedAt,
    this.userIdsSaved,
    this.documentID,
  });

  factory RoomEntity.fromDocumentSnapshot(DocumentSnapshot doc) {
    doc.data['utilities'] =
        (doc.data['utilities'] as Map).cast<String, dynamic>();
    return _$RoomEntityFromJson(withId(doc));
  }

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
          isActive == other.isActive &&
          approve == other.approve &&
          kMapStringObjectEquality.equals(utilities, other.utilities) &&
          user == other.user &&
          category == other.category &&
          province == other.province &&
          ward == other.ward &&
          district == other.district &&
          districtName == other.districtName &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          kListStringEquality.equals(userIdsSaved, other.userIdsSaved);

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
      isActive.hashCode ^
      approve.hashCode ^
      kMapStringObjectEquality.hash(utilities) ^
      user.hashCode ^
      category.hashCode ^
      province.hashCode ^
      ward.hashCode ^
      district.hashCode ^
      districtName.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      kListStringEquality.hash(userIdsSaved);

  @override
  String toString() => 'RoomEntity{documentID: $documentID, title: $title, '
      'description: $description, price: $price, countView: $countView, size: $size,'
      ' address: $address, addressGeoPoint: $addressGeoPoint, images: $images,'
      ' phone: $phone, isActive: $isActive, approve: $approve, utilities: $utilities,'
      ' user: $user, category: $category, province: $province, ward: $ward,'
      ' district: $district, districtName: $districtName, createdAt: $createdAt,'
      ' updatedAt: $updatedAt, userIdsSaved: $userIdsSaved}';
}
