import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/app/app.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/auth_bloc/user_login_state.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/saved/saved_bloc.dart';
import 'package:find_room/pages/saved/saved_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SavedPage extends StatefulWidget {
  final AuthBloc authBloc;
  final SavedBloc Function() initSavedBloc;

  const SavedPage({
    Key key,
    @required this.authBloc,
    @required this.initSavedBloc,
  }) : super(key: key);

  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  SavedBloc _savedBloc;
  List<StreamSubscription> _subscriptions;

  @override
  void initState() {
    super.initState();

    _savedBloc = widget.initSavedBloc();
    _subscriptions = [
      widget.authBloc.loginState$
          .where((state) => state is Unauthenticated)
          .listen((_) => Navigator.popUntil(context, ModalRoute.withName('/'))),
      _savedBloc.removeMessage$.listen(_showMessageResult),
    ];
  }

  void _showMessageResult(SavedMessage message) {
    print('[DEBUG] saved_message=$message');
    final s = S.of(context);

    if (message is RemovedSaveRoomMessage) {
      if (message is RemovedSaveRoomMessageSuccess) {
        _showSnackBar(
            s.remove_saved_room_success_with_title(message.removedTitle));
      }
      if (message is RemovedSaveRoomMessageError) {
        if (message.error is NotLoginError) {
          _showSnackBar(s.require_login);
        } else {
          _showSnackBar(s.remove_saved_room_error);
        }
      }
    }
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
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
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: StreamBuilder<SavedListState>(
            stream: _savedBloc.savedListState$,
            initialData: _savedBloc.savedListState$.value,
            builder: (context, snapshot) {
              final data = snapshot.data;
              print('saved length=${data.roomItems.length}, data=$data');

              if (data.error != null) {
                return Center(
                  child: Text(
                    S.of(context).error_occurred,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                );
              }

              if (data.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

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
                  final padding = _getItemPadding(data.roomItems.length, index);
                  return SavedRoomListItem(
                    roomItem: data.roomItems[index],
                    margin: padding,
                    removeFromSaved: _savedBloc.removeFromSaved.add,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static EdgeInsets _getItemPadding(int length, int index) {
    EdgeInsets padding;
    const margin = 6.0;
    if (length > 1) {
      if (index == 0) {
        padding = const EdgeInsets.fromLTRB(margin, margin, margin, margin / 2);
      } else if (index == length - 1) {
        padding = const EdgeInsets.fromLTRB(margin, 2, margin, margin);
      } else {
        padding = const EdgeInsets.symmetric(
          vertical: margin / 2,
          horizontal: margin,
        );
      }
    } else {
      padding = const EdgeInsets.all(margin);
    }
    return padding;
  }
}

class SavedRoomListItem extends StatefulWidget {
  final RoomItem roomItem;
  final EdgeInsetsGeometry margin;
  final void Function(String) removeFromSaved;

  const SavedRoomListItem({
    Key key,
    @required this.roomItem,
    @required this.margin,
    @required this.removeFromSaved,
  }) : super(key: key);

  @override
  _SavedRoomListItemState createState() => _SavedRoomListItemState();
}

class _SavedRoomListItemState extends State<SavedRoomListItem>
    with SingleTickerProviderStateMixin<SavedRoomListItem> {
  AnimationController _animationController;
  Animation<Offset> _animationPosition;
  Animation<double> _animationScale;
  Animation<double> _animationOpacity;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animationPosition = Tween(
      begin: Offset(2.0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationScale = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _animationOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final s = S.of(context);
    final item = widget.roomItem;
    final currentLocale =
        BlocProvider.of<LocaleBloc>(context).locale$.value.languageCode;

    final textRemoved = Text(
      s.removed,
      style: themeData.textTheme.title.copyWith(fontSize: 14),
    );
    final background = Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(width: 16.0),
            const Icon(
              Icons.delete,
              size: 28.0,
              color: Colors.black54,
            ),
            const SizedBox(width: 16.0),
            textRemoved,
            const Spacer(),
            textRemoved,
            const SizedBox(width: 16.0),
            const Icon(
              Icons.delete,
              size: 28.0,
              color: Colors.black54,
            ),
            const SizedBox(width: 16.0),
          ],
        ),
      ),
    );

    const radius = 6.0;
    const sizedBox = SizedBox(height: 4);
    final dateFormat = DateFormat.yMMMMd(currentLocale).add_Hms();

    final content = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/room_detail',
                arguments: item.id,
              );
            },
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                  ),
                  child: CachedNetworkImage(
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                    imageUrl: item.image,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.black12,
                        width: 128,
                        height: 128,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            color: Theme.of(context).accentColor,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      sizedBox,
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: themeData.textTheme.title.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      sizedBox,
                      Text(
                        item.price,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: themeData.textTheme.subtitle.copyWith(
                          color: themeData.accentColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      sizedBox,
                      Text(
                        '${item.address} - ${item.districtName}' * 5,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            themeData.textTheme.subtitle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              dateFormat.format(item.savedTime),
                              maxLines: 1,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: themeData.textTheme.subtitle.copyWith(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.bookmark,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                      sizedBox,
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );

    return FadeTransition(
      opacity: _animationOpacity,
      child: ScaleTransition(
        scale: _animationScale,
        child: SlideTransition(
          position: _animationPosition,
          child: Dismissible(
            background: background,
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              print('onDismissed direction=$direction');
              widget.removeFromSaved(item.id);
            },
            child: content,
            key: Key("${item.id}${Random().nextInt(1 << 32)}"),
          ),
        ),
      ),
    );
  }
}
