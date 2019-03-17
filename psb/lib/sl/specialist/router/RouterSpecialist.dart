import 'package:flutter/material.dart';
import 'package:psb/app/data/Operation.dart';
import 'package:psb/sl/Specialist.dart';

abstract class RouterSpecialist extends Specialist {
  void showAccountsScreen(BuildContext context);

  void showSettingsScreen(BuildContext context);

  void showOperationScreen(BuildContext context, Operation operation);

  void showRatesScreen(BuildContext context);

  void showAddressScreen(BuildContext context);

  void showContactsScreen(BuildContext context);
}
