import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RoomDetailBloc implements BaseBloc {
  final ValueObservable<int> selectedIndex$;

  final void Function(int) changeIndex;

  final void Function() _dispose;

  RoomDetailBloc._(
    this._dispose, {
    @required this.selectedIndex$,
    @required this.changeIndex,
  });

  @override
  void dispose() => _dispose();

  factory RoomDetailBloc() {
    final selectedIndexS = PublishSubject<int>();

    final selectedIndex$ =
        publishValueSeededDistinct(selectedIndexS, seedValue: 0);

    final subscriptions = [
      selectedIndex$.connect(),
    ];
    final controllers = [
      selectedIndexS,
    ];

    return RoomDetailBloc._(
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
      selectedIndex$: selectedIndex$,
      changeIndex: selectedIndexS.add,
    );
  }
}
