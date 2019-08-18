import 'package:built_value/built_value.dart';

part 'room_detail_tab_state.g.dart';

abstract class RoomDetailTabState
    implements Built<RoomDetailTabState, RoomDetailTabStateBuilder> {
  String get id;

  RoomDetailTabState._();

  factory RoomDetailTabState([updates(RoomDetailTabStateBuilder b)]) =
      _$RoomDetailTabState;
}
