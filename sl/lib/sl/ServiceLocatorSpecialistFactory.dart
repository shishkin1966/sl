import 'package:sl/sl/Specialist.dart';
import 'package:sl/sl/SpecialistFactory.dart';
import 'package:sl/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:sl/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:sl/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';

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
    }
    return null;
  }
}
