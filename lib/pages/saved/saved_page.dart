import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/app/app.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/saved/saved_bloc.dart';
import 'package:find_room/pages/saved/saved_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavedPage extends StatefulWidget {
  final UserBloc userBloc;
  final SavedBloc Function() initSavedBloc;

  const SavedPage({
    Key key,
    @required this.userBloc,
    @required this.initSavedBloc,
  }) : super(key: key);

  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  SavedBloc _savedBloc;
  StreamSubscription<dynamic> _subscription;

  @override
  void initState() {
    super.initState();

    _savedBloc = widget.initSavedBloc();
    _subscription = widget.userBloc.userLoginState$
        .where((state) => state is NotLogin)
        .listen((_) => Navigator.popUntil(context, ModalRoute.withName('/')));
  }

  @override
  void dispose() {
    _subscription.cancel();
    _savedBloc.dispose();
    print('_SavedPageState#dispose');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).saved_rooms_title),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => RootScaffold.openDrawer(context),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<SavedListState>(
            stream: _savedBloc.savedListState$,
            initialData: _savedBloc.savedListState$.value,
            builder: (context, snapshot) {
              var data = snapshot.data;

              if (data is Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (data is SavedList) {
                if (data.roomItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          size: 48,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          S.of(context).saved_list_empty,
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final themeData = Theme.of(context);
                return ListView.builder(
                  itemCount: data.roomItems.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = data.roomItems[index];

                    return Dismissible(
                      onDismissed: (direction) {
                        if (direction == DismissDirection.horizontal) {
                          _savedBloc.removeFromSaved.add(item.id);
                        }
                      },
                      child: ListTile(
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: themeData.textTheme.subtitle.copyWith(
                            fontSize: 14,
                            fontFamily: 'SF-Pro-Text',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              item.price,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: themeData.textTheme.subtitle.copyWith(
                                color: themeData.accentColor,
                                fontSize: 12.0,
                                fontFamily: 'SF-Pro-Text',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              item.address,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: themeData.textTheme.subtitle.copyWith(
                                color: Colors.black87,
                                fontSize: 12,
                                fontFamily: 'SF-Pro-Text',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              item.districtName,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: themeData.textTheme.subtitle.copyWith(
                                color: Colors.black87,
                                fontSize: 12,
                                fontFamily: 'SF-Pro-Text',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMMd().format(item.savedTime),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: themeData.textTheme.subtitle.copyWith(
                                color: Colors.black87,
                                fontSize: 12,
                                fontFamily: 'SF-Pro-Text',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        leading: CachedNetworkImage(
                          width: 128,
                          height: 128,
                          imageUrl: item.image,
                          placeholder: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: Center(
                            child: Icon(Icons.image),
                          ),
                        ),
                        trailing: Icon(
                          Icons.bookmark,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      key: Key(item.id),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
