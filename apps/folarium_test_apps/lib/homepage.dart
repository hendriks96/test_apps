import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:folarium_test_apps/api/api_client.dart';
import 'package:folarium_test_apps/helper/preference_helper.dart';
import 'package:folarium_test_apps/models/response_biodata.dart';
import 'package:folarium_test_apps/my_profile.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFirstOpen = true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel? channel;

  Future<ResponseBiodata?>? loadData;

  @override
  void initState() {
    initializeDateFormatting();
    initUser();
    super.initState();
    initFirebase();
  }

  initUser() async {
    await PreferenceHelper.getFirstOpen().then((isFirst) {
      setState(() {
        isFirstOpen = isFirst;
      });

      if (!isFirst) {
        loadData = loadUsers();
      }
    });
  }

  Future<ResponseBiodata?> loadUsers() async {
    int userId = await PreferenceHelper.getUserId();
    return await ApiClient.biodata(parameters: {'id': userId});
  }

  initFirebase() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    FirebaseMessaging.instance.getInitialMessage().then(
          (RemoteMessage? message) {},
        );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id,
            channel!.name,
            channelDescription: channel!.description,
            icon: 'launch_background',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isFirstOpen
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/no-data.png',
                  ),
                  Text(
                      "Belum memiliki data, silahkan isi form terlebih dahulu"),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => MyProfile(),
                          ),
                        )
                            .then((value) {
                          if (value != null) {
                            initUser();
                          }
                        });
                      },
                      child: Text("Lengkapi profile"),
                    ),
                  )
                ],
              )
            : FutureBuilder<ResponseBiodata?>(
                future: loadData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String formattedDate =
                        DateFormat("dd MMMM yyyy", 'id').format(
                      DateTime.parse(
                          snapshot.data!.data!.dateOfBirth.toString()),
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 4,
                          child: OptimizedCacheImage(
                            imageUrl: snapshot.data!.data!.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, stackTrace) {
                              return Image.asset('assets/images/no-data.png');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Hello ${snapshot.data!.data!.fullName}, welcome back in apps, your gender is ${snapshot.data!.data!.gender} and date of birth is $formattedDate. Your location in ${snapshot.data!.data!.currentLocation}.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                          ),
                        ),

                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.of(context).push(MaterialPageRoute(
                        //           builder: (context) => MyProfile()));
                        //     },
                        //     child: Text("View Token"),
                        //   ),
                        // )
                      ],
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
      ),
    );
  }
}
