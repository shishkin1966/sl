import 'package:sl/sl/AbsServiceLocator.dart';
import 'package:sl/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:sl/sl/SpecialistFactory.dart';

class SL extends AbsServiceLocator {
  var specialistFactory;

  SL() {
    specialistFactory = new ServiceLocatorSpecialistFactory();
  }

  @override
  String name = "SL";

  @override
  String pasport = "SL";

  @override
  void onStart() {}

  @override
  void onStop() {}

  @override
  SpecialistFactory getSpecialistFactory() {
    return specialistFactory;
  }
}
