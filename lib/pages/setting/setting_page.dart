import 'dart:async';

import 'package:find_room/app/app_locale_bloc.dart';
import 'package:find_room/bloc/bloc_provider.dart';
import 'package:find_room/generated/i18n.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  LocaleBloc _localeBloc;
  S _s;
  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _localeBloc = BlocProvider.of<LocaleBloc>(context);
    _s = S.of(context);

    _subscription?.cancel();
    _subscription = _localeBloc.changeLocaleResult$.listen(_showMessage);
  }

  void _showMessage(result) {
    if (result.item1) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(_s.change_language_success),
        ),
      );
    } else if (result.item2 != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(_s.change_language_error(result.item2)),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(_s.change_language_failure),
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
        title: Text(_s.settings_title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildChangeLanguage(_localeBloc, _s),
          ],
        ),
      ),
    );
  }

  StreamBuilder<Locale> _buildChangeLanguage(LocaleBloc localeBloc, S s) {
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
                      title: Text(_s.change_language),
                      content: ListView(children: children),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(_s.cancel),
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
