import 'package:find_room/pages/home/home_state.dart';
import 'package:flutter/material.dart';

class SeeAllPage extends StatefulWidget {
  final SeeAllQuery seeAllQuery;

  const SeeAllPage(this.seeAllQuery, {Key key}) : super(key: key);

  @override
  _SeeAllPageState createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem tất cả'),
      ),
      body: SafeArea(
        child: Center(
          child: Text('See all page ${widget.seeAllQuery}...'),
        ),
      ),
    );
  }
}
