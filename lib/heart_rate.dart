import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uuid/uuid.dart';
import 'package:wear/wear.dart';

import 'package:wears/login_screens.dart';
import 'package:workout/workout.dart';
import 'package:intl/intl.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key});

  @override
  State<HeartRate> createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  Timer? timer;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => checkForNewSharedLists());
         timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => UploadCalPagi());
         timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => UploadCalSiang());
         timer = Timer.periodic(
        Duration(seconds: 1), (Timer t) => UploadCalMalam());
       print(DateFormat.jm().format(DateTime.now()));
    toggleExerciseState();
    if (DateFormat.jm().format(DateTime.now()) == "11:55 PM") {
      started = false;
    } else if (DateFormat.jm().format(DateTime.now()) == "11:58 PM") {
      started = true;
    }

    super.initState();
  }

  void checkForNewSharedLists() async {
    await FirebaseFirestore.instance
        .collection('akun')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'heartRate': heartRate, 'kalori': calories});
  }

    void UploadCalPagi()  {
       if (DateFormat.jm().format(DateTime.now()) == "09:30 PM"){
         FirebaseFirestore.instance
        .collection('akun')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'kaloriPagi': calories.toStringAsFixed(0)});
       }
    
  }
   void UploadCalSiang()  {
       if (DateFormat.jm().format(DateTime.now()) == "12:00 PM"){
         FirebaseFirestore.instance
        .collection('akun')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'kaloriSiang': calories.toStringAsFixed(0)});
       }
    
  }

   void UploadCalMalam()  {
        if (DateFormat.jm().format(DateTime.now()) == "08:00 PM"){
         FirebaseFirestore.instance
        .collection('akun')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'kaloriMalam': calories.toStringAsFixed(0)});
       }
    
  }


  void defaultKal()async{
     if (DateFormat.jm().format(DateTime.now()) == "11:50 PM"){
        await FirebaseFirestore.instance
        .collection('akun')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'kaloriMalam': 0,"kaloriSiang": 0,"kaloriPagi":0});
       }
  }

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
  bool started = true;
  _HeartRateState() {
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
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        return AmbientMode(
          builder: (context, mode, child) => child!,
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      Text('Heart rate'),
                                      Text(' $heartRate'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      Text('Calories'),
                                      Text(' ${calories.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      Text('Steps'),
                                      Text(' $steps'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      Text('Speed'),
                                      Text('${speed.toStringAsFixed(2)}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            child: Column(
                              children: [
                                Text('Distance'),
                                Text('${distance.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // InkWell(
                    //   onTap: toggleExerciseState,
                    //   child: Text(started ? 'Stop' : 'Start',
                    //       style: TextStyle(
                    //           color: started ? Colors.red : Colors.green)),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async{
                        try {
                          await FirebaseAuth.instance.signOut();

                         setState(() {
                           started = false;
                         });

                          // ignore: use_build_context_synchronously

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreens(),
                          ));

                          print('Successfully logout');
                        } on FirebaseException catch (error) {
                          showSnackBar(context, "${error.message}");

                          setState(() {
                            _isLoading = false;
                          });
                        } catch (error) {
                          showSnackBar(context, "$error");

                          setState(() {
                            _isLoading = false;
                          });
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void uploadCalori() {
    DateTime tsdate = DateTime.now();
    String date = DateFormat.yMd().format(tsdate);
    String time = DateFormat.jm().format(tsdate);
    var uuid = Uuid();
    var id = uuid.v4();

    try {
      FirebaseFirestore.instance
          .collection("akun")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("calori")
          .doc(id)
          .set({'uid': id, 'date': date, 'time': time, 'calori': calories});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error"),
      ));
    }
  }

  void toggleExerciseState() async {
    if (started) {
      final supportedExerciseTypes = await workout.getSupportedExerciseTypes();
      // ignore: avoid_print
      print('Supported exercise types: ${supportedExerciseTypes.length}');

      final result = await workout.start(
        // In a real application, check the supported exercise types first
        exerciseType: exerciseType,
        features: features,
        enableGps: enableGps,
      );

      if (result.unsupportedFeatures.isNotEmpty) {
        // ignore: avoid_print
        print('Unsupported features: ${result.unsupportedFeatures}');
        // In a real application, update the UI to match
      } else {
        // ignore: avoid_print
        print('All requested features supported');
      }
    } else {
      await workout.stop();
      uploadCalori();
    }
  }
}
