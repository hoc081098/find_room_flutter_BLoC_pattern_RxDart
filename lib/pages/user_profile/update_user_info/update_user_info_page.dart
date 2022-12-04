import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_room/auth_bloc/auth_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_bloc.dart';
import 'package:find_room/pages/user_profile/update_user_info/update_user_info_state.dart';
import 'package:find_room/pages/user_profile/user_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserInfoPage extends StatefulWidget {
  final AuthBloc authBloc;

  const UpdateUserInfoPage({Key key, @required this.authBloc})
      : super(key: key);

  @override
  _UpdateUserInfoPageState createState() => _UpdateUserInfoPageState();
}

class _UpdateUserInfoPageState extends State<UpdateUserInfoPage> {
  StreamSubscription _subscription;

  TextEditingController _fullNameController;
  TextEditingController _phoneNumberController;
  TextEditingController _addressController;

  FocusNode _focusNodeFullName;
  FocusNode _focusNodePhoneNumber;
  FocusNode _focusNodeAddress;

  @override
  void initState() {
    super.initState();

    _focusNodeFullName = FocusNode();
    _focusNodePhoneNumber = FocusNode();
    _focusNodeAddress = FocusNode();

    final currentUser = widget.authBloc.currentUser();
    assert(currentUser != null);

    _fullNameController = TextEditingController(text: currentUser.fullName);
    _phoneNumberController = TextEditingController(text: currentUser.phone);
    _addressController = TextEditingController(text: currentUser.address);

    print('[UPDATE_USER_INFO_PAGE] { init }');
  }

  _showSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _subscription ??= BlocProvider.of<UpdateUserInfoBloc>(context)
        .message$
        .listen(_handleMessage);
    super.didChangeDependencies();
  }

  _handleMessage(UpdateUserInfoMessage message) {
    print('[UPDATE_USER_INFO_PAGE] message=$message');

    message.fold(
      onInvalidInformation: () =>
          _showSnackBar(S.of(context).invalid_information),
      onUpdateFailure: (UpdateUserInfoError error) {
        final errorText = error.fold(
          onNetworkError: () => S.of(context).network_error,
          onOperationNotAllowedError: () =>
              S.of(context).operation_not_allowed_error,
          onTooManyRequestsError: () => S.of(context).too_many_requests_error,
          onUnknown: () => S.of(context).uknown_error,
          onUserDisable: () => S.of(context).user_disabled_error,
          onUserNotFound: () => S.of(context).user_not_found_error,
        );
        _showSnackBar(errorText);
      },
      onUpdateSuccess: () {
        _showSnackBar(S.of(context).update_successfully);
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  void dispose() {
    print('[UPDATE_USER_INFO_PAGE] { dispose }');

    [_fullNameController, _phoneNumberController, _addressController]
        .forEach((c) => c.dispose());

    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UpdateUserInfoBloc>(context);
    final paddingTop = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Stack(
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
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
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
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Center(child: const _Avatar()),
                      const SizedBox(height: 8),
                      _FullNameTextField(
                        focusNode: _focusNodeFullName,
                        focusNodeNext: _focusNodePhoneNumber,
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 8),
                      _PhoneNumberTextField(
                        focusNode: _focusNodePhoneNumber,
                        focusNodeNext: _focusNodeAddress,
                        controller: _phoneNumberController,
                      ),
                      const SizedBox(height: 8),
                      _AddressTextField(
                        focusNode: _focusNodeAddress,
                        controller: _addressController,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 6),
                        constraints: BoxConstraints.expand(height: 56),
                        child: StreamBuilder<bool>(
                          stream: bloc.isLoading$,
                          initialData: bloc.isLoading$.value,
                          builder: (context, snapshot) {
                            if (snapshot.data) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Material(
                              child: RaisedButton(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(56 / 2),
                                ),
                                color: Theme.of(context).accentColor,
                                splashColor: Colors.white,
                                onPressed: bloc.submitChanges,
                                child: Text(
                                  S.of(context).submit_changes,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
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
      ),
      onWillPop: () => _onWillPop(bloc),
    );
  }

  Future<bool> _onWillPop(UpdateUserInfoBloc bloc) async {
    if (bloc.isLoading$.value) {
      final exit = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          final s = S.of(context);

          return AlertDialog(
            title: Text(S.of(context).exit_update_user_info),
            content: Text(S
                .of(context)
                .processing_update_infoare_you_sure_you_want_to_exit),
            actions: <Widget>[
              FlatButton(
                child: Text(s.no),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: Text(s.exit),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );
      return exit ?? false;
    }
    return true;
  }
}

class _AddressTextField extends StatelessWidget {
  const _AddressTextField({
    Key key,
    @required FocusNode focusNode,
    @required TextEditingController controller,
  })  : _focusNode = focusNode,
        _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = BlocProvider.of<UpdateUserInfoBloc>(context);

    return StreamBuilder<AddressError>(
      stream: bloc.addressError$,
      builder: (context, snapshot) {
        final errorText =
            snapshot.data?.fold(onEmptyAddress: () => s.empty_address);

        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(Icons.label),
            ),
            labelText: s.address,
            errorText: errorText,
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0),
          textInputAction: TextInputAction.done,
          autofocus: false,
          onChanged: bloc.addressChanged,
        );
      },
    );
  }
}

class _PhoneNumberTextField extends StatelessWidget {
  const _PhoneNumberTextField({
    Key key,
    @required FocusNode focusNode,
    @required FocusNode focusNodeNext,
    @required TextEditingController controller,
  })  : _focusNode = focusNode,
        _focusNodeNext = focusNodeNext,
        _controller = controller,
        super(key: key);

  final FocusNode _focusNode;
  final FocusNode _focusNodeNext;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = BlocProvider.of<UpdateUserInfoBloc>(context);

    return StreamBuilder<PhoneNumberError>(
      stream: bloc.phoneNumberError$,
      builder: (context, snapshot) {
        final errorText = snapshot.data
            ?.fold(onInvalidPhoneNumber: () => s.invalid_phone_number);

        return TextField(
          focusNode: _focusNode,
          autocorrect: true,
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(Icons.phone),
            ),
            labelText: s.phone_number,
            errorText: errorText,
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0),
          textInputAction: TextInputAction.next,
          autofocus: false,
          onChanged: bloc.phoneNumberChanged,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_focusNodeNext);
          },
        );
      },
    );
  }
}

class _FullNameTextField extends StatelessWidget {
  const _FullNameTextField({
    Key key,
    @required FocusNode focusNode,
    @required FocusNode focusNodeNext,
    @required TextEditingController controller,
  })  : _focusNode = focusNode,
        _focusNodeNext = focusNodeNext,
        _controller = controller,
        super(key: key);

  final FocusNode _focusNode;
  final FocusNode _focusNodeNext;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = BlocProvider.of<UpdateUserInfoBloc>(context);

    return StreamBuilder<FullNameError>(
      stream: bloc.fullNameError$,
      builder: (context, snapshot) {
        final errorText = snapshot.data?.fold(
          onLengthOfFullNameLessThan3Chars: () =>
              s.full_name_at_least_6_characters,
        );

        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(Icons.person),
            ),
            labelText: s.full_name,
            errorText: errorText,
          ),
          keyboardType: TextInputType.text,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0),
          textInputAction: TextInputAction.next,
          autofocus: false,
          onChanged: bloc.fullNameChanged,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_focusNodeNext);
          },
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key key}) : super(key: key);

  Future<File> _pickImage() {
    return ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UpdateUserInfoBloc>(context);

    return InkWell(
      onTap: () => _pickImage().then(bloc.avatarChanged),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade200,
              offset: Offset(4, 4),
              blurRadius: 10,
            )
          ],
        ),
        width: 96,
        height: 96,
        child: StreamBuilder<File>(
          stream: bloc.avatar$,
          initialData: bloc.avatar$.value,
          builder: (context, snapshot) {
            final file = snapshot.data;

            if (file != null) {
              return CircleAvatar(
                radius: 48,
                backgroundImage: FileImage(file),
                backgroundColor: Colors.white.withOpacity(0.9),
              );
            }

            final avatar =
                BlocProvider.of<AuthBloc>(context).currentUser()?.avatar;
            if (avatar != null && avatar.isNotEmpty) {
              return CircleAvatar(
                radius: 48,
                backgroundImage: CachedNetworkImageProvider(avatar),
                backgroundColor: Colors.white.withOpacity(0.9),
              );
            }

            return CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              radius: 48,
              child: Icon(
                Icons.person,
                size: 72,
                color: Theme.of(context).accentColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
