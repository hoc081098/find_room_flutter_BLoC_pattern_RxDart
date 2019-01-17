import 'package:find_room/app/app.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đã lưu'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => RootScaffold.openDrawer(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Text('Saved page...'),
        ),
      ),
    );
  }
}
