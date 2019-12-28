import 'dart:async';
import 'dart:io';

import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/data/user/firebase_user_repository.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_state.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

// ignore_for_file: close_sinks

class UpdateUserInfoBloc implements BaseBloc {
  ///
  /// Output [Stream]s
  ///
  final Stream<FullNameError> fullNameError$;
  final Stream<PhoneNumberError> phoneNumberError$;
  final Stream<AddressError> addressError$;
  final Stream<UpdateUserInfoMessage> message$;
  final ValueStream<bool> isLoading$;
  final ValueStream<File> avatar$;

  ///
  /// Input [Function]s
  ///
  final void Function() submitChanges;
  final void Function(String) fullNameChanged;
  final void Function(String) addressChanged;
  final void Function(String) phoneNumberChanged;
  final void Function(File) avatarChanged;

  ///
  /// Clean up resources
  ///
  final void Function() _dispose;

  UpdateUserInfoBloc._(
    this._dispose, {
    @required this.fullNameError$,
    @required this.message$,
    @required this.isLoading$,
    @required this.submitChanges,
    @required this.fullNameChanged,
    @required this.avatar$,
    @required this.avatarChanged,
    @required this.phoneNumberError$,
    @required this.addressError$,
    @required this.addressChanged,
    @required this.phoneNumberChanged,
  });

  @override
  void dispose() => _dispose();

  factory UpdateUserInfoBloc({
    @required String uid,
    @required FirebaseUserRepository userRepo,
    @required AuthBloc authBloc,
  }) {
    print('[UPDATE_USER_INFO_BLOC] { init }');

    ///
    /// Asserts
    ///
    assert(uid != null, 'uid cannot be null');
    assert(userRepo != null, 'userRepo cannot be null');
    assert(authBloc != null, 'authBloc cannot be null');
    final currentUser = authBloc.currentUser();
    assert(currentUser?.uid == uid, 'User is not logged in or invalid user id');

    ///
    /// Controllers
    ///
    final submitController = PublishSubject<void>();
    final fullNameController = BehaviorSubject.seeded(currentUser.fullName);
    final addressController = BehaviorSubject.seeded(currentUser.address);
    final phoneNumberController = BehaviorSubject.seeded(currentUser.phone);
    final isLoadingController = BehaviorSubject.seeded(false);
    final avatarSubject = PublishSubject<File>();

    ///
    /// Errors streams
    ///
    final fullNameError$ = fullNameController.map((name) {
      if (name == null || name.length < 3) {
        return const FullNameError.lengthOfFullNameLessThan3Chars();
      }
      return null;
    }).share();

    final addressError$ = addressController.map((address) {
      if (address == null || address.isEmpty) {
        return const AddressError.emptyAddress();
      }
      return null;
    }).share();

    final phoneNumberError$ = phoneNumberController.map((phoneNumber) {
      if (phoneNumber == null || phoneNumber.isEmpty) {
        return const PhoneNumberError.invalidPhoneNumber();
      }
      const regex = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
      if (!RegExp(regex, caseSensitive: false).hasMatch(phoneNumber)) {
        return const PhoneNumberError.invalidPhoneNumber();
      }
      return null;
    }).share();

    ///
    /// Combine error streams with submit stream
    ///

    final isValid$ = Rx.combineLatest(
      [
        fullNameError$,
        addressError$,
        phoneNumberError$,
      ],
      (allErrors) => allErrors.every((e) => e == null),
    );

    final validSubmit$ = submitController
        .throttleTime(const Duration(milliseconds: 600))
        .withLatestFrom(
          isValid$,
          (_, isValid) => isValid,
        )
        .share();

    ///
    /// Transform submit stream
    ///

    final avatar$ = avatarSubject.publishValueDistinct(
      equals: (prev, next) => path.equals(prev?.path ?? '', next?.path ?? ''),
    );

    final message$ = Rx.merge(
      [
        validSubmit$
            .where((isValid) => !isValid)
            .map((_) => const UpdateUserInfoMessage.invalidInfomation()),
        validSubmit$.where((isValid) => isValid).exhaustMap(
              (_) => _performUpdateInfo(
                address: addressController.value,
                avatar: avatar$.value,
                fullName: fullNameController.value,
                isLoadingSink: isLoadingController,
                phoneNumber: phoneNumberController.value,
                userRepo: userRepo,
              ),
            ),
      ],
    ).publish();

    ///
    /// Subscriptions & controllers
    ///
    final subscriptions = <StreamSubscription>[
      avatar$.listen((file) => print('[UPDATE_USER_INFO_BLOC] file=$file')),
      message$.listen(
          (message) => print('[UPDATE_USER_INFO_BLOC] message=$message')),

      ///
      message$.connect(),
      avatar$.connect(),
    ];
    final controllers = <StreamController>{
      submitController,
      isLoadingController,
      avatarSubject,
      fullNameController,
      addressController,
      phoneNumberController,
    };

    return UpdateUserInfoBloc._(
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
        print('[UPDATE_USER_INFO_BLOC] { disposed }');
      },

      ///
      /// Inputs
      ///
      avatarChanged: avatarSubject.add,
      fullNameChanged: fullNameController.add,
      submitChanges: () => submitController.add(null),
      addressChanged: addressController.add,
      phoneNumberChanged: phoneNumberController.add,

      ///
      /// Outputs
      ///
      fullNameError$: fullNameError$,
      isLoading$: isLoadingController,
      message$: message$,
      avatar$: avatar$,
      addressError$: addressError$,
      phoneNumberError$: phoneNumberError$,
    );
  }

  static Stream<UpdateUserInfoMessage> _performUpdateInfo({
    @required FirebaseUserRepository userRepo,
    @required String fullName,
    @required String address,
    @required String phoneNumber,
    @required File avatar,
    @required Sink<bool> isLoadingSink,
  }) async* {
    try {
      print(
          '[UPDATE_USER_INFO_BLOC] _performUpdateInfo fullName=$fullName, address=$address,'
          ' phoneNumber=$phoneNumber, avatar=$avatar');
      isLoadingSink.add(true);
      await userRepo.updateUserInfo(
        fullName: fullName,
        avatar: avatar,
        address: address,
        phoneNumber: phoneNumber,
      );
      yield const UpdateUserInfoMessage.updateSuccess();
    } catch (e) {
      yield UpdateUserInfoMessage.updateFailure(getError(e));
    } finally {
      isLoadingSink.add(false);
    }
  }

  static UpdateUserInfoError getError(error) {
    if (error is PlatformException) {
      switch (error.code) {
        case 'ERROR_USER_DISABLED':
          return const UpdateUserInfoError.userDisabled();
        case 'ERROR_USER_NOT_FOUND':
          return const UpdateUserInfoError.userNotFound();
        case 'ERROR_NETWORK_REQUEST_FAILED':
          return const UpdateUserInfoError.networkError();
        case 'ERROR_TOO_MANY_REQUESTS':
          return const UpdateUserInfoError.tooManyRequestsError();
        case 'ERROR_OPERATION_NOT_ALLOWED':
          return const UpdateUserInfoError.operationNotAllowedError();
      }
    }
    return UpdateUserInfoError.unknown(error);
  }
}
