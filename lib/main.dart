import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:wears/heart_rate.dart';
import 'package:wears/login_screens.dart';
import 'package:wears/provider/user_provider.dart';
import 'package:workout/workout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// /// SharedPreferences data key.
// const EVENTS_KEY = "fetch_events";

// /// This "Headless Task" is run when app is terminated.
// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   var taskId = task.taskId;
//   var timeout = task.timeout;
//   if (timeout) {
//     print("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }

//   print("[BackgroundFetch] Headless event received: $taskId");

//   var timestamp = DateTime.now();

//   var prefs = await SharedPreferences.getInstance();

//   // Read fetch_events from SharedPreferences
//   var events = <String>[];
//   var json = prefs.getString(EVENTS_KEY);
//   if (json != null) {
//     events = jsonDecode(json).cast<String>();
//   }
//   // Add new event.
//   events.insert(0, "$taskId@$timestamp [Headless]");
//   // Persist fetch events in SharedPreferences
//   prefs.setString(EVENTS_KEY, jsonEncode(events));

//   if (taskId == 'flutter_background_fetch') {
//     BackgroundFetch.scheduleTask(TaskConfig(
//         taskId: "com.transistorsoft.customtask",
//         delay: 5000,
//         periodic: false,
//         forceAlarmManager: false,
//         stopOnTerminate: false,
//         enableHeadless: true
//     ));
//   }
//   BackgroundFetch.finish(taskId);
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

   //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //  bool _enabled = true;
  // int _status = 0;
  // List<String> _events = [];

  //   @override
  // void initState() {
  //   super.initState();
  //   _onClickEnable();
  //   initPlatformState();
  // }


  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Load persisted fetch events from SharedPreferences
  //   var prefs = await SharedPreferences.getInstance();
  //   var json = prefs.getString(EVENTS_KEY);
  //   if (json != null) {
  //     setState(() {
  //       _events = jsonDecode(json).cast<String>();
  //     });
  //   }

  //   // Configure BackgroundFetch.
  //   try {
  //     var status = await BackgroundFetch.configure(BackgroundFetchConfig(
  //       minimumFetchInterval: 15,
  //       forceAlarmManager: false,
  //       stopOnTerminate: false,
  //       startOnBoot: true,
  //       enableHeadless: true,
  //       requiresBatteryNotLow: false,
  //       requiresCharging: false,
  //       requiresStorageNotLow: false,
  //       requiresDeviceIdle: false,
  //       requiredNetworkType: NetworkType.NONE
  //     ), _onBackgroundFetch, _onBackgroundFetchTimeout);
  //     print('[BackgroundFetch] configure success: $status');
  //     setState(() {
  //       _status = status;
  //     });

  //     // Schedule a "one-shot" custom-task in 10000ms.
  //     // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
  //     // where device must be powered (and delay will be throttled by the OS).
  //     BackgroundFetch.scheduleTask(TaskConfig(
  //         taskId: "com.transistorsoft.customtask",
  //         delay: 10000,
  //         periodic: false,
  //         forceAlarmManager: true,
  //         stopOnTerminate: false,
  //         enableHeadless: true
  //     ));
  //   } on Exception catch(e) {
  //     print("[BackgroundFetch] configure ERROR: $e");
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }

  // void _onBackgroundFetch(String taskId) async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var timestamp = DateTime.now();
  //   // This is the fetch-event callback.
  //   print("[BackgroundFetch] Event received: $taskId");
  //   setState(() {
  //     _events.insert(0, "$taskId@${timestamp.toString()}");
  //   });
  //   // Persist fetch events in SharedPreferences
  //   prefs.setString(EVENTS_KEY, jsonEncode(_events));

  //   if (taskId == "flutter_background_fetch") {
  //     // Perform an example HTTP request.
  //     var url = Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
  //       var itemCount = jsonResponse['totalItems'];
  //       print('Number of books about http: $itemCount.');
  //     } else {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   }
  //   // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  //   // for taking too long in the background.
  //   BackgroundFetch.finish(taskId);
  // }

  // /// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
  // void _onBackgroundFetchTimeout(String taskId) {
  //   print("[BackgroundFetch] TIMEOUT: $taskId");
  //   BackgroundFetch.finish(taskId);
  // }

  // void _onClickEnable() {
    
  //   if (_enabled) {
  //     BackgroundFetch.start().then((status) {
  //       print('[BackgroundFetch] start success: $status');
  //     }).catchError((e) {
  //       print('[BackgroundFetch] start FAILURE: $e');
  //     });
  //   } else {
  //     BackgroundFetch.stop().then((status) {
  //       print('[BackgroundFetch] stop success: $status');
  //     });
  //   }
  // }



















  // This widget is the root of your application.
  final workout = Workout();

  final exerciseType = ExerciseType.walking;
  final features = [
    WorkoutFeature.heartRate,
    WorkoutFeature.calories,
    WorkoutFeature.steps,
    WorkoutFeature.distance,
    WorkoutFeature.speed,
  ];
  final enableGps = true;

  double heartRate = 0;
  double calories = 0;
  double steps = 0;
  double distance = 0;
  double speed = 0;
  bool started = false;

  _MyAppState() {
    workout.stream.listen((event) {
      // ignore: avoid_print
      print('${event.feature}: ${event.value} (${event.timestamp})');
      switch (event.feature) {
        case WorkoutFeature.unknown:
          return;
        case WorkoutFeature.heartRate:
          setState(() {
            heartRate = event.value;
          });
          break;
        case WorkoutFeature.calories:
          setState(() {
            calories = event.value;
          });
          break;
        case WorkoutFeature.steps:
          setState(() {
            steps = event.value;
          });
          break;
        case WorkoutFeature.distance:
          setState(() {
            distance = event.value;
          });
          break;
        case WorkoutFeature.speed:
          setState(() {
            speed = event.value;
          });
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Ujikompetensi',
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const HeartRate();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return LoginScreens();
          },
        ),
      ),
    );
  }
}
