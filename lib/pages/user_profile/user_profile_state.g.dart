// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserProfileState extends UserProfileState {
  @override
  final UserProfile profile;
  @override
  final bool isCurrentUser;
  @override
  final BuiltList<UserProfileRoomItem> postedRooms;

  factory _$UserProfileState(
          [void Function(UserProfileStateBuilder) updates]) =>
      (new UserProfileStateBuilder()..update(updates)).build();

  _$UserProfileState._({this.profile, this.isCurrentUser, this.postedRooms})
      : super._() {
    if (isCurrentUser == null) {
      throw new BuiltValueNullFieldError('UserProfileState', 'isCurrentUser');
    }
    if (postedRooms == null) {
      throw new BuiltValueNullFieldError('UserProfileState', 'postedRooms');
    }
  }

  @override
  UserProfileState rebuild(void Function(UserProfileStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileStateBuilder toBuilder() =>
      new UserProfileStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfileState &&
        profile == other.profile &&
        isCurrentUser == other.isCurrentUser &&
        postedRooms == other.postedRooms;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, profile.hashCode), isCurrentUser.hashCode),
        postedRooms.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserProfileState')
          ..add('profile', profile)
          ..add('isCurrentUser', isCurrentUser)
          ..add('postedRooms', postedRooms))
        .toString();
  }
}

class UserProfileStateBuilder
    implements Builder<UserProfileState, UserProfileStateBuilder> {
  _$UserProfileState _$v;

  UserProfileBuilder _profile;
  UserProfileBuilder get profile =>
      _$this._profile ??= new UserProfileBuilder();
  set profile(UserProfileBuilder profile) => _$this._profile = profile;

  bool _isCurrentUser;
  bool get isCurrentUser => _$this._isCurrentUser;
  set isCurrentUser(bool isCurrentUser) =>
      _$this._isCurrentUser = isCurrentUser;

  ListBuilder<UserProfileRoomItem> _postedRooms;
  ListBuilder<UserProfileRoomItem> get postedRooms =>
      _$this._postedRooms ??= new ListBuilder<UserProfileRoomItem>();
  set postedRooms(ListBuilder<UserProfileRoomItem> postedRooms) =>
      _$this._postedRooms = postedRooms;

  UserProfileStateBuilder();

  UserProfileStateBuilder get _$this {
    if (_$v != null) {
      _profile = _$v.profile?.toBuilder();
      _isCurrentUser = _$v.isCurrentUser;
      _postedRooms = _$v.postedRooms?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfileState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserProfileState;
  }

  @override
  void update(void Function(UserProfileStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserProfileState build() {
    _$UserProfileState _$result;
    try {
      _$result = _$v ??
          new _$UserProfileState._(
              profile: _profile?.build(),
              isCurrentUser: isCurrentUser,
              postedRooms: postedRooms.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'profile';
        _profile?.build();

        _$failedField = 'postedRooms';
        postedRooms.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UserProfileState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$UserProfile extends UserProfile {
  @override
  final String uid;
  @override
  final String avatar;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String address;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$UserProfile([void Function(UserProfileBuilder) updates]) =>
      (new UserProfileBuilder()..update(updates)).build();

  _$UserProfile._(
      {this.uid,
      this.avatar,
      this.fullName,
      this.email,
      this.phone,
      this.address,
      this.isActive,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (uid == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'uid');
    }
    if (fullName == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'fullName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'email');
    }
    if (isActive == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'isActive');
    }
  }

  @override
  UserProfile rebuild(void Function(UserProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileBuilder toBuilder() => new UserProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        uid == other.uid &&
        avatar == other.avatar &&
        fullName == other.fullName &&
        email == other.email &&
        phone == other.phone &&
        address == other.address &&
        isActive == other.isActive &&
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
                            $jc($jc($jc(0, uid.hashCode), avatar.hashCode),
                                fullName.hashCode),
                            email.hashCode),
                        phone.hashCode),
                    address.hashCode),
                isActive.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserProfile')
          ..add('uid', uid)
          ..add('avatar', avatar)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('address', address)
          ..add('isActive', isActive)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class UserProfileBuilder implements Builder<UserProfile, UserProfileBuilder> {
  _$UserProfile _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  UserProfileBuilder();

  UserProfileBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _avatar = _$v.avatar;
      _fullName = _$v.fullName;
      _email = _$v.email;
      _phone = _$v.phone;
      _address = _$v.address;
      _isActive = _$v.isActive;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfile other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserProfile;
  }

  @override
  void update(void Function(UserProfileBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserProfile build() {
    final _$result = _$v ??
        new _$UserProfile._(
            uid: uid,
            avatar: avatar,
            fullName: fullName,
            email: email,
            phone: phone,
            address: address,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

class _$UserProfileRoomItem extends UserProfileRoomItem {
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

  factory _$UserProfileRoomItem(
          [void Function(UserProfileRoomItemBuilder) updates]) =>
      (new UserProfileRoomItemBuilder()..update(updates)).build();

  _$UserProfileRoomItem._(
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
      throw new BuiltValueNullFieldError('UserProfileRoomItem', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('UserProfileRoomItem', 'title');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('UserProfileRoomItem', 'price');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('UserProfileRoomItem', 'address');
    }
    if (districtName == null) {
      throw new BuiltValueNullFieldError('UserProfileRoomItem', 'districtName');
    }
  }

  @override
  UserProfileRoomItem rebuild(
          void Function(UserProfileRoomItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileRoomItemBuilder toBuilder() =>
      new UserProfileRoomItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfileRoomItem &&
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
    return (newBuiltValueToStringHelper('UserProfileRoomItem')
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

class UserProfileRoomItemBuilder
    implements Builder<UserProfileRoomItem, UserProfileRoomItemBuilder> {
  _$UserProfileRoomItem _$v;

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

  UserProfileRoomItemBuilder();

  UserProfileRoomItemBuilder get _$this {
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
  void replace(UserProfileRoomItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserProfileRoomItem;
  }

  @override
  void update(void Function(UserProfileRoomItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserProfileRoomItem build() {
    final _$result = _$v ??
        new _$UserProfileRoomItem._(
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
