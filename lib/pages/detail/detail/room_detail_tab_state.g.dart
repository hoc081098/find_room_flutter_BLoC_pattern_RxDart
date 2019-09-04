// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_detail_tab_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const Utility _$wifi = const Utility._('wifi');
const Utility _$private_wc = const Utility._('private_wc');
const Utility _$bed = const Utility._('bed');
const Utility _$easy = const Utility._('easy');
const Utility _$parking = const Utility._('parking');
const Utility _$without_owner = const Utility._('without_owner');

Utility _$valueOf(String name) {
  switch (name) {
    case 'wifi':
      return _$wifi;
    case 'private_wc':
      return _$private_wc;
    case 'bed':
      return _$bed;
    case 'easy':
      return _$easy;
    case 'parking':
      return _$parking;
    case 'without_owner':
      return _$without_owner;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<Utility> _$values = new BuiltSet<Utility>(const <Utility>[
  _$wifi,
  _$private_wc,
  _$bed,
  _$easy,
  _$parking,
  _$without_owner,
]);

class _$RoomDetailTabState extends RoomDetailTabState {
  @override
  final RoomDetailState room;
  @override
  final UserState user;

  factory _$RoomDetailTabState(
          [void Function(RoomDetailTabStateBuilder) updates]) =>
      (new RoomDetailTabStateBuilder()..update(updates)).build();

  _$RoomDetailTabState._({this.room, this.user}) : super._();

  @override
  RoomDetailTabState rebuild(
          void Function(RoomDetailTabStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoomDetailTabStateBuilder toBuilder() =>
      new RoomDetailTabStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoomDetailTabState &&
        room == other.room &&
        user == other.user;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, room.hashCode), user.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RoomDetailTabState')
          ..add('room', room)
          ..add('user', user))
        .toString();
  }
}

class RoomDetailTabStateBuilder
    implements Builder<RoomDetailTabState, RoomDetailTabStateBuilder> {
  _$RoomDetailTabState _$v;

  RoomDetailStateBuilder _room;
  RoomDetailStateBuilder get room =>
      _$this._room ??= new RoomDetailStateBuilder();
  set room(RoomDetailStateBuilder room) => _$this._room = room;

  UserStateBuilder _user;
  UserStateBuilder get user => _$this._user ??= new UserStateBuilder();
  set user(UserStateBuilder user) => _$this._user = user;

  RoomDetailTabStateBuilder();

  RoomDetailTabStateBuilder get _$this {
    if (_$v != null) {
      _room = _$v.room?.toBuilder();
      _user = _$v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoomDetailTabState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RoomDetailTabState;
  }

  @override
  void update(void Function(RoomDetailTabStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RoomDetailTabState build() {
    _$RoomDetailTabState _$result;
    try {
      _$result = _$v ??
          new _$RoomDetailTabState._(
              room: _room?.build(), user: _user?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'room';
        _room?.build();
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RoomDetailTabState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$RoomDetailState extends RoomDetailState {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String price;
  @override
  final String countView;
  @override
  final String size;
  @override
  final String address;
  @override
  final BuiltList<String> images;
  @override
  final String phone;
  @override
  final bool available;
  @override
  final BuiltList<Utility> utilities;
  @override
  final String categoryName;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$RoomDetailState([void Function(RoomDetailStateBuilder) updates]) =>
      (new RoomDetailStateBuilder()..update(updates)).build();

  _$RoomDetailState._(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.countView,
      this.size,
      this.address,
      this.images,
      this.phone,
      this.available,
      this.utilities,
      this.categoryName,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'title');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'description');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'price');
    }
    if (countView == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'countView');
    }
    if (size == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'size');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'address');
    }
    if (images == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'images');
    }
    if (phone == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'phone');
    }
    if (available == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'available');
    }
    if (utilities == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'utilities');
    }
    if (categoryName == null) {
      throw new BuiltValueNullFieldError('RoomDetailState', 'categoryName');
    }
  }

  @override
  RoomDetailState rebuild(void Function(RoomDetailStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoomDetailStateBuilder toBuilder() =>
      new RoomDetailStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoomDetailState &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        price == other.price &&
        countView == other.countView &&
        size == other.size &&
        address == other.address &&
        images == other.images &&
        phone == other.phone &&
        available == other.available &&
        utilities == other.utilities &&
        categoryName == other.categoryName &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc($jc(0, id.hashCode),
                                                        title.hashCode),
                                                    description.hashCode),
                                                price.hashCode),
                                            countView.hashCode),
                                        size.hashCode),
                                    address.hashCode),
                                images.hashCode),
                            phone.hashCode),
                        available.hashCode),
                    utilities.hashCode),
                categoryName.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RoomDetailState')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('price', price)
          ..add('countView', countView)
          ..add('size', size)
          ..add('address', address)
          ..add('images', images)
          ..add('phone', phone)
          ..add('available', available)
          ..add('utilities', utilities)
          ..add('categoryName', categoryName)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class RoomDetailStateBuilder
    implements Builder<RoomDetailState, RoomDetailStateBuilder> {
  _$RoomDetailState _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _price;
  String get price => _$this._price;
  set price(String price) => _$this._price = price;

  String _countView;
  String get countView => _$this._countView;
  set countView(String countView) => _$this._countView = countView;

  String _size;
  String get size => _$this._size;
  set size(String size) => _$this._size = size;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  ListBuilder<String> _images;
  ListBuilder<String> get images =>
      _$this._images ??= new ListBuilder<String>();
  set images(ListBuilder<String> images) => _$this._images = images;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  bool _available;
  bool get available => _$this._available;
  set available(bool available) => _$this._available = available;

  ListBuilder<Utility> _utilities;
  ListBuilder<Utility> get utilities =>
      _$this._utilities ??= new ListBuilder<Utility>();
  set utilities(ListBuilder<Utility> utilities) =>
      _$this._utilities = utilities;

  String _categoryName;
  String get categoryName => _$this._categoryName;
  set categoryName(String categoryName) => _$this._categoryName = categoryName;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  RoomDetailStateBuilder();

  RoomDetailStateBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _description = _$v.description;
      _price = _$v.price;
      _countView = _$v.countView;
      _size = _$v.size;
      _address = _$v.address;
      _images = _$v.images?.toBuilder();
      _phone = _$v.phone;
      _available = _$v.available;
      _utilities = _$v.utilities?.toBuilder();
      _categoryName = _$v.categoryName;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoomDetailState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RoomDetailState;
  }

  @override
  void update(void Function(RoomDetailStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RoomDetailState build() {
    _$RoomDetailState _$result;
    try {
      _$result = _$v ??
          new _$RoomDetailState._(
              id: id,
              title: title,
              description: description,
              price: price,
              countView: countView,
              size: size,
              address: address,
              images: images.build(),
              phone: phone,
              available: available,
              utilities: utilities.build(),
              categoryName: categoryName,
              createdAt: createdAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'images';
        images.build();

        _$failedField = 'utilities';
        utilities.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'RoomDetailState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$UserState extends UserState {
  @override
  final String avatar;
  @override
  final String id;
  @override
  final String fullName;
  @override
  final String phoneNumber;
  @override
  final String email;

  factory _$UserState([void Function(UserStateBuilder) updates]) =>
      (new UserStateBuilder()..update(updates)).build();

  _$UserState._(
      {this.avatar, this.id, this.fullName, this.phoneNumber, this.email})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('UserState', 'id');
    }
    if (fullName == null) {
      throw new BuiltValueNullFieldError('UserState', 'fullName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('UserState', 'email');
    }
  }

  @override
  UserState rebuild(void Function(UserStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserStateBuilder toBuilder() => new UserStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserState &&
        avatar == other.avatar &&
        id == other.id &&
        fullName == other.fullName &&
        phoneNumber == other.phoneNumber &&
        email == other.email;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, avatar.hashCode), id.hashCode), fullName.hashCode),
            phoneNumber.hashCode),
        email.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserState')
          ..add('avatar', avatar)
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('phoneNumber', phoneNumber)
          ..add('email', email))
        .toString();
  }
}

class UserStateBuilder implements Builder<UserState, UserStateBuilder> {
  _$UserState _$v;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  UserStateBuilder();

  UserStateBuilder get _$this {
    if (_$v != null) {
      _avatar = _$v.avatar;
      _id = _$v.id;
      _fullName = _$v.fullName;
      _phoneNumber = _$v.phoneNumber;
      _email = _$v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserState;
  }

  @override
  void update(void Function(UserStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserState build() {
    final _$result = _$v ??
        new _$UserState._(
            avatar: avatar,
            id: id,
            fullName: fullName,
            phoneNumber: phoneNumber,
            email: email);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
