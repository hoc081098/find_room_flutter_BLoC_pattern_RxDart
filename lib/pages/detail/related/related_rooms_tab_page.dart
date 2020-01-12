import 'dart:io';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_bloc.dart';
import 'package:find_room/pages/detail/related/related_rooms_tab_state.dart';
import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 4),
            color: Colors.grey.shade600,
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(2, 2),
                  color: Colors.grey.shade500,
                  spreadRadius: 1)
            ]),
            child: ClipOval(
              child: Image.network(
                '',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  '${item.id} ${item.id}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  item.id,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
