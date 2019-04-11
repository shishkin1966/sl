import 'package:psb/sl/AbsServiceLocator.dart';
import 'package:psb/sl/observe/ObjectObservable.dart';
import 'package:psb/sl/specialist/cache/CacheSpecialistImpl.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialistImpl.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/specialist/finger/FingerprintSpecialistImpl.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/notification/NotificationSpecialistImpl.dart';
import 'package:psb/sl/specialist/observable/ObservableUnion.dart';
import 'package:psb/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialistImpl.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialistImpl.dart';
import 'package:psb/sl/specialist/router/RouterSpecialistImpl.dart';
import 'package:psb/sl/specialist/secure/SecureSpecialistImpl.dart';
import 'package:psb/sl/specialist/ui/UISpecialistImpl.dart';

class SL extends AbsServiceLocator {
  static const String NAME = "SL";

  static final SL _sl = new SL._internal();

  SL._internal() {
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

    // Специалист Repository
    registerSpecialistByName(RepositorySpecialistImpl.NAME);

    // Специалист Secure
    registerSpecialistByName(SecureSpecialistImpl.NAME);

    // Специалист Router
    registerSpecialistByName(RouterSpecialistImpl.NAME);

    // Специалист Fingerprint
    registerSpecialistByName(FingerprintSpecialistImpl.NAME);

    // Специалист Notification
    registerSpecialistByName(NotificationSpecialistImpl.NAME);

    // Специалист Cache
    registerSpecialistByName(CacheSpecialistImpl.NAME);
  }

  static SL get instance => _sl;

  @override
  String getName() {
    return NAME;
  }

  @override
  String getPassport() {
    return getName();
  }
}
