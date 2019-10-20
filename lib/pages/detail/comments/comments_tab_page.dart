import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/comments/comments_tab_bloc.dart';
import 'package:flutter/material.dart';

class CommentsTabPages extends StatefulWidget {
  const CommentsTabPages({Key key}) : super(key: key);

  @override
  _CommentsTabPagesState createState() => _CommentsTabPagesState();
}

class _CommentsTabPagesState extends State<CommentsTabPages> {
  @override
  Widget build(BuildContext context) {
    print('>>>>> ${BlocProvider.of<CommentsTabBloc>(context)}');

    return Container(
      color: Colors.orangeAccent,
      child: Center(
        child: Text('Comments'),
      ),
    );
  }
}
