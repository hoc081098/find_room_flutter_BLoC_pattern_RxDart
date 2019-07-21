import 'dart:async';
import 'dart:ui';

import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_bloc.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_state.dart';
import 'package:find_room/pages/user_profile/user_profile_page.dart';
import 'package:find_room/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';

class UpdateUserInfoPage extends StatefulWidget {
  final UserBloc userBloc;

  const UpdateUserInfoPage({Key key, @required this.userBloc})
      : super(key: key);

  @override
  _UpdateUserInfoPageState createState() => _UpdateUserInfoPageState();
}

class _UpdateUserInfoPageState extends State<UpdateUserInfoPage> {
  StreamSubscription<UpdateUserInfoMessage> _subscription;

  TextEditingController _fullNameTextController;
  TextEditingController _phoneNumberTextController;
  TextEditingController _addressTextController;

  @override
  void initState() {
    super.initState();

    final currentUser = widget.userBloc.currentUser();
    assert(currentUser != null);

    _fullNameTextController = TextEditingController(text: currentUser.fullName)
      ..addListener(() {
        BlocProvider.of<UpdateUserInfoBloc>(context)
            .fullNameChanged(_fullNameTextController.text);
      });

    _phoneNumberTextController = TextEditingController(text: currentUser.phone)
      ..addListener(() {
        BlocProvider.of<UpdateUserInfoBloc>(context)
            .phoneNumberChanged(_phoneNumberTextController.text);
      });

    _addressTextController = TextEditingController(text: currentUser.address)
      ..addListener(() {
        BlocProvider.of<UpdateUserInfoBloc>(context)
            .addressChanged(_addressTextController.text);
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _subscription ??=
        BlocProvider.of<UpdateUserInfoBloc>(context).message$.listen((message) {
      message.fold(
        onInvalidInformation: () {},
        onUpdateFailure: (UpdateUserInfoError error) {
          error.fold(
            onNetworkError: () {},
            onOperationNotAllowedError: () {},
            onTooManyRequestsError: () {},
            onUnknown: () {},
            onUserDisable: () {},
            onUserNotFound: () {},
          );
        },
        onUpdateSuccess: () {},
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    [
      _fullNameTextController,
      _phoneNumberTextController,
      _addressTextController,
    ].forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = BlocProvider.of<UpdateUserInfoBloc>(context);
    final paddingTop = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            color: Colors.grey.shade100,
          ),
        ),
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 300.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.indigo.shade400,
                  Colors.purple,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: paddingTop,
          left: 8,
          right: 8,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(4, 4),
                    color: Colors.grey,
                    blurRadius: 10,
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StreamBuilder<FullNameError>(
                      stream: bloc.fullNameError$,
                      builder: (context, snapshot) {
                        final errorText = snapshot.data?.fold(
                          onLengthOfFullNameLessThan3Chars: () =>
                              s.full_name_at_least_6_characters,
                        );

                        return TextField(
                          controller: _fullNameTextController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 8.0),
                              child: Icon(Icons.person),
                            ),
                            labelText: 'Full name',
                            errorText: errorText,
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16.0),
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onSubmitted: (_) {},
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    StreamBuilder<PhoneNumberError>(
                      stream: bloc.phoneNumberError$,
                      builder: (context, snapshot) {
                        final errorText = snapshot.data?.fold(
                            onInvalidPhoneNumber: () => s.invalid_phone_number);

                        return TextField(
                          controller: _phoneNumberTextController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 8.0),
                              child: Icon(Icons.phone),
                            ),
                            labelText: 'Phone number',
                            errorText: errorText,
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16.0),
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onSubmitted: (_) {},
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    StreamBuilder<AddressError>(
                      stream: bloc.addressError$,
                      builder: (context, snapshot) {
                        final errorText = snapshot.data
                            ?.fold(onEmptyAddress: () => s.empty_address);

                        return TextField(
                          controller: _addressTextController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 8.0),
                              child: Icon(Icons.label),
                            ),
                            labelText: 'Address',
                            errorText: errorText,
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16.0),
                          textInputAction: TextInputAction.next,
                          autofocus: false,
                          onSubmitted: (_) {},
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 6),
                      constraints: BoxConstraints.expand(height: 56),
                      child: Material(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(56 / 2)),
                          color: Theme.of(context).accentColor,
                          splashColor: Colors.white,
                          onPressed: bloc.submitChanges,
                          child: Text(
                            'Submit changes',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: paddingTop + 12,
          left: 8,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
            ),
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
