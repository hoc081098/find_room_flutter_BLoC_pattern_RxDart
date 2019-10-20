import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/comments/comments_tab_bloc.dart';
import 'package:find_room/pages/detail/comments/comments_tab_state.dart';
import 'package:flutter/material.dart';

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
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var comment = comments[index];

                return ListTile(
                  title: Text(comment.content),
                );
              },
            );
          }),
    );
  }
}
