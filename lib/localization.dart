import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';
import './constants.dart' show languages;

class CurbWheelLocalizations {
  static Future<CurbWheelLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new CurbWheelLocalizations();
    });
  }

  static CurbWheelLocalizations of(BuildContext context) {
    return Localizations.of<CurbWheelLocalizations>(context, CurbWheelLocalizations);
  }

  greetTo(name) => Intl.message("Nice to meet you, $name!",
      name: 'greetTo', desc: 'The application title', args: [name]);

  String get hello {
    return Intl.message('Hello!', name: 'hello');
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<CurbWheelLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return languages.contains(locale.languageCode);
  }

  @override
  Future<CurbWheelLocalizations> load(Locale locale) {
    return CurbWheelLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<CurbWheelLocalizations> old) {
    return false;
  }
}