import 'package:flutter/material.dart';

class CommentsTabPages extends StatefulWidget {
  const CommentsTabPages({Key key}) : super(key: key);

  @override
  _CommentsTabPagesState createState() => _CommentsTabPagesState();
}

class _CommentsTabPagesState extends State<CommentsTabPages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Center(
        child: Text('Comments'),
      ),
    );
  }
}
