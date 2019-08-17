import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/detail/comments/comments_tab_page.dart';
import 'package:find_room/pages/detail/detail/room_detail_tab_page.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_page.dart';
import 'package:find_room/pages/detail/room_detail_bloc.dart';
import 'package:flutter/material.dart';

class RoomDetailPage extends StatefulWidget {
  final String id;

  const RoomDetailPage({Key key, @required this.id})
      : assert(id != null),
        super(key: key);

  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    print('Detail { init ${widget.id} }');

    _pages = <Widget>[
      const RoomDetailTabPage(),
      const CommentsTabPages(),
      const RelatedRoomsTabPage(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('Detail { changeDeps ${widget.id} }');
  }

  @override
  void didUpdateWidget(RoomDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('Detail { updateWidget ${oldWidget.id} -> ${widget.id} }');

    if (widget.id != oldWidget.id) {
      // TODO: Id changed
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RoomDetailBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).detail_title),
      ),
      body: StreamBuilder<int>(
        stream: bloc.selectedIndex$,
        initialData: bloc.selectedIndex$.value,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            child: _pages[snapshot.data],
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: bloc.selectedIndex$,
        initialData: bloc.selectedIndex$.value,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            selectedItemColor: Theme.of(context).accentColor,
            type: BottomNavigationBarType.shifting,
            onTap: bloc.changeIndex,
            unselectedItemColor: Theme.of(context).textTheme.title.color,
            currentIndex: snapshot.data,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.details),
                title: Text('Detail'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.comment),
                title: Text('Comments'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Related'),
              )
            ],
          );
        }
      ),
    );
  }
}
