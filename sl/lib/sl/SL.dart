import 'package:sl/sl/AbsServiceLocator.dart';
import 'package:sl/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:sl/sl/SpecialistFactory.dart';
import 'package:sl/sl/specialist/messager/MessagerUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';

class SL extends AbsServiceLocator {
  static const String NAME = "SL";
  SpecialistFactory _specialistFactory;

  static final SL _sl = new SL._internal();

  SL._internal() {
    _specialistFactory = new ServiceLocatorSpecialistFactory();

    registerSpecialistByName(MessagerUnionImpl.NAME);
    registerSpecialistByName(PresenterUnionImpl.NAME);
  }

  static SL get instance => _sl;

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
