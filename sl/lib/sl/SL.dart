import 'package:sl/sl/AbsServiceLocator.dart';
import 'package:sl/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:sl/sl/SpecialistFactory.dart';

class SL extends AbsServiceLocator {
  static const String NAME = "SL";
  var _specialistFactory;

  SL() {
    _specialistFactory = new ServiceLocatorSpecialistFactory();
  }

  @override
  String name = NAME;

  @override
  String pasport = NAME;

  @override
  void onStart() {}

  @override
  void onStop() {}

  @override
  SpecialistFactory getSpecialistFactory() {
    return _specialistFactory;
  }
}
