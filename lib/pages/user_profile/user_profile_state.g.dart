// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserProfileState extends UserProfileState {
  @override
  final UserProfile profile;

  factory _$UserProfileState(
          [void Function(UserProfileStateBuilder) updates]) =>
      (new UserProfileStateBuilder()..update(updates)).build();

  _$UserProfileState._({this.profile}) : super._();

  @override
  UserProfileState rebuild(void Function(UserProfileStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileStateBuilder toBuilder() =>
      new UserProfileStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfileState && profile == other.profile;
  }

  @override
  int get hashCode {
    return $jf($jc(0, profile.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserProfileState')
          ..add('profile', profile))
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

  UserProfileStateBuilder();

  UserProfileStateBuilder get _$this {
    if (_$v != null) {
      _profile = _$v.profile?.toBuilder();
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
      _$result = _$v ?? new _$UserProfileState._(profile: _profile?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'profile';
        _profile?.build();
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
      {this.avatar,
      this.fullName,
      this.email,
      this.phone,
      this.address,
      this.isActive,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (fullName == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'fullName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'email');
    }
    if (isActive == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'isActive');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('UserProfile', 'updatedAt');
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
                        $jc($jc($jc(0, avatar.hashCode), fullName.hashCode),
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
