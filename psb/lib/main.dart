import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psb/app/screen/home/HomeScreenWidget.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/ui/Application.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(EasyLocalization(child: MyApp()));
  });
}

class MyApp extends Application {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SLUtil.registerSubscriber(this);

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: MaterialApp(
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
