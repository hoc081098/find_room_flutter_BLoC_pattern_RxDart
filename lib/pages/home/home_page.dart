import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/pages/detail/room_detail_page.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/pages/home/see_all_page.dart';
import 'package:find_room/pages/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tuple/tuple.dart';

class MyHomePage extends StatefulWidget {
  final HomeBloc homeBloc;

  const MyHomePage({
    Key key,
    @required this.homeBloc,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _subscription;
  HomeBloc homeBloc;

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        final s = S.of(context);

        return AlertDialog(
          title: Text(s.exit_app),
          content: Text(s.sure_want_to_exit_app),
          actions: <Widget>[
            FlatButton(
              child: Text(s.no),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(s.exit),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    homeBloc = widget.homeBloc;
    _subscription = homeBloc.message$.listen(_showMessage);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: s.settings,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingPage(
                          localeBloc: BlocProvider.of<LocaleBloc>(context),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                s.app_title,
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.41,
                  fontFamily: 'SF-Pro-Display',
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/images/home_appbar_image.jpg',
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      constraints: BoxConstraints.expand(height: 50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.black38,
                            Colors.transparent,
                          ],
                          begin: AlignmentDirectional.bottomCenter,
                          end: AlignmentDirectional.topCenter,
                        ),
                      ),
                    ),
                  )
                ],
                fit: StackFit.expand,
              ),
            ),
          ),
          const HomeSelectedProvince(),
          const HomeHeaderItem(seeAllQuery: SeeAllQuery.newest),
          const HomeNewestRoomsList(),
          const HomeBannerSlider(),
          const HomeHeaderItem(seeAllQuery: SeeAllQuery.mostViewed),
          const HomeMostViewedRoomsList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _showMessage(HomeMessage message) {
    print('[DEBUG] home_message=$message');
    var s = S.of(context);

    if (message is ChangeSelectedProvinceMessage) {
      if (message is ChangeSelectedProvinceMessageSuccess) {
        _showSnackBar(s.change_province_success(message.provinceName));
      }
      if (message is ChangeSelectedProvinceMessageError) {
        _showSnackBar(s.change_province_error(message.provinceName));
      }
    }
    if (message is AddOrRemovedSavedMessage) {
      if (message is AddSavedMessageSuccess) {
        _showSnackBar(s.add_saved_room_success);
      }
      if (message is RemoveSavedMessageSuccess) {
        _showSnackBar(s.remove_saved_room_success);
      }
      if (message is AddOrRemovedSavedMessageError) {
        if (message.error is NotLoginError) {
          _showSnackBar(s.require_login);
        } else {
          _showSnackBar(s.add_or_remove_saved_room_error);
        }
      }
    }
  }

  _showSnackBar(String message) {
    Scaffold.of(context, nullOk: true)?.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(message),
      ),
    );
  }
}

class HomeSelectedProvince extends StatelessWidget {
  const HomeSelectedProvince({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    final selectedProvinceAndAllProvinces$ =
        homeBloc.selectedProvinceAndAllProvinces$;

    return StreamBuilder<Tuple2<Province, List<Province>>>(
      initialData: selectedProvinceAndAllProvinces$.value,
      stream: selectedProvinceAndAllProvinces$,
      builder: (context, snapshot) {
        print('[DEBUG] province $snapshot');

        final Tuple2<Province, List<Province>> data = snapshot.data;
        final themeData = Theme.of(context);
        final subtitle = themeData.textTheme.subtitle.copyWith(fontSize: 16);

        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            width: double.infinity,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.location_on,
                            size: 30,
                            color: themeData.primaryColor,
                          ),
                        ),
                        PopupMenuButton<Province>(
                          initialValue: data.item1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  data.item1?.name ?? '',
                                  style: subtitle,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: themeData.primaryColor,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                          onSelected: homeBloc.changeProvince.add,
                          itemBuilder: (BuildContext context) {
                            return data.item2.map((province) {
                              return PopupMenuItem<Province>(
                                child: Text(
                                  province.name,
                                  style: subtitle,
                                ),
                                value: province,
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                    TextField(
                      onChanged: (value) {
                        //TODO: search text changed
                      },
                      style: subtitle,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: 4,
                              top: 4,
                              bottom: 4,
                            ),
                            child: Material(
                              elevation: 2,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () {
                                  //TODO: navigate to search
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: themeData.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeHeaderItem extends StatelessWidget {
  final SeeAllQuery seeAllQuery;

  const HomeHeaderItem({
    Key key,
    @required this.seeAllQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    String headerItemTitle;
    if (seeAllQuery == SeeAllQuery.mostViewed) {
      headerItemTitle = s.mostViewed;
    } else if (seeAllQuery == SeeAllQuery.newest) {
      headerItemTitle = s.newest;
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              headerItemTitle,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SeeAllPage(seeAllQuery),
                  ),
                );
              },
              padding: const EdgeInsets.all(12.0),
              child: Text(
                s.see_all,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// Newest
///

class HomeNewestRoomsList extends StatelessWidget {
  const HomeNewestRoomsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rooms$ = BlocProvider.of<HomeBloc>(context).newestRooms$;

    return StreamBuilder<List<RoomItem>>(
      stream: rooms$,
      initialData: rooms$.value,
      builder: (context, snapshot) {
        final list = snapshot.data;

        final Widget sliver = list.isEmpty
            ? const HomeEmptyRoomList()
            : SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1 / 1.618,
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      HomeNewestRoomsListItem(item: list[index]),
                  childCount: list.length,
                ),
              );

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          sliver: sliver,
        );
      },
    );
  }
}

class HomeNewestRoomsListItem extends StatelessWidget {
  final RoomItem item;

  const HomeNewestRoomsListItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      elevation: 2.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: item.image,
              fit: BoxFit.cover,
              placeholder: Center(
                child: new CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
              errorWidget: Center(
                child: new Icon(
                  Icons.image,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.black38,
                    Colors.black26,
                    Colors.black12,
                    Colors.transparent,
                  ],
                  begin: AlignmentDirectional.bottomCenter,
                  end: AlignmentDirectional.topCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: themeData.textTheme.subhead.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'SF-Pro-Text',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    item.price,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: themeData.textTheme.subtitle.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'SF-Pro-Display',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    item.address,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: themeData.textTheme.subtitle.copyWith(
                      color: Colors.grey[50],
                      fontSize: 12,
                      fontFamily: 'SF-Pro-Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    item.districtName,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: themeData.textTheme.subtitle.copyWith(
                      color: Colors.grey[50],
                      fontSize: 12,
                      fontFamily: 'SF-Pro-Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: InkWell(
                splashColor: themeData.accentColor.withOpacity(0.5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RoomDetailPage()),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 4.0,
            top: 4.0,
            child: HomeBookmarkIcon(roomItem: item),
          ),
        ],
      ),
    );
  }
}

///
///
///

class HomeEmptyRoomList extends StatelessWidget {
  const HomeEmptyRoomList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
              S.of(context).empty_rooms,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeBookmarkIcon extends StatelessWidget {
  final RoomItem roomItem;

  const HomeBookmarkIcon({
    Key key,
    @required this.roomItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (roomItem.iconState == BookmarkIconState.hide) {
      return SizedBox(width: 0, height: 0);
    }
    final accentColor = Theme.of(context).accentColor;
    final s = S.of(context);

    final Widget iconButton = IconButton(
      icon: roomItem.iconState == BookmarkIconState.showNotSaved
          ? Icon(
              Icons.bookmark_border,
              color: accentColor,
            )
          : Icon(
              Icons.bookmark,
              color: accentColor,
            ),
      onPressed: () =>
          BlocProvider.of<HomeBloc>(context).addOrRemoveSaved.add(roomItem.id),
      tooltip: roomItem.iconState == BookmarkIconState.showNotSaved
          ? s.add_to_saved
          : s.remove_from_saved,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: iconButton,
    );
  }
}

///
/// Slide
///

class HomeBannerSlider extends StatelessWidget {
  const HomeBannerSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final banners$ = BlocProvider.of<HomeBloc>(context).banner$;

    return StreamBuilder<List<BannerItem>>(
      stream: banners$,
      initialData: banners$.value,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<BannerItem>> snapshot,
      ) {
        final items = snapshot.data;
        final themeData = Theme.of(context);

        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 250,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  if (items.isEmpty) {
                    return Container(
                      constraints: BoxConstraints.expand(),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                          ),
                          Text(
                            'Loading...',
                            style: themeData.textTheme.subtitle,
                          )
                        ],
                      ),
                    );
                  }
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: items[index].image,
                          fit: BoxFit.cover,
                          placeholder: Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: Center(
                            child: new Icon(
                              Icons.image,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.black38,
                                Colors.transparent,
                              ],
                              begin: AlignmentDirectional.bottomCenter,
                              end: AlignmentDirectional.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 30,
                        child: Center(
                          child: Text(
                            items[index].description,
                            style: themeData.textTheme.caption.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: items.isEmpty ? 1 : items.length,
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    size: 8.0,
                    activeSize: 12.0,
                    activeColor: themeData.accentColor,
                  ),
                ),
                control: SwiperControl(
                  color: themeData.accentColor,
                  padding: const EdgeInsets.all(8),
                ),
                autoplay: true,
                autoplayDelay: 2500,
                duration: 1000,
                curve: Curves.easeOut,
              ),
            ),
          ),
        );
      },
    );
  }
}

///
/// Most viewed
///

class HomeMostViewedRoomListItem extends StatelessWidget {
  final RoomItem item;

  const HomeMostViewedRoomListItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            2.0,
          ),
        ),
      ),
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => RoomDetailPage(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundImage: CachedNetworkImageProvider(item.image),
              backgroundColor: Colors.transparent,
            ),
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
              ],
            ),
            isThreeLine: true,
            trailing: HomeBookmarkIcon(roomItem: item),
          ),
        ),
      ),
    );
  }
}

class HomeMostViewedRoomsList extends StatelessWidget {
  const HomeMostViewedRoomsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rooms$ = BlocProvider.of<HomeBloc>(context).mostViewedRooms$;

    return StreamBuilder<List<RoomItem>>(
      stream: rooms$,
      initialData: rooms$.value,
      builder: (context, snapshot) {
        final list = snapshot.data;

        final Widget silver = list.isEmpty
            ? const HomeEmptyRoomList()
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      HomeMostViewedRoomListItem(item: list[index]),
                  childCount: list.length,
                ),
              );

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          sliver: silver,
        );
      },
    );
  }
}
