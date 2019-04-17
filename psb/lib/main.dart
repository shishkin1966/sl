import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psb/app/screen/Rates/RatesScreenWidget.dart';
import 'package:psb/app/screen/accounts/AccountsScreenWidget.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/app/screen/contacts/ContactsScreenWidget.dart';
import 'package:psb/app/screen/home/HomeScreenWidget.dart';
import 'package:psb/app/screen/settings/SettingsScreenWidget.dart';
import 'package:psb/common/Log.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/specialist/router/Router.dart';
import 'package:psb/ui/Application.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> main() async {
  Log.instance.init();

  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // This creates a [Zone] that contains the Flutter application and stablishes
  // an error handler that captures errors and reports them.
  //
  // Using a zone makes sure that as many errors as possible are captured,
  // including those thrown from [Timer]s, microtasks, I/O, and those forwarded
  // from the `FlutterError` handler.
  //
  // More about zones:
  //
  // - https://api.dartlang.org/stable/1.24.2/dart-async/Zone-class.html
  // - https://www.dartlang.org/articles/libraries/zones
  runZoned<Future<Null>>(() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
      runApp(EasyLocalization(child: MyApp()));
    });
  }, onError: (error, stackTrace) async {
    await _onError(error, stackTrace);
  });
}

Future<Null> _onError(dynamic error, dynamic stackTrace) async {
  Log.instance.w(stackTrace);
}

class MyApp extends Application {
  Map<String, WidgetBuilder> _routes = {
    Router.ShowHomeScreen: (BuildContext context) => HomeScreenWidget(),
    Router.ShowSettingsScreen: (BuildContext context) => SettingsScreenWidget(),
    Router.ShowAccountsScreen: (BuildContext context) => AccountsScreenWidget(),
    Router.ShowRatesScreen: (BuildContext context) => RatesScreenWidget(),
    Router.ShowAddressScreen: (BuildContext context) => AddressScreenWidget(),
    Router.ShowContactsScreen: (BuildContext context) => ContactsScreenWidget(),
  };

  @override
  Widget build(BuildContext context) {
    SLUtil.registerSubscriber(this);
    SLUtil.repositorySpecialist.connectDb(context);

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
        routes: _routes,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          //app-specific localization
          EasylocaLizationDelegate(locale: data.locale ?? Locale('ru'), path: 'assets/langs'),
        ],
        supportedLocales: [Locale('en'), Locale('ru')],
        locale: data.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreenWidget(),
      ),
    );
  }
}
