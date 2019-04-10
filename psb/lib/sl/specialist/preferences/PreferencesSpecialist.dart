import 'package:psb/sl/AbsSpecialist.dart';

abstract class PreferencesSpecialist extends AbsSpecialist {
  setInt(String name, int value);

  setString(String name, String value);

  setBool(String name, bool value);

  setDouble(String name, double value);

  setStringList(String name, List<String> value);
}
