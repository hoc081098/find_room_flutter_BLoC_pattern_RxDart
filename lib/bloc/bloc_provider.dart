import 'package:flutter/material.dart';

abstract class BaseBloc {
  void dispose();
}

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final T Function() blocSupplier;
  final Widget child;

  const BlocProvider({
    Key key,
    @required this.blocSupplier,
    @required this.child,
  }) : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    _BlocProviderInheritedWidget<T> provider = context
        .dependOnInheritedWidgetOfExactType<_BlocProviderInheritedWidget<T>>();
    if (provider == null) {
      throw StateError(
          'Cannot get provider with type ${_typeOf<_BlocProviderInheritedWidget<T>>()}');
    }
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T extends BaseBloc> extends State<BlocProvider<T>> {
  T _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.blocSupplier();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInheritedWidget<T>(
      bloc: _bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    print('[DEBUG] Bloc disposed');
    super.dispose();
  }
}

class _BlocProviderInheritedWidget<T extends BaseBloc> extends InheritedWidget {
  final T bloc;

  const _BlocProviderInheritedWidget({
    Key key,
    @required Widget child,
    @required this.bloc,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_BlocProviderInheritedWidget old) => bloc != old.bloc;
}
