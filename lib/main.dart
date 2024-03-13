import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:google_api_availability/google_api_availability.dart';
import 'package:notifications/firebase_options.dart';
import 'package:notifications/open_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notifications/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(onBackground);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> onBackground(RemoteMessage message) {
//  AndroidNotificationDetails details = const AndroidNotificationDetails(
//             'my_channel_id', 'my_channel_name',
//             channelDescription: 'base_channel',
//             importance: Importance.high,
//             priority: Priority.high,
//             ticker: 'ticker');
//         flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification?.title ?? 'Khurram',
//           message.notification?.body ?? "Naseem",
//           NotificationDetails(android: details),
//         );
  return Future.value(null);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> setUpInteraction() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _handleMessage(message);
    }
  }

  _handleMessage(RemoteMessage message) {
    if ((message.notification?.title ?? '') == 'NoOne') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const OpenPage(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    setUpInteraction();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin
        .initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (details) {},
        )
        .then((value) {});

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        String imageUrl = message.notification!.android!.imageUrl!;
        var response = await http.get(Uri.parse(imageUrl));
        BigPictureStyleInformation bigPictureStyleInformation =
            BigPictureStyleInformation(
                hideExpandedLargeIcon: true,
                contentTitle: '',                                           
                htmlFormatContentTitle: true,
                largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                    base64Encode(response.bodyBytes)),
                ByteArrayAndroidBitmap.fromBase64String(
                    base64Encode(response.bodyBytes)));

        AndroidNotificationDetails details =
            AndroidNotificationDetails('my_channel_id', 'my_channel_name',
                channelDescription: 'base_channel',
                importance: Importance.high,
                priority: Priority.high,
                autoCancel: true,
                // largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                //     base64Encode(response.bodyBytes)),
                styleInformation: bigPictureStyleInformation,
                // actions: [
                //   AndroidNotificationAction(
                //     'first',
                //     'Reply',
                //     allowGeneratedReplies: true,
                //     inputs: [
                //       AndroidNotificationActionInput(
                //         allowFreeFormInput: true,
                //         label: 'Reply',
                //       ),
                //     ],
                //   ),
                //   AndroidNotificationAction('second', 'Cancel'),
                // ],
                ticker: 'ticker');
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title,
          '',
          NotificationDetails(android: details),
        );
      }
    });
    _check();
  }

  _check() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      _showError();
    } else {
      log('[Token : $token]');
      _showKey(token);
    }
    GooglePlayServicesAvailability availability = await GoogleApiAvailability
        .instance
        .checkGooglePlayServicesAvailability(true);
    _showData(availability.value);
  }

  _showKey(String key) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(key)));
  }

  _showError() {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(content: Text('Something went wrong')));
  }

  _showData(int value) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text(value.toString())));
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: const Text('Sign In with Google'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String accessToken = await TokenService.getToken();
          log('[Access : $accessToken]');
          http
              .post(
                  Uri.parse(
                      "https://fcm.googleapis.com/v1/projects/notification-c2170/messages:send"),
                  headers: {
                    // 'x-goog-user-project': 'notification-c2170',
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $accessToken'
                  },
                  body: jsonEncode({
                    "message": {
                      "token":
                          "eES6tk5KRsyQegotOfm-uY:APA91bFpGEcZzYpTBLdBnBM1r7IzbBc8Zg4Z3Vc2Gv-VLqfBMJi3xcUcsJxpBa5OQu-LOiSrwo9GKy28l5m8itjphJRGoSSN-Zfdd6Ozx8Gm7H1V0kHKMcXFl3MyKEGgh9KsQPDzARuB",
                      "notification": {
                        "title":
                            "Latest Image Available for editing  as it is new trend now says Abdul Bari"
                      },
                      "android": {
                        "notification": {
                          "image":
                              ""
                        }
                      },
                    }
                  }))
              .then((http.Response value) {
            log('{Result : ${value.body}}');
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
