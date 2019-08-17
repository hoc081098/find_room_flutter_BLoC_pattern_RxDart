import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RoomDetailTabPage extends StatefulWidget {
  const RoomDetailTabPage({Key key}) : super(key: key);

  @override
  _RoomDetailTabPageState createState() => _RoomDetailTabPageState();
}

class _RoomDetailTabPageState extends State<RoomDetailTabPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final items = <String>[
      'https://nhatrodanang.com/mp-up/2017/08/20994171_1587446847965947_277045196745289657_n.jpg',
      'https://file1.batdongsan.com.vn/guestthumb745x510.20131121035314961.jpg',
      'https://1023259.v1.pressablecdn.com/wp-content/uploads/2019/06/tro-da-nang-anh-1.jpg',
    ];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          automaticallyImplyLeading: false,
          expandedHeight: height * 0.35,
          flexibleSpace: FlexibleSpaceBar(
            background: Swiper(
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
                      child: InkWell(
                        child: CachedNetworkImage(
                          imageUrl: items[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Center(
                              child: new Icon(
                                Icons.image,
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          print('Tapped $index');
                        },
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
                          'Image ${index + 1}',
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
              autoplayDelay: 2000,
              duration: 800,
              autoplayDisableOnInteraction: true,
              curve: Curves.easeOut,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '800,000 VND',
                            style: Theme.of(context).textTheme.subhead.copyWith(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '54 Nguyễn Lương Bằng, Phường Hòa Khánh, Quận Liên Chiểu, Thành phố Đà Nẵng 54',
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.network(
                      'http://mt0.google.com/vt/lyrs=m@127&hl=en&gl=in&src=api&x=11720&y=7594&z=14&s=Ga',
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 8),
                    Icon(Icons.date_range),
                    const SizedBox(width: 4),
                    Text(
                      'Posted date: 28/08/2018',
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 15),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.dashboard),
                          const SizedBox(width: 4),
                          Text(
                            '25m2',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        )
      ],
    );
  }
}
