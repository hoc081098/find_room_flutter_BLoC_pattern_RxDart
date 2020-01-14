import 'package:find_room/app/app.dart';
import 'package:flutter/material.dart';

class PostRoomPage extends StatefulWidget {
  const PostRoomPage({Key key}) : super(key: key);

  @override
  _PostRoomPageState createState() => _PostRoomPageState();
}

class _PostRoomPageState extends State<PostRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post room'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => RootScaffold.openDrawer(context),
        ),
      ),
      body: Center(
        child: Text('POST'),
      ),
    );
  }
}
