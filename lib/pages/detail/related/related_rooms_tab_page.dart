import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_bloc.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatedRoomsTabPage extends StatefulWidget {
  const RelatedRoomsTabPage({Key key}) : super(key: key);

  @override
  _RelatedRoomsTabPageState createState() => _RelatedRoomsTabPageState();
}

class _RelatedRoomsTabPageState extends State<RelatedRoomsTabPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(BlocProvider.of<RelatedRoomsTabBloc>(context));
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<RelatedRoomsTabBloc>(context);

    return Container(
      color: Colors.white,
      constraints: BoxConstraints.expand(),
      child: StreamBuilder<RelatedRoomsState>(
        stream: bloc.state$,
        initialData: bloc.state$.value,
        builder: (context, snapshot) {
          final child = () {
            final state = snapshot.data;
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.error != null) {
              return ErrorMessageWidget(
                error: state.error,
              );
            }

            if (state.items.isEmpty) {
              return Container(
                constraints: BoxConstraints.expand(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        size: 48,
                        color: Theme.of(context).accentColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Empty related rooms',
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: state.items.length,
                itemBuilder: (context, index) =>
                    ListItemWidget(item: state.items[index]),
              ),
              onRefresh: bloc.refresh,
            );
          }();

          return AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            child: child,
          );
        },
      ),
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    Key key,
    @required this.error,
  })  : assert(error != null),
        super(key: key);

  final error;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<RelatedRoomsTabBloc>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Error when getting related rooms',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 18),
            ),
            SizedBox(height: 16),
            RaisedButton(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24),
              child: Text('Retry get rooms'),
              onPressed: bloc.fetch,
            ),
          ],
        ),
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final RoomItem item;

  @override
  Widget build(BuildContext context) {
    final currentLocale =
        BlocProvider.of<LocaleBloc>(context).locale$.value.languageCode;
    final subTitle14 =
        Theme.of(context).textTheme.subtitle.copyWith(fontSize: 14);
    final subTitle12 = subTitle14.copyWith(fontSize: 12);

    final imageW = 64 * 1.5;
    final imageH = 96 * 1.5;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 4),
            color: Colors.grey.shade400,
          )
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/room_detail',
              arguments: item.id,
            );
          },
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl ?? '',
                  width: imageW,
                  height: imageH,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: imageW,
                    height: imageH,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Center(
                    child: Container(
                      width: imageW,
                      height: imageH,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.error_outline),
                          Text(
                            'Error',
                            style: subTitle12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
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
                      S.of(context).created_date(DateFormat.yMMMd(currentLocale)
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
            ],
          ),
        ),
      ),
    );
  }
}
