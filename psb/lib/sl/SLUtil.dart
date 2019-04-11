import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:psb/sl/SL.dart';
import 'package:psb/sl/SpecialistSubscriber.dart';
import 'package:psb/sl/message/Message.dart';
import 'package:psb/sl/observe/ObjectObservable.dart';
import 'package:psb/sl/specialist/cache/CacheSpecialist.dart';
import 'package:psb/sl/specialist/cache/CacheSpecialistImpl.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialist.dart';
import 'package:psb/sl/specialist/desktop/DesktopSpecialistImpl.dart';
import 'package:psb/sl/specialist/error/ErrorSpecialistImpl.dart';
import 'package:psb/sl/specialist/finger/FingerPrintSpecialist.dart';
import 'package:psb/sl/specialist/finger/FingerprintSpecialistImpl.dart';
import 'package:psb/sl/specialist/messager/MessengerUnion.dart';
import 'package:psb/sl/specialist/messager/MessengerUnionImpl.dart';
import 'package:psb/sl/specialist/notification/NotificationSpecialist.dart';
import 'package:psb/sl/specialist/notification/NotificationSpecialistImpl.dart';
import 'package:psb/sl/specialist/observable/ObservableUnion.dart';
import 'package:psb/sl/specialist/observable/ObservableUnionImpl.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialist.dart';
import 'package:psb/sl/specialist/preferences/PreferencesSpecialistImpl.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnion.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnionImpl.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialist.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialistImpl.dart';
import 'package:psb/sl/specialist/router/RouterSpecialist.dart';
import 'package:psb/sl/specialist/router/RouterSpecialistImpl.dart';
import 'package:psb/sl/specialist/secure/SecureSpecialist.dart';
import 'package:psb/sl/specialist/secure/SecureSpecialistImpl.dart';
import 'package:psb/sl/specialist/ui/UISpecialist.dart';
import 'package:psb/sl/specialist/ui/UISpecialistImpl.dart';

class SLUtil {
  static get PresenterUnion {
    return SL.instance.get(PresenterUnionImpl.NAME);
  }

  static get MessengerUnion {
    return SL.instance.get(MessengerUnionImpl.NAME);
  }

  static get ObservableUnion {
    return SL.instance.get(ObservableUnionImpl.NAME);
  }

  static get DesktopSpecialist {
    return SL.instance.get(DesktopSpecialistImpl.NAME);
  }

  static get UISpecialist {
    return SL.instance.get(UISpecialistImpl.NAME);
  }

  static get PreferencesSpecialist {
    return SL.instance.get(PreferencesSpecialistImpl.NAME);
  }

  static get RepositorySpecialist {
    return SL.instance.get(RepositorySpecialistImpl.NAME);
  }

  static get SecureSpecialist {
    return SL.instance.get(SecureSpecialistImpl.NAME);
  }

  static get RouterSpecialist {
    return SL.instance.get(RouterSpecialistImpl.NAME);
  }

  static get FingerprintSpecialist {
    return SL.instance.get(FingerprintSpecialistImpl.NAME);
  }

  static get NotificationSpecialist {
    return SL.instance.get(NotificationSpecialistImpl.NAME);
  }

  static get CacheSpecialist {
    return SL.instance.get(CacheSpecialistImpl.NAME);
  }

  static void onChange(String object) {
    ObservableUnion.getObservable(ObjectObservable.NAME)?.onChange(object);
  }

  static void onError(String sender, Exception e) {
    ErrorSpecialistImpl.instance.onError(sender, e);
  }

  static void addMessage(Message message) {
    MessengerUnion.addMessage(message);
  }

  static void addNotMandatoryMessage(Message message) {
    MessengerUnion.addNotMandatoryMessage(message);
  }

  static void registerSubscriber(SpecialistSubscriber subscriber) {
    SL.instance.registerSubscriber(subscriber);
  }

  static String getString(BuildContext context, String key) {
    return AppLocalizations.of(context).tr(key);
  }
}
