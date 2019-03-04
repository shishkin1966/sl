import 'package:flutter/material.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/app/screen/Rates/RatesScreenWidget.dart';
import 'package:psb/app/screen/accounts/AccountsScreenWidget.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/app/screen/contacts/ContactsScreenWidget.dart';
import 'package:psb/app/screen/settings/SettingsScreenWidget.dart';

class Router {
  static const String ShowAccountsScreen = "ShowAccountsScreen";
  static const String ShowSettingsScreen = "ShowSettingsScreen";
  static const String ShowRatesScreen = "ShowRatesScreen";
  static const String ShowAddressScreen = "ShowAddressScreen";
  static const String ShowContactsScreen = "ShowContactsScreen";

  static void showAccountsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountsScreenWidget()),
    );
  }

  static void showSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreenWidget()),
    );
  }

  static void showOperationScreen(BuildContext context, Operation operation) {}

  static void showRatesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RatesScreenWidget()),
    );
  }

  static void showAddressScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressScreenWidget()),
    );
  }

  static void showContactsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsScreenWidget()),
    );
  }
}
