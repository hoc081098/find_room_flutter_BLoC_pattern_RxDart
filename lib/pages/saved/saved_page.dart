

import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhà trọ đã lưu'),
      ),
      body: Center(
        child: Text('Saved page...'),
      ),
    );
  }
}