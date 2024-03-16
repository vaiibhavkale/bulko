import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:user/l10n/l10n.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/localNotificationModel.dart';
import 'package:user/provider/local_provider.dart';
import 'package:user/screens/splash_screen.dart';
import 'package:user/theme/style.dart';

import 'networking/my_http_client.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print(e);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(App());
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high,
    description: 'Channel Description',
    playSound: true);

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  } catch (e) {
    print('Exception - main.dart - _firebaseMessagingBackgroundHandler(): ' +
        e.toString());
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String routeName = "main";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          return GetMaterialApp(
              navigatorObservers: <NavigatorObserver>[observer],
              debugShowCheckedModeBanner: false,
              title: "Bulko",
              locale: Get.deviceLocale,
              supportedLocales: L10n.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: SplashScreen(
                analytics: analytics,
                observer: observer,
              ),
              theme: ThemeUtils.defaultAppThemeData,
              darkTheme: ThemeUtils.darkAppThemData,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setOptimalDisplayMode();
    setupNotifications();
  }
  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
    m.width == active.width && m.height == active.height)
        .toList()
      ..sort((DisplayMode a, DisplayMode b) =>
          b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode = sameResolution.isNotEmpty
        ? sameResolution.first
        : active;

    /// This setting is per session.
    /// Please ensure this was placed with initState of your root widget.
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }
  void setupNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        LocalNotification _notificationModel =
            LocalNotification.fromJson(message.data);
        global.localNotificationModel = _notificationModel;
        global.isChatNotTapped = false;

        if (message.notification != null) {
          Future<String> _downloadAndSaveFile(
              String url, String fileName) async {
            final Directory directory =
                await getApplicationDocumentsDirectory();
            final String filePath = '${directory.path}/$fileName';
            final http.Response response = await http.get(Uri.parse(url));
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }

          if (Platform.isAndroid) {
            String bigPicturePath;
            AndroidNotificationDetails androidPlatformChannelSpecifics;
            if (message.notification?.android?.imageUrl != null &&
                '${message.notification?.android?.imageUrl}' != 'N/A') {
              print('in Image');
              print('${message.notification?.android?.imageUrl}');
              bigPicturePath = await _downloadAndSaveFile(
                  message.notification?.android?.imageUrl != null
                      ? message.notification!.android!.imageUrl!
                      : 'https://picsum.photos/200/300',
                  'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation =
                  BigPictureStyleInformation(
                FilePathAndroidBitmap(bigPicturePath),
              );
              androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: 'ic_notification',
                  styleInformation: bigPictureStyleInformation,
                  playSound: true);
            } else {
              print('in No Image');
              androidPlatformChannelSpecifics = AndroidNotificationDetails(
                  channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: 'ic_notification',
                  styleInformation:
                      BigTextStyleInformation(message.notification!.body!),
                  playSound: true);
            }
            // final AndroidNotificationDetails androidPlatformChannelSpecifics2 =
            final NotificationDetails platformChannelSpecifics =
                NotificationDetails(android: androidPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(1, message.notification!.title,
                message.notification!.body, platformChannelSpecifics);
          } else if (Platform.isIOS) {
            final String bigPicturePath = await _downloadAndSaveFile(
                message.notification?.apple?.imageUrl != null
                    ? message.notification!.apple!.imageUrl!
                    : 'https://picsum.photos/200/300',
                'bigPicture.jpg');
            final DarwinNotificationDetails iOSPlatformChannelSpecifics =
                DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[
              DarwinNotificationAttachment(bigPicturePath)
            ], presentSound: true);
            final DarwinNotificationDetails iOSPlatformChannelSpecifics2 =
                DarwinNotificationDetails(presentSound: true);
            final NotificationDetails notificationDetails = NotificationDetails(
              iOS: message.notification?.apple?.imageUrl != null
                  ? iOSPlatformChannelSpecifics
                  : iOSPlatformChannelSpecifics2,
            );
            await flutterLocalNotificationsPlugin.show(
                1,
                message.notification!.title,
                message.notification!.body,
                notificationDetails);
          }
        }
      } catch (e) {
        print('Exception - main.dart - onMessage.listen(): ' + e.toString());
      }
    });
  }
}
