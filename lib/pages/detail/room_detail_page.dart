import 'package:find_room/generated/i18n.dart';
import 'package:flutter/material.dart';

class RoomDetailPage extends StatefulWidget {
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).detail_title),
      ),
      body: Center(
        child: Text(S.of(context).detail_title),
      ),
    );
  }
}
