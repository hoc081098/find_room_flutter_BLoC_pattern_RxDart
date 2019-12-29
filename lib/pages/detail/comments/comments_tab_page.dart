import 'dart:async';

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
  StreamSubscription<CommentsTabMessage> _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription ??=
        BlocProvider.of<CommentsTabBloc>(context).message$.listen((message) {
      print('Message $message');
      if (message is DeleteCommentSuccess) {
        _showSnackBar('Delete comment success');
      }
      if (message is DeleteCommentFailure) {
        _showSnackBar('Delete comment failure: ${message.error}');
      }
      if (message is UpdateCommentSuccess) {
        _showSnackBar('Update success');
      }
      if (message is UpdateCommentFailure) {
        _showSnackBar('Update comment failure: ${message.error}');
      }
    }, onError: (e, s) => print('$e $s'));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  _showSnackBar(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CommentsTabBloc>(context);

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
              itemBuilder: (context, index) => CommentItemWidget(
                comment: comments[index],
                deleteCallback: showDeleteDialog,
                editCallback: showEditDialog,
              ),
              separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).dividerColor.withAlpha(128),
              ),
            ),
          );
        },
      ),
    );
  }

  void showDeleteDialog(CommentItem comment) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete comment'),
          content: Text('This action cannot be undone'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (delete ?? false) {
      BlocProvider.of<CommentsTabBloc>(context).deleteComment(comment);
    }
  }

  void showEditDialog(CommentItem comment) async {
    final newContent = await showDialog<String>(
      context: context,
      builder: (context) {
        String text = comment.content;

        return AlertDialog(
          title: Text('Edit comment'),
          content: TextFormField(
            autofocus: true,
            initialValue: comment.content,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onChanged: (val) => text = val,
            onFieldSubmitted: (val) => Navigator.of(context).pop(val),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(comment.content);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(text);
              },
            ),
          ],
        );
      },
    );

    print('### $newContent');
    if (newContent == null) {
      return;
    }
    if (comment.content != newContent) {
      BlocProvider.of<CommentsTabBloc>(context)
          .updateComment(comment, newContent);
    }
  }
}

class CommentItemWidget extends StatelessWidget {
  final CommentItem comment;
  final void Function(CommentItem comment) deleteCallback;
  final void Function(CommentItem comment) editCallback;

  const CommentItemWidget({
    Key key,
    this.comment,
    this.deleteCallback,
    this.editCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actions: <Widget>[
        if (comment.isCurrentUser)
          IconSlideAction(
            caption: 'Edit',
            color: Theme.of(context).primaryColor,
            icon: Icons.edit,
            onTap: () => editCallback(comment),
          ),
      ],
      secondaryActions: <Widget>[
        if (comment.isCurrentUser)
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => deleteCallback(comment),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.all(12),
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
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: <Widget>[
                      if (comment.updatedAt != null)
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.black54,
                        )
                      else
                        Icon(
                          Icons.comment,
                          size: 16,
                          color: Colors.black54,
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          comment.updatedAt != null
                              ? 'Edited: ${comment.updatedAt}'
                              : comment.createdAt,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(comment.content ?? 'No content'),
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
