import 'package:psb/sl/Subscriber.dart';
import 'package:psb/sl/Validated.dart';
import 'package:psb/sl/specialist/cache/CacheSpecialistImpl.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialistImpl.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/specialist/finger/FingerprintSpecialistImpl.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/notification/NotificationSpecialistImpl.dart';
import 'package:psb/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialistImpl.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialistImpl.dart';
import 'package:psb/sl/specialist/router/RouterSpecialistImpl.dart';
import 'package:psb/sl/specialist/secure/SecureSpecialistImpl.dart';
import 'package:psb/sl/specialist/ui/UISpecialistImpl.dart';

///
/// Специалист
///
abstract class Specialist implements Subscriber, Validated, Comparable {
  ///
  /// Проверить работает ли специалист постоянно
  ///
  /// @return true - специалист постоянный
  ///
  bool isPersistent();

  ///
  /// Событие, вызываемое при отмене регистрации специалиста
  ///
  void onUnRegister();

  ///
  /// Событие, вызываемое при регистрации специалиста
  ///
  void onRegister();

  ///
  /// Остановить работу специалиста
  ///
  void stop();

  factory Specialist.get(String name) {
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

      case SecureSpecialistImpl.NAME:
        return new SecureSpecialistImpl();

      case RepositorySpecialistImpl.NAME:
        return new RepositorySpecialistImpl();

      case RouterSpecialistImpl.NAME:
        return new RouterSpecialistImpl();

      case FingerprintSpecialistImpl.NAME:
        return new FingerprintSpecialistImpl();

      case NotificationSpecialistImpl.NAME:
        return new NotificationSpecialistImpl();

      case CacheSpecialistImpl.NAME:
        return new CacheSpecialistImpl();
    }
    return null;
  }
}
