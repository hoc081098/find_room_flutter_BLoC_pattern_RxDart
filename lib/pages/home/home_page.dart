import 'dart:async';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/room_detail_page.dart';
import 'package:find_room/pages/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

final priceFormat = NumberFormat.currency();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<String> _streamSubscription;

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
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Phòng trọ tốt'),
            background: Image.network(
              'https://avatars2.githubusercontent.com/u/36917223?s=460&v=4',
              fit: BoxFit.cover,
            ),
          ),
        ),
        _buildHeaderItem(homeBloc.latestRooms),
        _buildRoomsList(homeBloc.latestRooms, homeBloc.addOrRemoveSaved.add),
        _buildBannerItem(homeBloc.bannerSliders),
        _buildHeaderItem(homeBloc.hottestRooms),
        _buildRoomsList(homeBloc.hottestRooms, homeBloc.addOrRemoveSaved.add),
      ],
    );
  }

  Widget _buildRoomsList(
    ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> stream,
    void Function(String) addOrRemoveSaved,
  ) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      sliver: StreamBuilder<Tuple2<HeaderItem, List<RoomItem>>>(
        stream: stream,
        initialData: stream.value,
        builder: (
          BuildContext context,
          AsyncSnapshot<Tuple2<HeaderItem, List<RoomItem>>> snapshot,
        ) {
          final list = snapshot.data.item2;

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              childAspectRatio: 1 / 1.618,
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildRoomItem(
                  list[index],
                  context,
                  addOrRemoveSaved,
                );
              },
              childCount: list.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderItem(
    ValueObservable<Tuple2<HeaderItem, List<RoomItem>>> stream,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.deepOrange,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder<Tuple2<HeaderItem, List<RoomItem>>>(
              stream: stream,
              initialData: stream.value,
              builder: (
                BuildContext context,
                AsyncSnapshot<Tuple2<HeaderItem, List<RoomItem>>> snapshot,
              ) {
                return Text(
                  snapshot.data.item1.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
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
  }

  Widget _buildRoomItem(
    RoomItem item,
    BuildContext context,
    void Function(String roomId) addOrRemoveSaved,
  ) {
    return InkResponse(
      child: Card(
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
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black38,
                child: Column(
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      priceFormat.format(item.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RoomDetailPage()),
        );
      },
    );
  }

  Widget _buildBannerItem(ValueObservable<BannerSlider> stream) {
    return SliverToBoxAdapter(
      child: StreamBuilder<BannerSlider>(
        stream: stream,
        initialData: stream.value,
        builder: (
          BuildContext context,
          AsyncSnapshot<BannerSlider> snapshot,
        ) {
          final images = snapshot.data.images;

          return SizedBox(
            height: 250,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  images[index].image,
                  fit: BoxFit.cover,
                );
              },
              itemCount: images.length,
              pagination: SwiperPagination(),
              control: SwiperControl(),
              autoplay: true,
              autoplayDelay: 2500,
              duration: 1000,
              curve: Curves.easeOut,
            ),
          );
        },
      ),
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
}
