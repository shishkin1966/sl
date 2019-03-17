import 'package:flutter/material.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/app/screen/Rates/RatesScreenWidget.dart';
import 'package:psb/app/screen/accounts/AccountsScreenWidget.dart';
import 'package:psb/app/screen/address/AddressScreenWidget.dart';
import 'package:psb/app/screen/contacts/ContactsScreenWidget.dart';
import 'package:psb/app/screen/settings/SettingsScreenWidget.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/router/RouterSpecialist.dart';

class RouterSpecialistImpl extends AbsSpecialist implements RouterSpecialist {
  static const String NAME = "RouterSpecialistImpl";

  @override
  void showAccountsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountsScreenWidget()),
    );
  }

  @override
  void showSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreenWidget()),
    );
  }

  @override
  void showOperationScreen(BuildContext context, Operation operation) {}

  @override
  void showRatesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RatesScreenWidget()),
    );
  }

  @override
  void showAddressScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddressScreenWidget()),
    );
  }

  @override
  void showContactsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsScreenWidget()),
    );
  }

  @override
  int compareTo(other) {
    return (other is RouterSpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }
}
