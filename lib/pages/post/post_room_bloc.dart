import 'dart:async';

import 'package:disposebag/disposebag.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/categories/firestore_categories_repository.dart';
import 'package:find_room/models/category_entity.dart';
import 'package:find_room/models/district_entity.dart';
import 'package:find_room/models/province_entity.dart';
import 'package:find_room/models/ward_entity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:meta/meta.dart';
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
  final void Function(ProvinceEntity) selectedProvinceChanged;
  final void Function(DistrictEntity) selectedDistrictChanged;
  final void Function(WardEntity) selectedWardChanged;

  final ValueStream<String> selectedCategoryId$;
  final ValueStream<ProvinceEntity> selectedProvince$;
  final ValueStream<DistrictEntity> selectedDistrict$;
  final ValueStream<WardEntity> selectedWard$;

  final void Function() _dispose;

  PostRoomBloc._(
    this._dispose, {
    @required this.selectedCategoryIdChanged,
    @required this.selectedCategoryId$,
    @required this.selectedProvinceChanged,
    @required this.selectedProvince$,
    @required this.selectedDistrictChanged,
    @required this.selectedDistrict$,
    @required this.selectedWardChanged,
    @required this.selectedWard$,
  });

  factory PostRoomBloc() {
    final selectedCategoryIdS = PublishSubject<String>();
    final selectedProvinceS = PublishSubject<ProvinceEntity>();
    final selectedDistrictS = PublishSubject<DistrictEntity>();
    final selectedWardS = PublishSubject<WardEntity>();
    final controllers = <StreamController>[
      selectedCategoryIdS,
      selectedProvinceS,
      selectedDistrictS,
      selectedWardS,
    ];

    final selectedCategoryId$ =
        selectedCategoryIdS.publishValueSeededDistinct(seedValue: null);

    final selectedProvince$ =
        selectedProvinceS.publishValueSeededDistinct(seedValue: null);

    final selectedDistrict$ =
        selectedDistrictS.publishValueSeededDistinct(seedValue: null);

    final selectedWard$ =
        selectedWardS.publishValueSeededDistinct(seedValue: null);

    final subscriptions = <StreamSubscription>[
      selectedCategoryId$.connect(),
      selectedProvince$.connect(),
      selectedDistrict$.connect(),
      selectedWard$.connect(),
    ];

    return PostRoomBloc._(
      DisposeBag([...subscriptions, ...controllers]).dispose,
      selectedCategoryIdChanged: selectedCategoryIdS.add,
      selectedCategoryId$: selectedCategoryId$,
      selectedProvinceChanged: selectedProvinceS.add,
      selectedProvince$: selectedProvince$,
      selectedDistrict$: selectedDistrict$,
      selectedDistrictChanged: selectedDistrictS.add,
      selectedWard$: selectedWard$,
      selectedWardChanged: selectedWardS.add,
    );
  }

  @override
  void dispose() => _dispose();
}
