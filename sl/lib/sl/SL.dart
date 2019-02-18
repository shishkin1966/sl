import 'package:sl/sl/AbsServiceLocator.dart';
import 'package:sl/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:sl/sl/SpecialistFactory.dart';
import 'package:sl/sl/observe/ObjectObservable.dart';
import 'package:sl/sl/specialist/desktop/DesktopSpecialistImpl.dart';
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

    // Специалист регистрации ошибок
    registerSpecialist(ErrorSpecialistImpl.instance);

    // Messenger сообщений
    registerSpecialistByName(MessengerUnionImpl.NAME);

    // Специалист презенторов
    registerSpecialistByName(PresenterUnionImpl.NAME);

    // Специалист Observable
    registerSpecialistByName(ObservableUnionImpl.NAME);

    // Регистрация слушателя изменения объектов
    (get(ObservableUnionImpl.NAME) as ObservableUnion).registerObservable(new ObjectObservable());

    // Специалист рабочих столов
    registerSpecialistByName(DesktopSpecialistImpl.NAME);
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
  String getPassport() {
    return getName();
  }
}
