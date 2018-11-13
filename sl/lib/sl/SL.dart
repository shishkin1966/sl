import 'package:sl/sl/AbsServiceLocator.dart';
import 'package:sl/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:sl/sl/SpecialistFactory.dart';

class SL extends AbsServiceLocator {
  static const String NAME = "SL";
  var _specialistFactory;

  static final SL _sl = new SL._internal();
  SL._internal() {
    _specialistFactory = new ServiceLocatorSpecialistFactory();
  }
  static SL get instance => _sl;

  @override
  void onStart() {}

  @override
  void onStop() {}

  @override
  SpecialistFactory getSpecialistFactory() {
    return _specialistFactory;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  String getPasport() {
    return getName();
  }
}
