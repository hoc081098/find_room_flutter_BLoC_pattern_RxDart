import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'see_all_state.g.dart';

abstract class SeeAllRoomItem
    implements Built<SeeAllRoomItem, SeeAllRoomItemBuilder> {
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

  SeeAllRoomItem._();

  factory SeeAllRoomItem([updates(SeeAllRoomItemBuilder b)]) = _$SeeAllRoomItem;
}

abstract class SeeAllListState
    implements Built<SeeAllListState, SeeAllListStateBuilder> {
  BuiltList<SeeAllRoomItem> get rooms;

  bool get isLoading;

  bool get getAll;

  @nullable
  SeeAllError get error;

  @nullable
  DocumentSnapshot get lastDocumentSnapshot;

  SeeAllListState._();

  factory SeeAllListState([updates(SeeAllListStateBuilder b)]) =
      _$SeeAllListState;

  factory SeeAllListState.initial() {
    return SeeAllListState(
      (b) => b
        ..rooms = ListBuilder()
        ..error = null
        ..isLoading = false
        ..getAll = false,
    );
  }
}

@immutable
abstract class SeeAllMessage {}

class LoadAllMessage implements SeeAllMessage {
  const LoadAllMessage();
}

class ErrorMessage implements SeeAllMessage {
  final SeeAllError error;

  const ErrorMessage(this.error);
}

@immutable
abstract class SeeAllError {}

class UnknownError implements SeeAllError {
  final cause;

  UnknownError(this.cause);
}
