// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flash_anzan/widgets/send_result.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';

class Tables extends StatefulWidget {
  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  final _answerController = TextEditingController();
  late FocusNode _focusNode;

  int numDigits = 1;
  int numRows = 5;
  int timeLimit = 60; //in seconds
  String reverseTable = "false";
  int timeLeft = 0;
  double fontSize = 48.0;
  String title = "Tables";
  late Timer timer;
  var random = Random();
  Color color = Colors.white;
  bool getQuestion = true;
  bool showResult = false;
  bool resultShown = false;
  bool getValues = true;
  var displayQuestion = '';
  var elapsedTime = 0;
  var totalTime = 0;
  var minLeft = 0;
  var secLeft = 0;
  var millisPassed = 0;
  var remainingTime = "";
  var correctAns;
  int correctSums = 0;
  int incorrectSums = 0;
  int questionNum = 1;
  bool userLoggedIn = false;
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _answerController.clear();
    });
    super.initState();
    start_timer();
  }

  start_timer() async {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (totalTime <= 0) {
          timeLeft = timeLimit;
        }
        elapsedTime += 500;
        millisPassed += 100;
        if (getQuestion && showResult == false && timeLimit > 0) {
          displayQuestion = "$numDigits x $questionNum";
          correctAns = numDigits * questionNum;
          /*
          if (displayQuestion.length <= 13) {
            displayQuestion = firstNum + ' x ' + secondNum;
            fontSize = 44.0;
          } else if (displayQuestion.length > 13 &&
              displayQuestion.length <= 22) {
            displayQuestion = "  " + firstNum + '\nx ' + secondNum;
            fontSize = 40.0;
          } else {
            fontSize = 34.0;
          }*/
          //print(firstNum);
          //print(secondNum);
          //print(correctAns);
          //print(reverseTable);
          getQuestion = false;
          if (reverseTable == "false") {
            questionNum++;
            if (questionNum > numRows) {
              getQuestion = false;
              showResult = true;
            }
          }
          if (reverseTable == "true") {
            questionNum--;
            if (questionNum < 0) {
              getQuestion = false;
              showResult = true;
            }
          }
          if (questionNum % 2 == 0) {
            color = Colors.white;
          } else {
            color = Colors.yellow;
          }
          //print(questionNum);
        }

        if (elapsedTime >= 1000) {
          totalTime++;
          timeLeft--;
          minLeft = timeLeft ~/ 60;
          secLeft = timeLeft % 60;
          if (secLeft < 10) {
            remainingTime = "0$minLeft:0$secLeft";
          } else {
            remainingTime = "0$minLeft:$secLeft";
          }
          elapsedTime = 0;
        }

        if (timeLeft <= 0 || showResult) {
          showResult = false;
          minLeft = totalTime ~/ 60;
          secLeft = totalTime % 60;
          if (secLeft < 10) {
            remainingTime = "0$minLeft:0$secLeft";
          } else {
            remainingTime = "0$minLeft:$secLeft";
          }
          if (resultShown == false) {
            if (questionNum > numRows || questionNum <= 0) {
              questionNum = numRows;
            }
            int point = calculatePoints(
                numDigits, numRows, questionNum, reverseTable, totalTime);
            timeUpDialog(
                title, numDigits, numRows, questionNum, remainingTime, point);
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
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.start,
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    alertAlignment: Alignment.topCenter,
  );

  showAgeRestrictionDialog(int digit, int rows, String timeTaken,
      String dateTime, String ops, String username, int points) {
    //var percentage = ((marks / rows) * 100).toStringAsFixed(2);
    return Alert(
      context: context,
      style: alertStyle,
      title: "Result",
      desc:
          '$ops\nDate:$dateTime\nName:$username\nRows: $rows \nTable of: $digit \nTime:$timeTaken\nPoints:$points',
      // image: Image.asset("images/thanks.gif"),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pushNamed(
            context,
            "/tablesSetting",
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

  int calculatePoints(
      int digits, int rows, int rowsCompleted, String reverse, int timeTaken) {
    int points = 0;
    points += ((digits / 10) * 2).toInt() + (rows ~/ 10);
    if (reverse == "true") {
      points += 5;
    }

    int sumPerSecs = timeTaken ~/ rowsCompleted;
    points += ((1 / sumPerSecs) * 20).toInt();
    //print('$digits,$rows,$rowsCompleted,$timeTaken,$points,$reverse');
    return points;
  }

  timeUpDialog(String ops, int digits, int rows, int rowsCompleted, String time,
      int point) async {
    String currentPhoneDate =
        DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now());
    int r = 0;
    if (ops == "Tables") {
      r = 0;
    } else {
      r = 1;
    }
    String username = "Guest";
    if (userLoggedIn) {
      username = await send_result_to_firebase(
          "Tables", "$digits", rows, rowsCompleted, point, time, r);
    }
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: const Text("Time Up!!"),
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
                        const SnackBar(
                          content: Text(""),
                          //content: Text("sending data to cloud firestore"),
                        ),
                      );
                      resultShown = true;

                      showAgeRestrictionDialog(digits, rowsCompleted, time,
                          currentPhoneDate, ops, username, point);
                    },
                    child: const Text('SHOW RESULT'),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userP = userProvider.user;
    userLoggedIn = (userP?.displayName ?? '').isNotEmpty;
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    numDigits = int.parse(arguments['tableOf']);
    numRows = int.parse(arguments['rows']);
    timeLimit = int.parse(arguments['timeLimit']);
    reverseTable = arguments['reverseTable'].toString();

    if (getValues) {
      if (reverseTable == "false") {
        questionNum = 1;
        title = "Tables";
      }
      if (reverseTable == "true") {
        questionNum = numRows;
        title = "Reverse Table";
      }
      getValues = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    //height: 100.0,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 50),
                    margin: const EdgeInsets.only(
                        bottom: 6.0), //Same as `blurRadius` i guess
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/the-learners-hub-abacus-quiz.appspot.com/o/blackboard2.jpg?alt=media&token=d595ab85-2944-4632-81cd-30f7ac2b268f"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.black,
                      boxShadow: const [
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
                          title,
                          style: const TextStyle(
                            fontFamily: 'Itim',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                ),
                                Text(
                                  remainingTime,
                                  style: const TextStyle(
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
                        //SizedBox(height: 30),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              displayQuestion,
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: color,
                              ),
                            ),
                            Text(
                              " = ",
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "$correctAns",
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: color,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        /*
                  Padding(
                    padding: const EdgeInsets.fromLTRB(52, 0, 52, 0),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _answerController,
                      keyboardType: TextInputType.number,
                      //obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Itim',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                          hintText: 'Enter answer',
                          labelText: 'Answer',
                          errorText: textBoxEmpty ? 'Enter answer' : null,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Itim',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Itim',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          //filled: true,
                          //fillColor: Colors.blue.shade300,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ),
                  */
                        const SizedBox(height: 10),
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
                                padding: const EdgeInsets.fromLTRB(
                                    52.0, 12.0, 52.0, 12.0),
                              ),
                              onPressed: () {
                                /* validateTextField(_answerController.text);
                          _answerController.clear();
                          FocusScope.of(context).requestFocus(FocusNode());*/
                                getQuestion = true;
                              },
                              child: const Text(
                                'Next Question',
                                style: TextStyle(
                                  fontFamily: 'Itim',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 6.0, 0.0, 10.0),
                    child: Visibility(
                      //visible: isVisible,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange, // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.fromLTRB(52.0, 12.0, 52.0, 12.0),
                        ),
                        onPressed: () {
                          // validateTextField(_answerController.text);
                          //_answerController.clear();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Text(
                          'Replay',
                          style: TextStyle(
                            fontFamily: 'Itim',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),*/
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
