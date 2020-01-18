import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/categories/firestore_categories_repository.dart';
import 'package:find_room/models/category_entity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:built_collection/built_collection.dart';

class PostRoomCategoriesBloc implements BaseBloc {
  final LoaderBloc<BuiltList<CategoryEntity>> _loaderBloc;

  PostRoomCategoriesBloc(FirestoreCategoriesRepository categoriesRepository)
      : assert(categoriesRepository != null),
        _loaderBloc = LoaderBloc<BuiltList<CategoryEntity>>(
          loaderFunction: categoriesRepository.getAllCategories,
          enableLogger: false,
          initialContent: BuiltList.of([]),
        );

  ValueStream<LoaderState<BuiltList<CategoryEntity>>> get state$ =>
      _loaderBloc.state$;

  void fetch() => _loaderBloc.fetch();

  @override
  void dispose() => _loaderBloc.dispose();
}

class PostRoomBloc implements BaseBloc {
  final void Function(String) selectedCategoryIdChanged;

  final ValueStream<String> selectedCategoryId$;

  final void Function() _dispose;

  PostRoomBloc._(
    this._dispose, {
    this.selectedCategoryIdChanged,
    this.selectedCategoryId$,
  });

  factory PostRoomBloc() {
    final selectedCategoryIdS = PublishSubject<String>();
    final controllers = <StreamController>[selectedCategoryIdS];

    final selectedCategoryId$ =
        selectedCategoryIdS.publishValueSeededDistinct(seedValue: null);

    final subscriptions = <StreamSubscription>[
      selectedCategoryId$.connect(),
    ];

    return PostRoomBloc._(
      DisposeBag([...subscriptions, ...controllers]).dispose,
      selectedCategoryIdChanged: selectedCategoryIdS.add,
      selectedCategoryId$: selectedCategoryId$,
    );
  }

  @override
  void dispose() => _dispose();
}
