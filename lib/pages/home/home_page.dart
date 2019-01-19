import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/models/province.dart';
import 'package:find_room/pages/detail/room_detail_page.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:find_room/pages/home/see_all_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<String> _streamSubscription;

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thoát khỏi ứng dụng'),
          content: const Text('Bạn chắc chắn muốn thoát khỏi ứng dụng'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Không'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: const Text('Thoát'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewestRoomsList(
    ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> rooms$,
    void Function(String) addOrRemoveSaved,
  ) {
    return StreamBuilder<Tuple2<HeaderItem, List<RoomItem>>>(
      stream: rooms$,
      initialData: rooms$.value,
      builder: (
        BuildContext context,
        AsyncSnapshot<Tuple2<HeaderItem, List<RoomItem>>> snapshot,
      ) {
        final list = snapshot.data.item2;
        final Widget sliver = list.isEmpty
            ? _buildEmptyListSliver(context)
            : SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1 / 1.618,
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildNewestRoomItem(
                      list[index],
                      context,
                      addOrRemoveSaved,
                    );
                  },
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _streamSubscription?.cancel();
    _streamSubscription =
        BlocProvider.of<HomeBloc>(context).message$.listen(_showMessage);
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Cài đặt',
                onPressed: () {
                  print('Setting pressed');
                },
              ),
            ],
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Phòng trọ tốt',
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
          _buildSelectedProvince(homeBloc.selectedProvinceAndAllProvinces$,
              homeBloc.changeProvince.add),
          _buildHeaderItem(homeBloc.newestRooms$, context),
          _buildNewestRoomsList(
            homeBloc.newestRooms$,
            homeBloc.addOrRemoveSaved.add,
          ),
          _buildBannersSlider(homeBloc.banner$),
          _buildHeaderItem(homeBloc.mostViewedRooms$, context),
          _buildMostViewedRoomsList(
            homeBloc.mostViewedRooms$,
            homeBloc.addOrRemoveSaved.add,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(
    ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> rooms$,
    BuildContext context,
  ) {
    return StreamBuilder<Tuple2<HeaderItem, List<RoomItem>>>(
      stream: rooms$,
      initialData: rooms$.value,
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<HeaderItem, List<RoomItem>>> snapshot) {
        final HeaderItem headerItem = snapshot.data.item1;

        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  headerItem.title,
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
                        builder: (BuildContext context) =>
                            SeeAllPage(headerItem.seeAllQuery),
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Xem tất cả",
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
      },
    );
  }

  Widget _buildNewestRoomItem(
    RoomItem item,
    BuildContext context,
    void Function(String roomId) addOrRemoveSaved,
  ) {
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
            child: _buildBookmarkIcon(
              item,
              addOrRemoveSaved,
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkIcon(
    RoomItem item,
    void addOrRemoveSaved(String roomId),
    BuildContext context,
  ) {
    if (item.iconState == BookmarkIconState.hide) {
      return SizedBox(width: 0, height: 0);
    }
    final accentColor = Theme.of(context).accentColor;
    final Widget iconButton = IconButton(
      icon: item.iconState == BookmarkIconState.showNotSaved
          ? Icon(
              Icons.bookmark_border,
              color: accentColor,
            )
          : Icon(
              Icons.bookmark,
              color: accentColor,
            ),
      onPressed: () => addOrRemoveSaved(item.id),
      tooltip: item.iconState == BookmarkIconState.showNotSaved
          ? 'Thêm vào đã lưu'
          : 'Xóa khỏi đã lưu',
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: iconButton,
    );
  }

  Widget _buildBannersSlider(ValueObservable<List<BannerItem>> banners$) {
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
                          placeholder: CircularProgressIndicator(
                            strokeWidth: 3.0,
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

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _showMessage(String message) {
    if (message != null) {
      Scaffold.of(context, nullOk: true)?.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(message),
        ),
      );
    }
  }

  Widget _buildMostViewedRoomsList(
    ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> rooms$,
    void Function(String) addOrRemoveSaved,
  ) {
    return StreamBuilder<Tuple2<HeaderItem, List<RoomItem>>>(
      stream: rooms$,
      initialData: rooms$.value,
      builder: (
        BuildContext context,
        AsyncSnapshot<Tuple2<HeaderItem, List<RoomItem>>> snapshot,
      ) {
        final list = snapshot.data.item2;
        final Widget silver = list.isEmpty
            ? _buildEmptyListSliver(context)
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildMostViewedRoomItem(
                      list[index],
                      context,
                      addOrRemoveSaved,
                    );
                  },
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

  SliverToBoxAdapter _buildEmptyListSliver(BuildContext context) {
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
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'Chưa có nhà trọ nào...',
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostViewedRoomItem(
    RoomItem item,
    BuildContext context,
    void Function(String) addOrRemoveSaved,
  ) {
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
            trailing: _buildBookmarkIcon(
              item,
              addOrRemoveSaved,
              context,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedProvince(
    ValueObservable<Tuple2<Province, List<Province>>>
        selectedProvinceAndAllProvinces$,
    void Function(Province) changeSelectedProvince,
  ) {
    return StreamBuilder<Tuple2<Province, List<Province>>>(
      initialData: selectedProvinceAndAllProvinces$.value,
      stream: selectedProvinceAndAllProvinces$,
      builder: (
        BuildContext context,
        AsyncSnapshot<Tuple2<Province, List<Province>>> snapshot,
      ) {
        print(snapshot);
        final Tuple2<Province, List<Province>> data = snapshot.data;
        var themeData = Theme.of(context);
        final subtitle = themeData.textTheme.subtitle.copyWith(fontSize: 16);

        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: Material(
              type: MaterialType.card,
              elevation: 3.0,
              borderRadius: BorderRadius.circular(24),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
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
                                    color: themeData.accentColor,
                                    size: 28,
                                  )
                                ],
                              ),
                            ),
                            tooltip: 'Thay đổi khu vực',
                            onSelected: changeSelectedProvince,
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
          ),
        );
      },
    );
  }
}
