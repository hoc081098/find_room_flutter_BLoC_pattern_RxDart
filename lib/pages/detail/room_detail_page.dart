import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/detail/comments/comments_tab_page.dart';
import 'package:find_room/pages/detail/detail/room_detail_tab_page.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_page.dart';
import 'package:find_room/pages/detail/room_detail_bloc.dart';
import 'package:find_room/pages/detail/room_detail_state.dart';
import 'package:flutter/material.dart';

class RoomDetailPage extends StatefulWidget {
  const RoomDetailPage({Key key}) : super(key: key);

  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<Widget> _pages;

  StreamSubscription<RoomDetailMessage> _subcriptions;

  @override
  void initState() {
    super.initState();
    print('Detail { init }');

    _pages = <Widget>[
      const RoomDetailTabPage(),
      const CommentsTabPages(),
      const RelatedRoomsTabPage(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('Detail { changeDeps }');

    _subcriptions ??= BlocProvider.of<RoomDetailBloc>(context)
        .message$
        .listen(_handleMessage);
  }

  @override
  void dispose() {
    _subcriptions.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RoomDetailBloc>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(S.of(context).detail_title),
        actions: <Widget>[
          StreamBuilder<bool>(
            stream: bloc.isCreatedByCurrentUser$,
            initialData: bloc.isCreatedByCurrentUser$.value,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // TODO: To edit room page
                  },
                );
              }
              return Container(width: 0, height: 0);
            },
          ),
          StreamBuilder<BookmarkIconState>(
            stream: bloc.bookmarkIconState$,
            initialData: bloc.bookmarkIconState$.value,
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case BookmarkIconState.hide:
                  return Container(width: 0, height: 0);
                case BookmarkIconState.showSaved:
                  return IconButton(
                    icon: Icon(Icons.bookmark),
                    onPressed: bloc.addOrRemoveSaved,
                    tooltip: 'Remove from saved',
                  );
                case BookmarkIconState.showNotSaved:
                  return IconButton(
                    icon: Icon(Icons.bookmark_border),
                    onPressed: bloc.addOrRemoveSaved,
                    tooltip: 'Add to saved',
                  );
                case BookmarkIconState.loading:
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                  break;
              }
              return null;
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share room',
            onPressed: bloc.shareRoom,
          )
        ],
      ),
      body: StreamBuilder<int>(
        stream: bloc.selectedIndex$,
        initialData: bloc.selectedIndex$.value,
        builder: (context, snapshot) {
          print('selectedIndex: ${snapshot.data}');

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
                label: Text('Detail'),
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
        },
      ),
    );
  }

  void _handleMessage(RoomDetailMessage message) {
    final s = S.of(context);
    if (message is AddSavedSuccessMessage) {
      _showSnackBar(s.add_saved_room_success);
    }
    if (message is RemoveSavedSuccessMessage) {
      _showSnackBar(s.remove_saved_room_success);
    }
    if (message is AddOrRemovedSavedErrorMessage) {
      final error = message.error;
      print(error);
      if (error is UnauthenticatedError) {
        _showSnackBar(s.require_login);
      }
      if (error is UnknownError) {
        _showSnackBar(s.add_or_remove_saved_room_error);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
