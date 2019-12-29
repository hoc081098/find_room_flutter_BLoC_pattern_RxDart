import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_bloc.dart';
import 'package:flutter/material.dart';

class RelatedRoomsTabPage extends StatefulWidget {
  const RelatedRoomsTabPage({Key key}) : super(key: key);

  @override
  _RelatedRoomsTabPageState createState() => _RelatedRoomsTabPageState();
}

class _RelatedRoomsTabPageState extends State<RelatedRoomsTabPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(BlocProvider.of<RelatedRoomsTabBloc>(context));
  }

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
