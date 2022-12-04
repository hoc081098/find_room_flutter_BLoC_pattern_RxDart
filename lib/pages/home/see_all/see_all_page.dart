import 'dart:async';

import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/pages/home/see_all/see_all_bloc.dart';
import 'package:find_room/pages/home/see_all/see_all_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeeAllPage extends StatefulWidget {
  final SeeAllQuery seeAllQuery;

  const SeeAllPage(this.seeAllQuery, {Key key}) : super(key: key);

  @override
  _SeeAllPageState createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  static const offsetVisibleThreshold = 20;

  StreamSubscription<SeeAllMessage> _subscription;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_subscription == null) {
      final bloc = BlocProvider.of<SeeAllBloc>(context);
      _subscription = bloc.message$.listen((message) {
        if (message is LoadAllMessage) {
          _showSnackBar('Loaded all');
          makeAnimation();
        }
        if (message is ErrorMessage) {
          final error = message.error;
          _showSnackBar('Error: $error');
        }
      });
      _scrollController.addListener(() => _onScroll(bloc));
    }
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SeeAllBloc>(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.see_all_(
            () {
              switch (widget.seeAllQuery) {
                case SeeAllQuery.newest:
                  return s.newest;
                case SeeAllQuery.mostViewed:
                  return s.mostViewed;
              }
              return '';
            }(),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: bloc.refresh,
        child: Container(
          constraints: BoxConstraints.expand(),
          child: StreamBuilder<SeeAllListState>(
            stream: bloc.peopleList$,
            initialData: bloc.peopleList$.value,
            builder: (context, snapshot) {
              final data = snapshot.data;
              final rooms = data.rooms;
              final error = data.error;
              final isLoading = data.isLoading;

              return Scrollbar(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index < rooms.length) {
                      return _SeeAllRoomItem(
                        index: index,
                        length: rooms.length,
                        item: rooms[index],
                        key: ObjectKey(rooms[index]),
                      );
                    }

                    if (error != null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'Error: $error',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              isThreeLine: false,
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.mood_bad,
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                            FlatButton.icon(
                              padding: const EdgeInsets.all(16),
                              icon: Icon(Icons.refresh),
                              label: Text('Retry'),
                              onPressed: bloc.retry,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    if (isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      );
                    }
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  },
                  itemCount: rooms.length + 1,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onScroll(SeeAllBloc bloc) {
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    if (offset + offsetVisibleThreshold >= max) {
      bloc.load();
    }
  }

  Future<void> makeAnimation() async {
    final max = _scrollController.position.maxScrollExtent;

    await _scrollController.animateTo(
      max - offsetVisibleThreshold * 2,
      duration: Duration(milliseconds: 500, seconds: 1),
      curve: Curves.easeOut,
    );
  }
}

class _SeeAllRoomItem extends StatefulWidget {
  final int index;
  final int length;
  final SeeAllRoomItem item;

  const _SeeAllRoomItem({
    Key key,
    @required this.index,
    @required this.length,
    @required this.item,
  }) : super(key: key);

  @override
  _SeeAllRoomItemState createState() => _SeeAllRoomItemState();
}

class _SeeAllRoomItemState extends State<_SeeAllRoomItem>
    with TickerProviderStateMixin<_SeeAllRoomItem> {
  AnimationController _scaleController;
  Animation<double> _scale;

  Animation<Offset> _position;
  AnimationController _positionController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _scale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOut,
      ),
    );

    _positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _position = Tween(begin: Offset(2.0, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _positionController,
        curve: Curves.easeOut,
      ),
    );

    _scaleController.forward();
    _positionController.forward();
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale =
        BlocProvider.of<LocaleBloc>(context).locale$.value.languageCode;
    final subTitle14 =
        Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14);
    final subTitle12 = subTitle14.copyWith(fontSize: 12);

    final item = widget.item;
    final index = widget.index;
    final length = widget.length;

    return ScaleTransition(
      child: SlideTransition(
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Color(0xfffafafa),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ]),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/room_detail',
                arguments: item.id,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Hero(
                  tag: item.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: FadeInImage.assetNetwork(
                      width: 64.0 * 1.6,
                      height: 96.0 * 1.6,
                      image: item.image ?? '',
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/home_appbar_image.jpg',
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.title.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${item.districtName} - ${item.address}',
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: subTitle14,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        item.price,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontSize: 15,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        S.of(context).created_date(
                            DateFormat.yMMMd(currentLocale)
                                .add_Hm()
                                .format(item.createdTime)),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: subTitle12,
                      ),
                      Text(
                        S.of(context).last_updated_date(
                            DateFormat.yMMMd(currentLocale)
                                .add_Hm()
                                .format(item.createdTime)),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: subTitle12,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                if (Injector.of(context).debug) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${index + 1}/$length',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  )
                ],
              ],
            ),
          ),
        ),
        position: _position,
      ),
      scale: _scale,
    );
  }
}
