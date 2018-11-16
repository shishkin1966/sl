import 'package:sl/sl/AbsServiceLocator.dart';
import 'package:sl/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:sl/sl/SpecialistFactory.dart';
import 'package:sl/sl/observe/ObjectObservable.dart';
import 'package:sl/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:sl/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:sl/sl/specialist/observable/ObservableUnion.dart';
import 'package:sl/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';

class SL extends AbsServiceLocator {
  static const String NAME = "SL";
  SpecialistFactory _specialistFactory;

  static final SL _sl = new SL._internal();

  SL._internal() {
    _specialistFactory = new ServiceLocatorSpecialistFactory();

    registerSpecialist(ErrorSpecialistImpl.instance);
    registerSpecialistByName(MessengerUnionImpl.NAME);
    registerSpecialistByName(PresenterUnionImpl.NAME);
    registerSpecialistByName(ObservableUnionImpl.NAME);

    (get(ObservableUnionImpl.NAME) as ObservableUnion).registerObservable(new ObjectObservable());
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
