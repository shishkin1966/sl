import 'package:sl/sl/Specialist.dart';
import 'package:sl/sl/SpecialistFactory.dart';
import 'package:sl/sl/specialist/messager/MessagerUnionImpl.dart';
import 'package:sl/sl/specialist/presenter/PresenterUnionImpl.dart';

class ServiceLocatorSpecialistFactory implements SpecialistFactory {
  @override
  Specialist create(final String name) {
    switch (name) {
      case PresenterUnionImpl.NAME:
        return new PresenterUnionImpl();
      case MessagerUnionImpl.NAME:
        return new MessagerUnionImpl();
    }
    return null;
  }
}
