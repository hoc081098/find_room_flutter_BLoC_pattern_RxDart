import 'package:flutter/material.dart';

class RoomDetailTabPage extends StatefulWidget {
  const RoomDetailTabPage({Key key}) : super(key: key);


  @override
  _RoomDetailTabPageState createState() => _RoomDetailTabPageState();
}

class _RoomDetailTabPageState extends State<RoomDetailTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pinkAccent,
      child: Center(
        child: Text('Detail'),
      ),
    );
  }
}
