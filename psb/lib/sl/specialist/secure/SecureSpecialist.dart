import 'package:psb/sl/AbsSpecialist.dart';

abstract class SecureSpecialist extends AbsSpecialist {
  Future<String> encode(String value);

  Future<String> decode(String value);
}
