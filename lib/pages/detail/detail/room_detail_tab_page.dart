import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/dependency_injection.dart';
import 'package:find_room/models/room_entity.dart';
import 'package:find_room/models/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

class RoomDetailTabPage extends StatefulWidget {
  final String id;

  const RoomDetailTabPage({Key key, this.id}) : super(key: key);

  @override
  _RoomDetailTabPageState createState() => _RoomDetailTabPageState();
}

class _RoomDetailTabPageState extends State<RoomDetailTabPage> {
  RoomEntity _room;
  UserEntity _user;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .document('motelrooms/${widget.id}')
        .get()
        .then((snapshot) {
      _room = RoomEntity.fromDocumentSnapshot(snapshot);
      _room.user.get().then((snapshot1) {
        _user = UserEntity.fromDocumentSnapshot(snapshot1);
        setState(() {});
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_room == null) return Center(child: CircularProgressIndicator());

    final height = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final locale =
        BlocProvider.of<LocaleBloc>(context).locale$.value.languageCode;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          expandedHeight: height * 0.35,
          flexibleSpace: FlexibleSpaceBar(
            background: Swiper(
              itemBuilder: (BuildContext context, int index) {
                if (_room.images.isEmpty) {
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
                          imageUrl: _room.images[index],
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
                                child: new Icon(
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
              itemCount: _room.images.isEmpty ? 1 : _room.images.length,
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
                            _room.categoryName,
                            style: Theme.of(context).textTheme.title.copyWith(
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
                            _room.title,
                            style: Theme.of(context).textTheme.title.copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _room.available ? 'Yes' : 'No',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.decimalPattern(locale)
                                      .format(_room.countView),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
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
        ),
        SliverToBoxAdapter(
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
                            Injector.of(context)
                                .priceFormat
                                .format(_room.price),
                            style: Theme.of(context).textTheme.subhead.copyWith(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _room.address,
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
                    Expanded(
                      child: Text(
                        'Posted at: ${DateFormat.yMd(locale).add_Hms().format(_room.createdAt.toDate())}',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 15),
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
                        'Updated at: ${DateFormat.yMd(locale).add_Hms().format(_room.updatedAt.toDate())}',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 15),
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
                        '${_room.size}m2',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Card(
            elevation: 1.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Posted by',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF-Pro-Display',
                        ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(_user?.avatar ?? ''),
                          backgroundColor: Colors.white,
                          radius: 40,
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
                                    _user?.fullName ?? 'Loading...',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _user?.email ?? 'Loading...',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _user?.phone ?? 'Loading...',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
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
                        onPressed: () {
                          //TODO: Call
                        },
                        icon: Icon(Icons.call),
                        label: Text('Call'),
                      ),
                      FlatButton.icon(
                        onPressed: () {
                          //TODO: Sms
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
        SliverToBoxAdapter(
          child: ExpansionTile(
            title: Text('Description'),
            children: <Widget>[
              Container(
                child: Text(
                  _room.description * 10,
                  style: Theme.of(context).textTheme.subtitle,
                ),
                padding: const EdgeInsets.all(8),
                width: double.infinity,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: height * 0.1),
        )
      ],
    );
  }
}
