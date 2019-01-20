import 'dart:async';

import 'package:find_room/app/app.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/saved/saved_bloc.dart';
import 'package:find_room/pages/saved/saved_state.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:find_room/user_bloc/user_login_state.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  SavedBloc _savedBloc;
  StreamSubscription<dynamic> _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('_SavedPageState#didChangeDependencies');

    var userBloc = BlocProvider.of<UserBloc>(context);
    var roomRepository = Injector.of(context).roomRepository;
    var priceFormat = Injector.of(context).priceFormat;

    _subscription?.cancel();
    _subscription = userBloc.userLoginState$
        .where((state) => state is NotLogin)
        .listen((_) => Navigator.popUntil(context, ModalRoute.withName('/')));

    _savedBloc = SavedBloc(
      userBloc: userBloc,
      roomRepository: roomRepository,
      priceFormat: priceFormat,
    );
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
                        title: Text(item.title),
                        subtitle: Text(item.price),
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
