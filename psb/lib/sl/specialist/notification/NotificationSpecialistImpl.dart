import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:psb/sl/AbsSpecialist.dart';
import 'package:psb/sl/specialist/notification/NotificationSpecialist.dart';
import 'package:synchronized/synchronized.dart' as Synchronized;

class NotificationSpecialistImpl extends AbsSpecialist
    implements NotificationSpecialist {
  static const String NAME = "NotificationSpecialistImpl";

  static const String GroupKey = "PSB_GroupKey";
  static const String ChannelID = "PSB_ChannelID";
  static const String ChannelName = "PSB_ChannelName";
  static const String ChannelDescription = "PSB_ChannelDescription";

  FlutterLocalNotificationsPlugin _plugin;
  NotificationDetails _details;
  int _id = -1;
  Synchronized.Lock _lock = new Synchronized.Lock();

  @override
  void onRegister() {
    _plugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app');
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, null);
    _plugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        ChannelID, ChannelName, ChannelDescription,
        importance: Importance.Default,
        priority: Priority.Default,
        groupKey: GroupKey,
        setAsGroupSummary: false);
    _details = new NotificationDetails(androidPlatformChannelSpecifics, null);
  }

  @override
  int compareTo(other) {
    return (other is NotificationSpecialist) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  Future replaceMessage(String title, String message, {String idScreen}) async {
    if (_id == -1) {
      _getId().then((id) {
        _plugin.show(id, title, message, _details, payload: idScreen);
      });
    } else {
      _plugin.show(_id, title, message, _details, payload: idScreen);
    }
  }

  @override
  Future showMessage(String title, String message, {String idScreen}) async {
    _getId().then((id) {
      _plugin.show(id, title, message, _details, payload: idScreen);
    });
  }

  @override
  Future clear() async {
    await _plugin.cancelAll();
  }

  Future onSelectNotification(String payload) async {}

  Future<int> _getId() async {
    return await _lock.synchronized(() async {
      _id++;
      return _id;
    });
  }

  @override
  Future showGroupMessage(String title, {String idScreen}) async {
    _getId().then((id) {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          ChannelID, ChannelName, ChannelDescription,
          importance: Importance.Default,
          priority: Priority.Default,
          groupKey: GroupKey,
          setAsGroupSummary: true);
      NotificationDetails details =
          new NotificationDetails(androidPlatformChannelSpecifics, null);
      _plugin.show(id, title, "", details, payload: idScreen);
    });
  }
}
