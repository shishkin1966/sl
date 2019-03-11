import 'package:psb/sl/Specialist.dart';
import 'package:psb/sl/SpecialistFactory.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialistImpl.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialistImpl.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:psb/sl/specialist/ui/UISpecialistImpl.dart';

class ServiceLocatorSpecialistFactory implements SpecialistFactory {
  @override
  Specialist create(final String name) {
    switch (name) {
      case ErrorSpecialistImpl.NAME:
        return ErrorSpecialistImpl.instance;

      case PresenterUnionImpl.NAME:
        return new PresenterUnionImpl();

      case MessengerUnionImpl.NAME:
        return new MessengerUnionImpl();

      case ObservableUnionImpl.NAME:
        return new ObservableUnionImpl();

      case DesktopSpecialistImpl.NAME:
        return new DesktopSpecialistImpl();

      case UISpecialistImpl.NAME:
        return new UISpecialistImpl();

      case PreferencesSpecialistImpl.NAME:
        return new PreferencesSpecialistImpl();
    }
    return null;
  }
}