import 'package:psb/sl/AbsServiceLocator.dart';
import 'package:psb/sl/ServiceLocatorSpecialistFactory.dart';
import 'package:psb/sl/SpecialistFactory.dart';
import 'package:psb/sl/observe/ObjectObservable.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialistImpl.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/observable/ObservableUnion.dart';
import 'package:psb/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialistImpl.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:psb/sl/specialist/ui/UISpecialistImpl.dart';

class SL extends AbsServiceLocator {
  static const String NAME = "SL";
  SpecialistFactory _specialistFactory;

  static final SL _sl = new SL._internal();

  SL._internal() {
    _specialistFactory = new ServiceLocatorSpecialistFactory();

    // Специалист вывода Toast
    registerSpecialistByName(UISpecialistImpl.NAME);

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

    // Специалист Preferences
    registerSpecialistByName(PreferencesSpecialistImpl.NAME);
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
