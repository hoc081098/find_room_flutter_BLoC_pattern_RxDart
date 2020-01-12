import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'related_rooms_tab_state.g.dart';

abstract class RelatedRoomsState
    implements Built<RelatedRoomsState, RelatedRoomsStateBuilder> {
  bool get isLoading;

  BuiltList<RoomItem> get items;

  @nullable
  Object get error;

  RelatedRoomsState._();

  factory RelatedRoomsState([updates(RelatedRoomsStateBuilder b)]) =
      _$RelatedRoomsState;

  factory RelatedRoomsState.initial() => RelatedRoomsState(
        (b) => b
          ..isLoading = true
          ..items = ListBuilder<RoomItem>()
          ..error = null,
      );
}

abstract class RoomItem implements Built<RoomItem, RoomItemBuilder> {
  String get id;

  String get title;

  String get price;

  String get address;

  String get districtName;

  @nullable
  String get image;

  @nullable
  DateTime get createdTime;

  @nullable
  DateTime get updatedTime;

  @nullable
  String get imageUrl;

  RoomItem._();

  factory RoomItem([updates(RoomItemBuilder b)]) = _$RoomItem;
}

///
/// Partial change
///
abstract class PartialStateChange {}

class GetUsersSuccessChange implements PartialStateChange {
  final List<RoomItem> items;

  GetUsersSuccessChange(this.items);
}

class LoadingChange implements PartialStateChange {
  const LoadingChange();
}

class GetUsersErrorChange implements PartialStateChange {
  final error;

  const GetUsersErrorChange(this.error);
}

///
/// Single event message
///
abstract class Message {}

class RefreshSuccessMessage implements Message {
  const RefreshSuccessMessage();
}

class RefreshFailureMessage implements Message {
  final error;

  const RefreshFailureMessage(this.error);
}

class GetRoomsErrorMessage implements Message {
  final error;

  GetRoomsErrorMessage(this.error);
}
