import 'package:flutter/material.dart';
import 'package:local_notifications/local_notifications.dart';


class ExamsFragment extends StatelessWidget {


  // Initialize your Notification channel object
    static const AndroidNotificationChannel channel = const AndroidNotificationChannel(
        id: 'default_notification',
        name: 'Default',
        description: 'Grant this app the ability to show notifications'/*,
        importance: AndroidNotificationImportance.HIGH*/
    );


  @override
  Widget build(BuildContext context){

  sendNotification();

    // TODO: implement build
    return new Center(
      child: new Text("Hamarosan"),
    );
  }

  void sendNotification() async{
    // Create the notification channel (this is a no-op on iOS and android <8.0 devices)
    // Only need to run this one time per App install, any calls after that will be a no-op at the native level
    // but will still need to use the platform channel. For this reason, avoid calling this except for the
    // first time you need to create the channel.
    await LocalNotifications.createAndroidNotificationChannel(channel: channel);

    // Create your notification, providing the channel info
    await LocalNotifications.createNotification(
        title: "Basic",
        content: "Notification",
        id: 0,
        androidSettings: new AndroidSettings(
            channel: channel
        )
    );
  }

}