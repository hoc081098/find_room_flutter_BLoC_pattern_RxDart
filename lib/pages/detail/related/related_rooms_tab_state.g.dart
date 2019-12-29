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

  factory _$RoomItem([void Function(RoomItemBuilder) updates]) =>
      (new RoomItemBuilder()..update(updates)).build();

  _$RoomItem._({this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('RoomItem', 'id');
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
    return other is RoomItem && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc(0, id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RoomItem')..add('id', id)).toString();
  }
}

class RoomItemBuilder implements Builder<RoomItem, RoomItemBuilder> {
  _$RoomItem _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  RoomItemBuilder();

  RoomItemBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
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
    final _$result = _$v ?? new _$RoomItem._(id: id);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
