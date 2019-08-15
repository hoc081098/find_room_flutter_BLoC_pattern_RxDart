// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'see_all_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeeAllRoomItem extends SeeAllRoomItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String price;
  @override
  final String address;
  @override
  final String districtName;
  @override
  final String image;
  @override
  final DateTime createdTime;
  @override
  final DateTime updatedTime;

  factory _$SeeAllRoomItem([void Function(SeeAllRoomItemBuilder) updates]) =>
      (new SeeAllRoomItemBuilder()..update(updates)).build();

  _$SeeAllRoomItem._(
      {this.id,
      this.title,
      this.price,
      this.address,
      this.districtName,
      this.image,
      this.createdTime,
      this.updatedTime})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('SeeAllRoomItem', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('SeeAllRoomItem', 'title');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('SeeAllRoomItem', 'price');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('SeeAllRoomItem', 'address');
    }
    if (districtName == null) {
      throw new BuiltValueNullFieldError('SeeAllRoomItem', 'districtName');
    }
  }

  @override
  SeeAllRoomItem rebuild(void Function(SeeAllRoomItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeeAllRoomItemBuilder toBuilder() =>
      new SeeAllRoomItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeeAllRoomItem &&
        id == other.id &&
        title == other.title &&
        price == other.price &&
        address == other.address &&
        districtName == other.districtName &&
        image == other.image &&
        createdTime == other.createdTime &&
        updatedTime == other.updatedTime;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), title.hashCode),
                            price.hashCode),
                        address.hashCode),
                    districtName.hashCode),
                image.hashCode),
            createdTime.hashCode),
        updatedTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SeeAllRoomItem')
          ..add('id', id)
          ..add('title', title)
          ..add('price', price)
          ..add('address', address)
          ..add('districtName', districtName)
          ..add('image', image)
          ..add('createdTime', createdTime)
          ..add('updatedTime', updatedTime))
        .toString();
  }
}

class SeeAllRoomItemBuilder
    implements Builder<SeeAllRoomItem, SeeAllRoomItemBuilder> {
  _$SeeAllRoomItem _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _price;
  String get price => _$this._price;
  set price(String price) => _$this._price = price;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  String _districtName;
  String get districtName => _$this._districtName;
  set districtName(String districtName) => _$this._districtName = districtName;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  DateTime _createdTime;
  DateTime get createdTime => _$this._createdTime;
  set createdTime(DateTime createdTime) => _$this._createdTime = createdTime;

  DateTime _updatedTime;
  DateTime get updatedTime => _$this._updatedTime;
  set updatedTime(DateTime updatedTime) => _$this._updatedTime = updatedTime;

  SeeAllRoomItemBuilder();

  SeeAllRoomItemBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _price = _$v.price;
      _address = _$v.address;
      _districtName = _$v.districtName;
      _image = _$v.image;
      _createdTime = _$v.createdTime;
      _updatedTime = _$v.updatedTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeeAllRoomItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SeeAllRoomItem;
  }

  @override
  void update(void Function(SeeAllRoomItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SeeAllRoomItem build() {
    final _$result = _$v ??
        new _$SeeAllRoomItem._(
            id: id,
            title: title,
            price: price,
            address: address,
            districtName: districtName,
            image: image,
            createdTime: createdTime,
            updatedTime: updatedTime);
    replace(_$result);
    return _$result;
  }
}

class _$SeeAllListState extends SeeAllListState {
  @override
  final BuiltList<SeeAllRoomItem> rooms;
  @override
  final bool isLoading;
  @override
  final bool getAll;
  @override
  final SeeAllError error;
  @override
  final DocumentSnapshot lastDocumentSnapshot;

  factory _$SeeAllListState([void Function(SeeAllListStateBuilder) updates]) =>
      (new SeeAllListStateBuilder()..update(updates)).build();

  _$SeeAllListState._(
      {this.rooms,
      this.isLoading,
      this.getAll,
      this.error,
      this.lastDocumentSnapshot})
      : super._() {
    if (rooms == null) {
      throw new BuiltValueNullFieldError('SeeAllListState', 'rooms');
    }
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('SeeAllListState', 'isLoading');
    }
    if (getAll == null) {
      throw new BuiltValueNullFieldError('SeeAllListState', 'getAll');
    }
  }

  @override
  SeeAllListState rebuild(void Function(SeeAllListStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeeAllListStateBuilder toBuilder() =>
      new SeeAllListStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeeAllListState &&
        rooms == other.rooms &&
        isLoading == other.isLoading &&
        getAll == other.getAll &&
        error == other.error &&
        lastDocumentSnapshot == other.lastDocumentSnapshot;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, rooms.hashCode), isLoading.hashCode),
                getAll.hashCode),
            error.hashCode),
        lastDocumentSnapshot.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SeeAllListState')
          ..add('rooms', rooms)
          ..add('isLoading', isLoading)
          ..add('getAll', getAll)
          ..add('error', error)
          ..add('lastDocumentSnapshot', lastDocumentSnapshot))
        .toString();
  }
}

class SeeAllListStateBuilder
    implements Builder<SeeAllListState, SeeAllListStateBuilder> {
  _$SeeAllListState _$v;

  ListBuilder<SeeAllRoomItem> _rooms;
  ListBuilder<SeeAllRoomItem> get rooms =>
      _$this._rooms ??= new ListBuilder<SeeAllRoomItem>();
  set rooms(ListBuilder<SeeAllRoomItem> rooms) => _$this._rooms = rooms;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  bool _getAll;
  bool get getAll => _$this._getAll;
  set getAll(bool getAll) => _$this._getAll = getAll;

  SeeAllError _error;
  SeeAllError get error => _$this._error;
  set error(SeeAllError error) => _$this._error = error;

  DocumentSnapshot _lastDocumentSnapshot;
  DocumentSnapshot get lastDocumentSnapshot => _$this._lastDocumentSnapshot;
  set lastDocumentSnapshot(DocumentSnapshot lastDocumentSnapshot) =>
      _$this._lastDocumentSnapshot = lastDocumentSnapshot;

  SeeAllListStateBuilder();

  SeeAllListStateBuilder get _$this {
    if (_$v != null) {
      _rooms = _$v.rooms?.toBuilder();
      _isLoading = _$v.isLoading;
      _getAll = _$v.getAll;
      _error = _$v.error;
      _lastDocumentSnapshot = _$v.lastDocumentSnapshot;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeeAllListState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SeeAllListState;
  }

  @override
  void update(void Function(SeeAllListStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SeeAllListState build() {
    _$SeeAllListState _$result;
    try {
      _$result = _$v ??
          new _$SeeAllListState._(
              rooms: rooms.build(),
              isLoading: isLoading,
              getAll: getAll,
              error: error,
              lastDocumentSnapshot: lastDocumentSnapshot);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'rooms';
        rooms.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SeeAllListState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
