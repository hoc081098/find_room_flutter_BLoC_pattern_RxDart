import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/room_comments/room_comments_repository.dart';

class CommentsTabBloc implements BaseBloc {
  CommentsTabBloc._();

  factory CommentsTabBloc(final RoomCommentsRepository commentsRepository) {
    return CommentsTabBloc._();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
