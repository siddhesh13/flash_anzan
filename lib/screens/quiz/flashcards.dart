import 'dart:async';
import 'dart:math';

import 'package:flash_anzan/screens/quiz/databaseManager.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

class Flashcard extends StatefulWidget {
  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  final _answerController = TextEditingController();
  late FocusNode _focusNode;
  String rootSign = String.fromCharCode(0x221A);
  late Timer timer;
  var random = Random();
  int randNumber = 0;
  int minNumber = 1;
  int maxNumber = 2;
  //int numDigits = 3;
  int minm = 0;
  int maxm = 10;
  int numRows = 10;
  int timeLimit = 30; //in seconds
  int timeLeft = 0;
  var displayQuestion = '';
  double fontSize = 48.0;

  Color color = Colors.white;
  var title = 'Flashcard';
  String quizOverMsg = "Quiz Over";
  bool getQuestion = true;
  bool showResult = false;
  bool resultShown = false;
  bool showKeyboard = false;
  var elapsedTime = 0;
  var totalTime = 0;
  var minLeft = 0;
  var secLeft = 0;
  var millisPassed = 0;
  var remainingTime = "";
  var correctAns;
  int correctSums = 0;
  int incorrectSums = 0;
  int questionNum = 0;
  bool getUrls = true;
  String img = '';
  String result = '';
  List<String> imgUrls = [];
  int cardCount = 0;
  bool _loading = false;

  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _answerController.clear();
    });
    super.initState();

    Timer.run(() async {
      if (getUrls) {
        if (minm <= 0) minm = 1;
        if (maxm > 10000) maxm = 9999;
        for (int i = minm; i < maxm; i++) {
          //randNumber = random.nextInt(7);
          String? urlImageApi = await FireStoreDataBase().getData(i.toString());
          if (urlImageApi != null) {
            setState(() {
              result = urlImageApi;
              imgUrls.add(result);
            });
          }
          getUrls = false;
          //print("image url: ");
          //print(result);
        }
      }
    });
    if (mounted) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  startTimer() async {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (totalTime <= 0) {
          timeLeft = timeLimit;
        }
        if (img == "")
          _loading = false;
        else
          _loading = true;
        elapsedTime += 500;
        if (getQuestion && showResult == false && elapsedTime > 900) {
          //minNumber = int.parse((pow(10, numDigits - 1)).toString());
          //maxNumber = int.parse((pow(10, numDigits)).toString());
          //randNumber = (minNumber + random.nextInt(maxNumber - minNumber));
          randNumber = random.nextInt(imgUrls.length);
          //print(imgUrls.length);
          //print(randNumber);
          //print("----------");
          img = imgUrls[randNumber];

          //print(imgUrls);
          //print("image url: ");
          //print(img);
          correctAns = 1 + randNumber;
          cardCount += 1;
          //print(correctAns);
          getQuestion = false;
          // questionNum++;
          // if (questionNum > numRows) {
          //   getQuestion = false;
          //   showResult = true;
          // }
        }

        if (elapsedTime >= 1000 && timeLeft >= 0) {
          totalTime++;
          timeLeft--;
          //print(totalTime);
          minLeft = timeLeft ~/ 60;
          secLeft = timeLeft % 60;
          if (secLeft < 10) {
            remainingTime = "0" + "$minLeft" + ":0" + "$secLeft";
          } else {
            remainingTime = "0" + "$minLeft" + ":" + "$secLeft";
          }
          elapsedTime = 0;
        }

        if (timeLeft <= 0 || showResult) {
          if (timeLeft <= 0) quizOverMsg = "Time Up!!";
          if (showResult) quizOverMsg = "Well Done";
          showResult = false;
          minLeft = totalTime ~/ 60;
          secLeft = totalTime % 60;
          if (secLeft < 10) {
            remainingTime = "0" + "$minLeft" + ":0" + "$secLeft";
          } else {
            remainingTime = "0" + "$minLeft" + ":" + "$secLeft";
          }
          if (resultShown == false) {
            timeUpDialog(title, cardCount, correctSums, incorrectSums, minm,
                maxm, remainingTime, 0);
          }
          timer.cancel();
        }
        //int rows, int marks, String first, String second, String time, int accuracy
      });
    });
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.start,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    alertAlignment: Alignment.topCenter,
  );

  showAgeRestrictionDialog(int rows, int minD, int maxD, String timeTaken,
      String dateTime, String ops) {
    //var percentage = ((marks / rows) * 100).toStringAsFixed(2);
    //String length = first.length.toString() + "x" + second.length.toString();
    return Alert(
      context: context,
      style: alertStyle,
      title: "Result",
      desc:
          '$ops\nDate:$dateTime\nTotal Cards: $cardCount\nTime:$timeTaken \nRange: $minD-$maxD',
      // image: Image.asset("images/thanks.gif"),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pushNamed(
            context,
            "/flashcardSetting",
          ),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: const Text(
            "CLOSE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  timeUpDialog(String ops, int rows, int marks, int incorrect, int minD,
      int maxD, String time, int accuracy) {
    String currentPhoneDate =
        DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now());

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text("$quizOverMsg"),
                //content: const Text('AlertDialog description'),
                actions: <Widget>[
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        Image.network(
                          "https://thumbs.gfycat.com/VariablePoliticalBurro.webp",
                          scale: 0.5,
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    ""), //("sending data to cloud firestore"),
                              ),
                            );
                            resultShown = true;

                            showAgeRestrictionDialog(
                                rows, minD, maxD, time, currentPhoneDate, ops);
                          },
                          child: const Text('SHOW RESULT'),
                        ),
                      ],
                    ),
                  ),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments != null) {
      minm = int.parse(arguments['minm']);
      maxm = int.parse(arguments['maxm']);
      timeLimit = int.parse(arguments['timeLimit']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('The Learners Hub'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    //height: 100.0,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                    margin: const EdgeInsets.only(
                        bottom: 6.0), //Same as `blurRadius` i guess
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/the-learners-hub-abacus-quiz.appspot.com/o/blackboard2.jpg?alt=media&token=d595ab85-2944-4632-81cd-30f7ac2b268f"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        Text(
                          "$title",
                          style: TextStyle(
                            fontFamily: 'Itim',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.blue,
                          ),
                        ),
                        //SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                Text(
                                  "$remainingTime",
                                  style: TextStyle(
                                    fontFamily: 'Itim',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        // SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: unnecessary_new
                            new Container(
                                child: _loading
                                    ? Image.network(img,
                                        //'https://firebasestorage.googleapis.com/v0/b/the-learners-hub-abacus-quiz.appspot.com/o/flashcards%2F1.jpg?alt=media&token=29c953fe-c226-4d2a-bfe2-8ab2aeeaf9d8',
                                        height: 200.0,
                                        fit: BoxFit.cover, loadingBuilder:
                                            (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      })
                                    : CircularProgressIndicator()),
                          ],
                        ),
                        SizedBox(height: 10),

                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(4.0, 6.0, 0.0, 10.0),
                          child: Visibility(
                            //visible: isVisible,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange, // background
                                onPrimary: Colors.white, // foreground
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(4)),
                                padding:
                                    EdgeInsets.fromLTRB(52.0, 12.0, 52.0, 12.0),
                              ),
                              onPressed: () {
                                getQuestion = true;
                              },
                              child: const Text(
                                'Next Card',
                                style: TextStyle(
                                  fontFamily: 'Itim',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
