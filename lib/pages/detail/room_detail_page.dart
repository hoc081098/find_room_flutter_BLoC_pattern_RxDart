import 'package:flutter/material.dart';

class RoomDetailPage extends StatefulWidget {
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết'),
      ),
      body: Center(
        child: Text('Detail page...'),
      ),
    );
  }
}
