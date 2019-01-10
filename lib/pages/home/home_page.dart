import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/room_detail_page.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:find_room/pages/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:cached_network_image/cached_network_image.dart';

final priceFormat = NumberFormat.currency();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<String> _streamSubscription;

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
            ? SliverToBoxAdapter(
                child: Text(
                  'Chưa có nhà trọ nào...',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.center,
                ),
              )
            : SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
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

    if (_streamSubscription == null) {
      _streamSubscription = BlocProvider.of<HomeBloc>(context)
          .messageAddOrRemoveSavedRoom
          .listen(_showMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
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
                          Colors.black87,
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
        _buildHeaderItem(homeBloc.latestRooms, context),
        _buildNewestRoomsList(
          homeBloc.latestRooms,
          homeBloc.addOrRemoveSaved.add,
        ),
        _buildBannerItem(homeBloc.bannerSliders),
        _buildHeaderItem(homeBloc.hottestRooms, context),
        _buildHottestRoomsList(
          homeBloc.hottestRooms,
          homeBloc.addOrRemoveSaved.add,
        ),
      ],
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
        return SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).accentColor,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  snapshot.data.item1.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
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
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RoomDetailPage()),
          );
        },
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
                color: Colors.black26,
                child: Column(
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subhead.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'SF-Pro-Text',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      priceFormat.format(item.price),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'SF-Pro-Text',
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      item.address,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
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
                      style: Theme.of(context).textTheme.subtitle.copyWith(
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
            Positioned(
              right: 4.0,
              top: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: item.iconState == BookmarkIconState.hide
                    ? Container()
                    : IconButton(
                        icon: item.iconState == BookmarkIconState.showNotSaved
                            ? Icon(Icons.bookmark_border)
                            : Icon(Icons.bookmark),
                        onPressed: () => addOrRemoveSaved(item.id),
                        tooltip:
                            item.iconState == BookmarkIconState.showNotSaved
                                ? 'Thêm vào đã lưu'
                                : 'Xóa khỏi đã lưu',
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBannerItem(ValueObservable<List<BannerItem>> banners$) {
    return StreamBuilder<List<BannerItem>>(
      stream: banners$,
      initialData: banners$.value,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<BannerItem>> snapshot,
      ) {
        final items = snapshot.data;

        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 250,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    items[index].image,
                    fit: BoxFit.cover,
                  );
                },
                itemCount: items.length,
                pagination: SwiperPagination(),
                control: SwiperControl(),
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
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildHottestRoomsList(
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
            ? SliverToBoxAdapter(
                child: Text(
                  'Chưa có nhà trọ nào...',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.center,
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildHottestRoomItem(
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

  Widget _buildHottestRoomItem(
    RoomItem item,
    BuildContext context,
    void Function(String) addOrRemoveSaved,
  ) {
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
        child: ListTile(
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(item.image),
          ),
          title: Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  fontSize: 14,
                  fontFamily: 'SF-Pro-Text',
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Column(
            children: <Widget>[
              Text(
                priceFormat.format(item.price),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: Theme.of(context).accentColor,
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
                style: Theme.of(context).textTheme.subtitle.copyWith(
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
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: Colors.black87,
                      fontSize: 12,
                      fontFamily: 'SF-Pro-Text',
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: item.iconState == BookmarkIconState.hide
                ? Container()
                : IconButton(
                    icon: item.iconState == BookmarkIconState.showNotSaved
                        ? Icon(Icons.bookmark_border)
                        : Icon(Icons.bookmark),
                    onPressed: () => addOrRemoveSaved(item.id),
                    tooltip: item.iconState == BookmarkIconState.showNotSaved
                        ? 'Thêm vào đã lưu'
                        : 'Xóa khỏi đã lưu',
                  ),
          ),
        ),
      ),
    );
  }
}
