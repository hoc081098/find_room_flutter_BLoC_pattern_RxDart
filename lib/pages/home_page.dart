import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

final priceFormat = NumberFormat.currency();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Phòng trọ tốt'),
      ),
      body: new StreamBuilder<List<HomeListItem>>(
        stream: homeBloc.homeListItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<HomeListItem>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var items = snapshot.data;
          return new StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: items.length,
            staggeredTileBuilder: (int index) {
              return new StaggeredTile.fit(items[index] is RoomItem ? 1 : 2);
            },
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            itemBuilder: (BuildContext context, int index) => _buildHomeItem(
                  context,
                  items[index],
                  homeBloc,
                ),
          );
        },
      ),
    );
  }

  Widget _buildHomeItem(
      BuildContext context, HomeListItem item, HomeBloc homeBloc) {
    if (item is BannerItem) {
      return _buildBannerItem(context, item);
    }
    if (item is HeaderItem) {
      return _buildHeaderItem(item);
    }
    if (item is SeeAll) {
      return _buildSeeAllItem(context);
    }
    if (item is RoomItem) {
      return _buildRoomItem(item, context, homeBloc);
    }
    return null;
  }

  Text _buildHeaderItem(HeaderItem item) {
    return Text(
      item.title,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Color(0xff212121),
        fontSize: 18,
      ),
    );
  }

  MaterialButton _buildSeeAllItem(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).accentColor,
      onPressed: () {},
      height: 56,
      child: Text(
        'Xem tất cả',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  GestureDetector _buildRoomItem(
      RoomItem item, BuildContext context, HomeBloc homeBloc) {
    return GestureDetector(
      child: new Card(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            new Radius.circular(2.0),
          ),
        ),
        elevation: 2.0,
        child: new AspectRatio(
          child: new Stack(
            children: <Widget>[
              new Positioned.fill(
                child: new Image.network(
                  item.image,
                  fit: BoxFit.cover,
                ),
              ),
              new Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: new Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black38,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      new Text(
                        priceFormat.format(item.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              new Positioned(
                right: 4.0,
                top: 4.0,
                child: GestureDetector(
                  onTap: () {
                    print("tap");
                  },
                  child: item.iconState == BookmarkIconState.hide
                      ? new Container()
                      : new IconButton(
                          icon: item.iconState == BookmarkIconState.showNotSaved
                              ? Icon(Icons.bookmark_border)
                              : Icon(Icons.bookmark),
                          onPressed: () => homeBloc.addOrRemoveSaved(item.id),
                          tooltip:
                              item.iconState == BookmarkIconState.showNotSaved
                                  ? 'Thêm vào đã lưu'
                                  : 'Xóa khỏi đã lưu',
                        ),
                ),
              )
            ],
          ),
          aspectRatio: 1 / 1.618,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (BuildContext context) {}),
        );
      },
    );
  }

  Widget _buildBannerItem(BuildContext context, BannerItem item) {
    return Container(
      height: 400,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: new SizedBox(
              width: double.infinity,
              height: 300,
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    item.images[index].image,
                    height: 300,
                    fit: BoxFit.cover,
                  );
                },
                itemCount: item.images.length,
                pagination: new SwiperPagination(),
                control: new SwiperControl(),
                autoplay: true,
                autoplayDelay: 1500,
              ),
            ),
          ),
          Positioned(
            top: 250,
            child: SizedBox(
              width: double.infinity,
              height: 128,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      8,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    item.selectedProvinceName,
                    textScaleFactor: 1.1,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
