import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class notificationServicrd{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings=AndroidInitializationSettings('logo');
  void initializeNotification()async{
    InitializationSettings initializationSettings=InitializationSettings(
      android: _androidInitializationSettings,
    );
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNoti(String title,String desc) async{
    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max,priority:Priority.high);
    NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(0, title, desc,RepeatInterval.daily ,notificationDetails);
    print("kk");
  }
    void scheduleNotiweek(String title,String desc) async{
    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails('channelId', 'channelName',importance: Importance.max,priority:Priority.high);
    NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(0, title, desc,RepeatInterval.weekly ,notificationDetails);
    print("kk");
  }
  
void cancelnoti()async{
  _flutterLocalNotificationsPlugin.cancel(0);
}
}