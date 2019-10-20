import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/comments/comments_tab_bloc.dart';
import 'package:find_room/pages/detail/comments/comments_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommentsTabPages extends StatefulWidget {
  const CommentsTabPages({Key key}) : super(key: key);

  @override
  _CommentsTabPagesState createState() => _CommentsTabPagesState();
}

class _CommentsTabPagesState extends State<CommentsTabPages> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<CommentsTabBloc>(context);

    return Container(
      color: Colors.white,
      child: StreamBuilder<CommentsTabState>(
        stream: bloc.state$,
        initialData: bloc.state$.value,
        builder: (context, snapshot) {
          var state = snapshot.data;

          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text('Error ${state.error}'),
            );
          }

          var comments = state.comments;
          return Scrollbar(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) =>
                  CommentItemWidget(comment: comments[index]),
              separatorBuilder: (context, index) => const Divider(),
            ),
          );
        },
      ),
    );
  }
}

class CommentItemWidget extends StatelessWidget {
  final CommentItem comment;

  const CommentItemWidget({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        if (comment.isCurrentUser)
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {},
          ),
      ],
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/user_profile',
                  arguments: comment.userId,
                );
              },
              child: CircleAvatar(
                radius: 32,
                backgroundImage: CachedNetworkImageProvider(
                  comment.userAvatar,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    comment.userName,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    comment.createdAt,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Text(comment.content),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
