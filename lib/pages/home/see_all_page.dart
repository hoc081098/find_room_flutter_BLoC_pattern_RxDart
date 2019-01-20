import 'package:find_room/generated/i18n.dart';
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
        title: Text(S.of(context).see_all),
      ),
      body: SafeArea(
        child: Center(
          child: Text('${S.of(context).see_all} ${widget.seeAllQuery}...'),
        ),
      ),
    );
  }
}
