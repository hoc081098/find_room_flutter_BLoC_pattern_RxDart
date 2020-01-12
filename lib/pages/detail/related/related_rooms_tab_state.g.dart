// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_rooms_tab_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RelatedRoomsState extends RelatedRoomsState {
  @override
  final bool isLoading;
  @override
  final BuiltList<RoomItem> items;
  @override
  final Object error;

  factory _$RelatedRoomsState(
          [void Function(RelatedRoomsStateBuilder) updates]) =>
      (new RelatedRoomsStateBuilder()..update(updates)).build();

  _$RelatedRoomsState._({this.isLoading, this.items, this.error}) : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('RelatedRoomsState', 'isLoading');
    }
    if (items == null) {
      throw new BuiltValueNullFieldError('RelatedRoomsState', 'items');
    }
  }

  @override
  RelatedRoomsState rebuild(void Function(RelatedRoomsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelatedRoomsStateBuilder toBuilder() =>
      new RelatedRoomsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelatedRoomsState &&
        isLoading == other.isLoading &&
        items == other.items &&
        error == other.error;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, isLoading.hashCode), items.hashCode), error.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelatedRoomsState')
          ..add('isLoading', isLoading)
          ..add('items', items)
          ..add('error', error))
        .toString();
  }
}

class RelatedRoomsStateBuilder
    implements Builder<RelatedRoomsState, RelatedRoomsStateBuilder> {
  _$RelatedRoomsState _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  ListBuilder<RoomItem> _items;
  ListBuilder<RoomItem> get items =>
      _$this._items ??= new ListBuilder<RoomItem>();
  set items(ListBuilder<RoomItem> items) => _$this._items = items;

  Object _error;
  Object get error => _$this._error;
  set error(Object error) => _$this._error = error;

  RelatedRoomsStateBuilder();

  RelatedRoomsStateBuilder get _$this {
    if (_$v != null) {
      _isLoading = _$v.isLoading;
      _items = _$v.items?.toBuilder();
      _error = _$v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelatedRoomsState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RelatedRoomsState;
  }

  @override
  void update(void Function(RelatedRoomsStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelatedRoomsState build() {
    _$RelatedRoomsState _$result;
    try {
      _$result = _$v ??
          new _$RelatedRoomsState._(
              isLoading: isLoading, items: items.build(), error: error);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RelatedRoomsState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$RoomItem extends RoomItem {
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
  @override
  final String imageUrl;

  factory _$RoomItem([void Function(RoomItemBuilder) updates]) =>
      (new RoomItemBuilder()..update(updates)).build();

  _$RoomItem._(
      {this.id,
      this.title,
      this.price,
      this.address,
      this.districtName,
      this.image,
      this.createdTime,
      this.updatedTime,
      this.imageUrl})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('RoomItem', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('RoomItem', 'title');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('RoomItem', 'price');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('RoomItem', 'address');
    }
    if (districtName == null) {
      throw new BuiltValueNullFieldError('RoomItem', 'districtName');
    }
  }

  @override
  RoomItem rebuild(void Function(RoomItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoomItemBuilder toBuilder() => new RoomItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoomItem &&
        id == other.id &&
        title == other.title &&
        price == other.price &&
        address == other.address &&
        districtName == other.districtName &&
        image == other.image &&
        createdTime == other.createdTime &&
        updatedTime == other.updatedTime &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
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
            updatedTime.hashCode),
        imageUrl.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RoomItem')
          ..add('id', id)
          ..add('title', title)
          ..add('price', price)
          ..add('address', address)
          ..add('districtName', districtName)
          ..add('image', image)
          ..add('createdTime', createdTime)
          ..add('updatedTime', updatedTime)
          ..add('imageUrl', imageUrl))
        .toString();
  }
}

class RoomItemBuilder implements Builder<RoomItem, RoomItemBuilder> {
  _$RoomItem _$v;

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

  String _imageUrl;
  String get imageUrl => _$this._imageUrl;
  set imageUrl(String imageUrl) => _$this._imageUrl = imageUrl;

  RoomItemBuilder();

  RoomItemBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _price = _$v.price;
      _address = _$v.address;
      _districtName = _$v.districtName;
      _image = _$v.image;
      _createdTime = _$v.createdTime;
      _updatedTime = _$v.updatedTime;
      _imageUrl = _$v.imageUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoomItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RoomItem;
  }

  @override
  void update(void Function(RoomItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RoomItem build() {
    final _$result = _$v ??
        new _$RoomItem._(
            id: id,
            title: title,
            price: price,
            address: address,
            districtName: districtName,
            image: image,
            createdTime: createdTime,
            updatedTime: updatedTime,
            imageUrl: imageUrl);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
