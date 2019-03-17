import 'package:psb/sl/Specialist.dart';

abstract class SecureSpecialist extends Specialist {
  Future<String> encode(String value);

  Future<String> decode(String value);
}
