import 'package:psb/sl/Specialist.dart';

abstract class PreferencesSpecialist extends Specialist {
  setInt(String name, int value);

  setString(String name, String value);

  setBool(String name, bool value);

  setDouble(String name, double value);

  setStringList(String name, List<String> value);
}
