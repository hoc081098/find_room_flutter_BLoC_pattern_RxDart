import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/detail/detail/room_detail_tab_bloc.dart';
import 'package:find_room/pages/detail/detail/room_detail_tab_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailTabPage extends StatefulWidget {
  const RoomDetailTabPage({Key key}) : super(key: key);

  @override
  _RoomDetailTabPageState createState() => _RoomDetailTabPageState();
}

class _RoomDetailTabPageState extends State<RoomDetailTabPage> {
  @override
  void initState() {
    super.initState();
    print('DetailTab { init }');
  }

  @override
  void dispose() {
    print('DetailTab { dispose }');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bloc = BlocProvider.of<RoomDetailTabBloc>(context);

    return StreamBuilder<RoomDetailTabState>(
      stream: bloc.state$,
      initialData: bloc.state$.value,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final room = state.room;
        final user = state.user;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            _TopImageSlider(
              height: height,
              room: room,
            ),
            _FirstCard(room: room),
            _SecondCard(room: room),
            _ThirdCard(user: user),
            _AmenitiesCard(room: room),
            _DescriptionWidget(room: room),
            SliverToBoxAdapter(
              child: SizedBox(
                height: height * 0.1,
              ),
            )
          ],
        );
      },
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key key,
    @required this.room,
  }) : super(key: key);

  final RoomDetailState room;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 1.5,
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text('Description'),
          children: <Widget>[
            Container(
              child: Text(
                room == null ? S.of(context).loading : room.description,
                style: Theme.of(context).textTheme.subtitle,
              ),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ThirdCard extends StatelessWidget {
  const _ThirdCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final UserState user;

  @override
  Widget build(BuildContext context) {
    final titleTextTheme = Theme.of(context).textTheme.title;

    return SliverToBoxAdapter(
      child: Card(
        elevation: 1.5,
        child: InkWell(
          onTap: () {
            if (user == null) {
              return;
            }
            Navigator.pushNamed(
              context,
              '/user_profile',
              arguments: user.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Posted by',
                  textAlign: TextAlign.start,
                  style: titleTextTheme.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF-Pro-Display',
                    color: Theme.of(context).accentColor,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user?.avatar ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Center(
                              child:  CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                              width: 80,
                              height: 80,
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
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  user != null
                                      ? user.fullName
                                      : S.of(context).loading,
                                  textAlign: TextAlign.start,
                                  style: titleTextTheme.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  user != null
                                      ? user.email
                                      : S.of(context).loading,
                                  textAlign: TextAlign.start,
                                  style: titleTextTheme.copyWith(
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  user == null
                                      ? S.of(context).loading
                                      : user.phoneNumber ??
                                          'Have not phone number',
                                  textAlign: TextAlign.start,
                                  style: titleTextTheme.copyWith(
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () async {
                        if (user == null) {
                          return;
                        }
                        final url = 'tel:${user.phoneNumber}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cannot launch call'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.call),
                      label: Text('Call'),
                    ),
                    FlatButton.icon(
                      onPressed: () async {
                        if (user == null) {
                          return;
                        }
                        final url = 'sms:${user.phoneNumber}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cannot launch sms'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.sms),
                      label: Text('Send sms'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondCard extends StatelessWidget {
  const _SecondCard({
    Key key,
    @required this.room,
  }) : super(key: key);

  final RoomDetailState room;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Card(
        elevation: 1.5,
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
                        room == null ? S.of(context).loading : room.price,
                        style: textTheme.subhead.copyWith(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        room == null ? S.of(context).loading : room.address,
                        style: textTheme.subtitle,
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
                Expanded(
                  child: Text(
                    'Posted at: ${room == null ? S.of(context).loading : room.createdAt}',
                    style: textTheme.title.copyWith(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const SizedBox(width: 8),
                Icon(Icons.update),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Updated at: ${room == null ? S.of(context).loading : room.updatedAt}',
                    style: textTheme.title.copyWith(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const SizedBox(width: 8),
                Icon(Icons.dashboard),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    room == null ? S.of(context).loading : room.size,
                    style: textTheme.title.copyWith(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _FirstCard extends StatelessWidget {
  const _FirstCard({
    Key key,
    @required this.room,
  }) : super(key: key);

  final RoomDetailState room;

  @override
  Widget build(BuildContext context) {
    final titleTextTheme = Theme.of(context).textTheme.title;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        child: Card(
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.category),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        room == null
                            ? S.of(context).loading
                            : room.categoryName,
                        style: titleTextTheme.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF-Pro-Display',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.title),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        room == null ? S.of(context).loading : room.title,
                        style: titleTextTheme.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'Available',
                              textAlign: TextAlign.center,
                              style: titleTextTheme.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              room == null
                                  ? S.of(context).loading
                                  : room.available ? 'Yes' : 'No',
                              textAlign: TextAlign.center,
                              style: titleTextTheme.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'View count',
                              textAlign: TextAlign.center,
                              style: titleTextTheme.copyWith(
                                color: Theme.of(context).accentColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              room == null
                                  ? S.of(context).loading
                                  : room.countView,
                              textAlign: TextAlign.center,
                              style: titleTextTheme.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopImageSlider extends StatelessWidget {
  const _TopImageSlider({
    Key key,
    @required this.height,
    @required this.room,
  }) : super(key: key);

  final double height;
  final RoomDetailState room;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return SliverAppBar(
      pinned: false,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      expandedHeight: height * 0.35,
      flexibleSpace: FlexibleSpaceBar(
        background: Swiper(
          itemBuilder: (BuildContext context, int index) {
            if (room == null || room.images.isEmpty) {
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
                      S.of(context).loading,
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
                      imageUrl: room.images[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child:  Icon(
                              Icons.image,
                              color: Theme.of(context).accentColor,
                            ),
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
          itemCount:
              room == null || room.images.isEmpty ? 1 : room.images.length,
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
    );
  }
}

class _AmenitiesCard extends StatelessWidget {
  final RoomDetailState room;

  const _AmenitiesCard({Key key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 1.5,
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text('Amenities'),
          children: <Widget>[
            room == null
                ? const CircularProgressIndicator()
                : _amenitiesList(room.utilities),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _amenitiesList(BuiltList<Utility> utilities) {
    print('## ${utilities.length}');
    const numberItemsPerRow = 4;

    final numberOfRows = (utilities.length / numberItemsPerRow).ceil();
    final widgetRows = List.generate(numberOfRows, (row) {
      final items = [
        for (var j = 0; j < numberItemsPerRow; j++)
          if (row * numberItemsPerRow + j < utilities.length)
            _UtilityWidget(
              utility: utilities[row * numberItemsPerRow + j],
            )
          else
            _UtilityWidget()
      ];

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      );
    });

    return Column(
      children: widgetRows,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}

class _UtilityWidget extends StatelessWidget {
  final Utility utility;

  const _UtilityWidget({Key key, this.utility}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;

    switch (utility?.name) {
      case 'wifi':
        icon = Icons.wifi;
        title = 'Wifi';
        break;
      case 'private_wc':
        icon = Icons.wc;
        title = 'Private WC';
        break;
      case 'bed':
        icon = FontAwesomeIcons.bed;
        title = 'Bed';
        break;
      case 'easy':
        icon = FontAwesomeIcons.goodreads;
        title = 'Easy';
        break;
      case 'parking':
        icon = Icons.local_parking;
        title = 'Parking';
        break;
      case 'without_owner':
        icon = Icons.iso;
        title = 'Without owner';
        break;
    }

    final width = (MediaQuery.of(context).size.width - 3 * 8) / 4;
    if (icon != null && title != null) {
      return Container(
        padding: const EdgeInsets.all(4),
        width: width,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(icon),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: width,
      );
    }
  }
}
