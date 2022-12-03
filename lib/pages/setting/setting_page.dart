import 'dart:async';

import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final LocaleBloc localeBloc;

  const SettingPage({Key key, @required this.localeBloc}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = widget.localeBloc.changeLocaleResult$.listen(_showMessage);
  }

  void _showMessage(result) {
    final s = S.of(context);

    if (result.item1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.change_language_success),
        ),
      );
    } else if (result.item2 != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.change_language_error(result.item2)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.change_language_failure),
        ),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings_title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[const SettingChangeLanguage()],
        ),
      ),
    );
  }
}

class SettingChangeLanguage extends StatelessWidget {
  const SettingChangeLanguage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeBloc = BlocProvider.of<LocaleBloc>(context);
    final s = S.of(context);

    return StreamBuilder<Locale>(
        stream: localeBloc.locale$,
        initialData: localeBloc.locale$.value,
        builder: (context, snapshot) {
          return ListTile(
            title: Text(s.change_language),
            subtitle: Text(supportedLocaleTitles[snapshot.data]),
            trailing: Icon(Icons.language),
            onTap: () async {
              final locale = await showDialog<Locale>(
                  context: context,
                  builder: (context) {
                    final children =
                        supportedLocaleTitles.keys.map<Widget>((locale) {
                      return ListTile(
                        title: Text(supportedLocaleTitles[locale]),
                        onTap: () => Navigator.of(context).pop<Locale>(locale),
                        selected: snapshot.data == locale,
                      );
                    }).toList();

                    return AlertDialog(
                      title: Text(s.change_language),
                      content: SingleChildScrollView(
                        child: Column(
                          children: children,
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(s.cancel),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  });
              if (locale != null) {
                localeBloc.changeLocale.add(locale);
              }
            },
          );
        });
  }
}
