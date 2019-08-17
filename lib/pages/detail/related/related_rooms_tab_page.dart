import 'package:flutter/material.dart';

class RelatedRoomsTabPage extends StatefulWidget {
  const RelatedRoomsTabPage({Key key}) : super(key: key);

  @override
  _RelatedRoomsTabPageState createState() => _RelatedRoomsTabPageState();
}

class _RelatedRoomsTabPageState extends State<RelatedRoomsTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: Text('Related rooms'),
      ),
    );
  }
}
