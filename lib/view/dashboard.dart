import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smile_quiz/resources/constants/appcolors.dart';
import 'package:smile_quiz/resources/constants/constants.dart';
import 'package:smile_quiz/resources/constants/textStyle.dart';
import 'package:smile_quiz/view/quizPage.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';
import '../utilities/route/routes_name.dart';
import '../view_model/services/firebase_abstract.dart';
import '../view_model/services/firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  final double _buttonGap = 8; // widget spacing gap
  var _quizMode = false; // quiz mode selection (hard or easy)
  final bool _isVerified = Auth()
      .currentUser!
      .emailVerified; // storing verified and non-verified users in variable
  List _scoreData = []; // is user's email verified or not

  @override
  void initState() {
    // log(Auth().currentUser.toString(), name: "User Authentication : ");
    // adding observer to widgetBinding on page initialization
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // removing widgetbinding instance on page disposal
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      // when the application in paused
      case AppLifecycleState.paused:
        _startTimer();
        debugPrint(
            "application paused"); // printing application paused only in debug mode
        break;
      // performing actions on application resumed or on warm boot
      case AppLifecycleState.resumed:
        _cancelTimer();
        _resetTimer(AppConstant.sessionTimer);
        debugPrint("application resumed");
        break;
      // when the application is inactive
      case AppLifecycleState.inactive:
        break;
      // when the application is detached from running state
      case AppLifecycleState.detached:
        break;
    }
    // notify observer on state change
    super.didChangeAppLifecycleState(state);
  }

  // creating instance of timer abstract class
  Timer? _timer;
  // timer left for the session expiry
  int timeLeft = AppConstant.sessionTimer;

  // start timer method
  void _startTimer() {
    // setting the timer frequency
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // if this page is still mounted to widget tree then proceed
      if (timeLeft > 0) {
        // if the timeleft is more than 0 continue deducting 1 at a time
        timeLeft--;
        debugPrint(timeLeft.toString());
      } else {
        // timeleft has over then perform cancel timer
        _cancelTimer();
        // alert the user that session has expired
        alertDialogSession(context);
      }
    });
  }

  // reset timer
  void _resetTimer(int timeAvailable) {
    timeLeft = timeAvailable;
  }

  // cancel timer
  void _cancelTimer() {
    _timer?.cancel();
  }

  // stream path to remote repository
  final Stream _userStream = FirebaseFirestore.instance
      .collection("Users")
      .doc(Auth().currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // available height from the available device
    var height = MediaQuery.of(context).size.height;
    // creating object of CloudStore from abstract class firebaseBase
    FirebaseBase obj = CloudStore();
    return Scaffold(
      appBar: AppBar(
        // initializing constant app theme color
        backgroundColor: AppColors.appBar_theme,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // evelated button
            child: ElevatedButton(
                // stylying button
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.app_background,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  // google signout
                  GoogleSignIn().signOut();
                  // auth signout
                  Auth().signOut();
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.black),
                )),
          ),
        ],
      ),
      // creating a stream for user data,game score data, and email verification data
      drawer: StreamBuilder(
          stream: _userStream,
          builder: (context, snapshot) {
            _scoreData = [];
            if (snapshot.hasData) {
              var data = snapshot.data;
              // addint snapshot data into a list
              _scoreData.add(data);

              // get the snapshot data of user
              return Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: Column(
                    // Important: Remove any padding from the ListView.
                    children: [
                      Container(
                          height: height * 0.38,
                          // decoraiting container
                          decoration: const BoxDecoration(
                              // adding gradient
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromARGB(255, 21, 43, 247),
                                Color.fromARGB(255, 87, 104, 255),
                                Color.fromARGB(255, 147, 157, 251),
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 255, 255, 255),
                              ])),
                          child: Center(
                            child: Column(
                                // setting column alignment axis
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      // adding circle avatar at bottom of the stack
                                      CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage(
                                          Auth().currentUser?.photoURL ??
                                              "https://th.bing.com/th/id/OIP.7jKcNNIq8rQLPZqRym9qvwHaIN?pid=ImgDet&rs=1",
                                        ),
                                      ),
                                      // if user is verfied add blue verified icon on top of profile image
                                      _isVerified
                                          ? const Positioned(
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.white,
                                                // verified icon
                                                child: Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            )
                                          // if not verified adding nothing on top of profile image
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                    ),
                                    // displaying user name from stream
                                    child: Text(
                                      Auth().currentUser?.displayName ??
                                          "${data['name']}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),
                                ]),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          // setting row axis
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              // setting axis
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  " Quiz \nMode      ",
                                  style: AppTextStyle.normal,
                                ),
                                Text(
                                  "Easy",
                                  style: AppTextStyle.normal,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  // adding a switch to be toggled
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: Switch(
                                      value: _quizMode,
                                      onChanged: (value) {
                                        setState(() {
                                          _quizMode = !_quizMode;
                                        });
                                      },
                                      // toggle color
                                      activeColor: const Color.fromARGB(
                                          255, 255, 62, 48),
                                      activeTrackColor: const Color.fromARGB(
                                          255, 255, 197, 203),
                                      inactiveTrackColor: const Color.fromARGB(
                                          255, 172, 255, 203),
                                      inactiveThumbColor: const Color.fromARGB(
                                          255, 54, 255, 60),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Hard",
                                  style: AppTextStyle.normal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // adding list tile
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              'Total Score:    ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            // adding asset image in container
                            Container(
                              height: 25,
                              width: 25,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/pictures/star.png'))),
                            ),
                            // displaying user's total score from stream
                            Text(
                              '  ${data['TotalScore']}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email Verification :',
                                  style: AppTextStyle.normal,
                                ),
                                !_isVerified
                                    ? Center(
                                        child: ElevatedButton(
                                            // styling elevated button
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.app_background,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50))),
                                            onPressed: () {
                                              // sending email verfication on button tapped
                                              obj.sendEmailVerfication();
                                            },
                                            child: const Text(
                                              "Send Verfication  Email",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      )
                                    : Row(
                                        children: const [
                                          Text(
                                            "Verified",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      ListTile(
                        title: Column(
                          // displaying last loged in date
                          children: [
                            const Text("Last Signed In"),
                            Text(Auth()
                                .currentUser!
                                .metadata
                                .lastSignInTime
                                .toString()),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ]),
              );
            } else {
              // snapshot does not have data show loading progress bar
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      body: Container(
          // taking all available space
          width: double.infinity,
          height: double.infinity,
          color: AppColors.app_background,
          child: SafeArea(
            child: Column(children: [
              const Spacer(
                flex: 1,
              ),
              // addign a constant image in container
              Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/pictures/getSmarter.png'))),
              ),
              const Spacer(
                flex: 1,
              ),

              // testing button
              // ElevatedButton(
              //     onPressed: () {
              //       FirebaseCrashlytics.instance.crash();
              //     },
              //     child: Text('Test Crash')),

              // play game button created and function assigned
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      // adding decoration
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: const Color.fromARGB(255, 250, 168, 168),
                            style: BorderStyle.solid,
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 61, 41, 215),
                                Color.fromARGB(255, 83, 119, 248),
                                Color.fromARGB(255, 176, 239, 255)
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter)),
                    )),

                    // button text styling
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(13)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            //  returning quiz page with the requied parameters
                            return QuizPage(
                              timeAvailable:
                                  _quizMode // quiz time based on quiz mode selected
                                      ? AppConstant.hardModeTimer
                                      : AppConstant.easyModeTimer,
                              gameMode: _quizMode, // quiz mode bool value
                            );
                          }));
                        },
                        child: const Text(
                          "Play Game",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              // adding space
              SizedBox(
                height: _buttonGap,
              ),

              // leadership board button created and function assigned
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: const Color.fromARGB(255, 250, 168, 168),
                            style: BorderStyle.solid,
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 61, 41, 215),
                                Color.fromARGB(255, 83, 119, 248),
                                Color.fromARGB(255, 176, 239, 255)
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter)),
                    )),
                    // button text styling
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(13)),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RoutesName.leadershipBoard);
                        },
                        child: const Text(
                          "LearderShip Board",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              // spacing
              SizedBox(
                height: _buttonGap,
              ),
              // text help button and function assigned
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                // staking widget on top of each other
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3.0,
                            color: const Color.fromARGB(255, 250, 168, 168),
                            style: BorderStyle.solid,
                          ),
                          // gradient type and gradient colors to use
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 61, 41, 215),
                                Color.fromARGB(255, 83, 119, 248),
                                Color.fromARGB(255, 176, 239, 255)
                              ],
                              // gradient styling
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter)),
                    )),
                    // text button styling
                    TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(13)),
                        onPressed: () {
                          // routing to help page screen
                          Navigator.pushNamed(context, RoutesName.helpScreen);
                        },
                        child: const Text(
                          "Help",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: _buttonGap,
              ),
            ]),
          )),
    );
  }

  // alert dialog display widget
  Future<dynamic> alertDialogSession(BuildContext context) {
    return showDialog(
        barrierDismissible: false, // disable dialog dismiss on outside touch
        context: context,
        builder: (context) => AlertDialog(
              // alert dialog to notify user
              backgroundColor: const Color.fromARGB(255, 246, 199, 60),
              title: const Text('Session Expired'), // constant value added
              content: const Text('Please, Login again'),
              actions: [
                TextButton(
                    onPressed: () {
                      // logging user out on tap
                      Auth().signOut();
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }
}
