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
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/specialist/router/Router.dart';
import 'package:psb/ui/Application.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(EasyLocalization(child: MyApp()));
  });
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
          EasylocaLizationDelegate(
              locale: data.locale ?? Locale('ru'), path: 'assets/langs'),
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
