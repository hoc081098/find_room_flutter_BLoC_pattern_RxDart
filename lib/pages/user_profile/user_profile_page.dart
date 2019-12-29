import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/user_profile/user_profile_bloc.dart';
import 'package:find_room/pages/user_profile/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    print('[USER_PROFILE_PAGE]  { init }');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('[USER_PROFILE_PAGE]  { dep change }');
  }

  @override
  void dispose() {
    super.dispose();
    print('[USER_PROFILE_PAGE]  { dispose }');
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserProfileBloc>(context);
    final paddingTop = MediaQuery.of(context).padding.top;
    final display1Text30 = Theme.of(context).textTheme.display1.copyWith(
          fontSize: 30,
          fontFamily: 'SF-Pro-Display',
          color: Colors.white,
        );

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            color: Colors.grey.shade100,
          ),
        ),
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 400.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.indigo.shade400,
                  Colors.purple,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: paddingTop,
          child: StreamBuilder<UserProfileState>(
            initialData: bloc.state$.value,
            stream: bloc.state$,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final data = snapshot.data;
              final profile = data.profile;

              if (profile == null) {
                return Center(
                  child: Text(
                    S.of(context).user_not_found,
                    style: display1Text30,
                  ),
                );
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _ProfileInfoWidget(
                      profile: profile,
                      isCurrentUser: data.isCurrentUser,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _PostedRoomItem(
                          item: data.postedRooms[index],
                        );
                      },
                      childCount: data.postedRooms.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(
          top: paddingTop + 12,
          left: 8,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
            ),
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ),
        StreamBuilder<UserProfileState>(
          stream: bloc.state$,
          initialData: bloc.state$.value,
          builder: (context, snapshot) {
            return Positioned(
              top: paddingTop + 12,
              right: 8,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: (snapshot.data?.isCurrentUser ?? false) ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                  ),
                  child: IconButton(
                    tooltip: S.of(context).edit_profile,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final routeName = await showModalBottomSheet<String>(
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.info),
                                title: Text(S.of(context).update_user_info),
                                onTap: () =>
                                    Navigator.pop(context, '/update_user_info'),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              ListTile(
                                leading: const Icon(Icons.lock),
                                title: Text(S.of(context).change_password),
                                onTap: () =>
                                    Navigator.pop(context, '/change_password'),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ],
                          );
                        },
                        context: context,
                      );

                      await Navigator.pushNamed(
                        context,
                        routeName,
                        arguments: snapshot.data.profile.uid,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ProfileInfoWidget extends StatelessWidget {
  const _ProfileInfoWidget({
    Key key,
    @required this.profile,
    @required this.isCurrentUser,
  })  : assert(profile != null),
        assert(isCurrentUser != null),
        super(key: key);

  final UserProfile profile;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final display1Text16 = Theme.of(context).textTheme.title.copyWith(
          fontSize: 16,
        );
    final display1Text30 = Theme.of(context).textTheme.display1.copyWith(
          fontSize: 30,
          fontFamily: 'SF-Pro-Display',
          color: Colors.white,
        );
    final accentColor = Theme.of(context).accentColor;
    final currentLocale =
        BlocProvider.of<LocaleBloc>(context).locale$.value.languageCode;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 32),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.shade200,
                    offset: Offset(4, 4),
                    blurRadius: 8,
                  )
                ],
              ),
              width: 96,
              height: 96,
              child: profile.avatar == null || profile.avatar.isEmpty
                  ? CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      radius: 48,
                      child: Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  : CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(profile.avatar),
                      backgroundColor: Colors.white.withOpacity(0.9),
                    ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            profile.fullName,
            style: display1Text30,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 8,
                    color: Colors.grey,
                  ),
                ]),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(S.of(context).user_information),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    S.of(context).email,
                    style: display1Text16,
                  ),
                  subtitle: Text(profile.email),
                  leading: Icon(
                    Icons.email,
                    color: accentColor,
                  ),
                ),
                if (profile.phone != null && profile.phone.isNotEmpty)
                  ListTile(
                    title: Text(
                      S.of(context).phone,
                      style: display1Text16,
                    ),
                    subtitle: Text(profile.phone),
                    leading: Icon(
                      Icons.phone,
                      color: accentColor,
                    ),
                  ),
                if (profile.address != null && profile.address.isNotEmpty)
                  ListTile(
                    title: Text(
                      S.of(context).address,
                      style: display1Text16,
                    ),
                    subtitle: Text(profile.address),
                    leading: Icon(
                      Icons.label,
                      color: accentColor,
                    ),
                  ),
                ListTile(
                  title: Text(
                    S.of(context).status,
                    style: display1Text16,
                  ),
                  subtitle: Text(profile.isActive
                      ? S.of(context).active
                      : S.of(context).inactive),
                  leading: Icon(
                    Icons.done,
                    color: profile.isActive
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                ),
                if (profile.createdAt != null)
                  ListTile(
                    title: Text(
                      S.of(context).joined_date,
                      style: display1Text16,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd(currentLocale).format(
                        profile.createdAt,
                      ),
                    ),
                    leading: Icon(
                      Icons.calendar_view_day,
                      color: accentColor,
                    ),
                  ),
                if (isCurrentUser && profile.updatedAt != null)
                  ListTile(
                    title: Text(
                      S.of(context).last_updated,
                      style: display1Text16,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd(currentLocale).add_Hms().format(
                            profile.updatedAt,
                          ),
                    ),
                    leading: Icon(
                      Icons.edit,
                      color: accentColor,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.indigo.shade400,
                    Colors.purple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 8,
                    color: Colors.grey.shade300,
                  ),
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              S.of(context).posted_rooms_,
              style: display1Text16.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class _PostedRoomItem extends StatelessWidget {
  final UserProfileRoomItem item;

  const _PostedRoomItem({
    Key key,
    @required this.item,
  })  : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final subTitle14 =
        Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14);
    final subTitle12 = subTitle14.copyWith(fontSize: 12);
    const factor = 2;
    const factorContent = 1.7;
    final currentLocale =
        BlocProvider.of<LocaleBloc>(context).locale$.value.languageCode;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/room_detail',
          arguments: item.id,
        );
      },
      child: Container(
        constraints: BoxConstraints.expand(height: 96.0 * factor),
        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints.expand(
                  height: 96 * factorContent,
                ),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 64.0 * factor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: Hero(
                  tag: item.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: FadeInImage.assetNetwork(
                      image: item.image ?? '',
                      width: 64.0 * factor,
                      height: 96.0 * factor,
                      fit: BoxFit.cover,
                      placeholder: 'assets/images/home_appbar_image.jpg',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height);

    final firstEndPoint = Offset(
      size.width * 0.5,
      size.height - 30.0,
    );
    final firstControlPoint = Offset(
      size.width * 0.25,
      size.height - 50.0,
    );
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondEndPoint = Offset(
      size.width,
      size.height - 80.0,
    );
    final secondControlPoint = Offset(
      size.width * 0.75,
      size.height - 10,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
