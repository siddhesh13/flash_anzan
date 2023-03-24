import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_anzan/models/resultmodel.dart';
import 'package:flash_anzan/widgets/send_result.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';
//import 'package:http/http.dart' as http;
//import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart

class Multiplication extends StatefulWidget {
  static const String routeName = "/multiplicationPage";
  @override
  State<Multiplication> createState() => _MultiplicationState();
}

class _MultiplicationState extends State<Multiplication> {
  final _answerController = TextEditingController();
  late FocusNode _focusNode;

  int multipleLowerLimit = 1;
  int multipleUpperLimit = 5;
  int multiplierLowerLimit = 1;
  int multiplierUpperLimit = 5;
  var firstNum = "";
  var secondNum = "";
  int numRows = 5;
  int timeLimit = 60; //in seconds
  int timeLeft = 0;
  double fontSize = 48.0;
  late Timer timer;
  var random = new Random();
  Color color = Colors.white;
  var operation = 'long';
  var title = 'Multiplication';
  String quizOverMsg = "Quiz Over";
  bool getQuestion = true;
  bool showResult = false;
  bool resultShown = false;
  bool showKeyboard = false;
  bool hideAppbar = true;
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
  int questionNum = 0;
  bool userLoggedIn = false;
  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _answerController.clear();
    });
    super.initState();
    startTimer();
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
        elapsedTime += 500;
        millisPassed += 100;
        if (getQuestion && showResult == false && timeLimit > 0) {
          if (operation == 'multiply') {
            title = 'Multiplication';
            firstNum = (multipleLowerLimit +
                    random.nextInt(multipleUpperLimit - multipleLowerLimit))
                .toString();
          } else {
            title = 'Long Multiplication';
            if (questionNum == 0) {
              firstNum = (multipleLowerLimit +
                      random.nextInt(multipleUpperLimit - multipleLowerLimit))
                  .toString();
            } else {
              firstNum =
                  (int.parse(firstNum) * int.parse(secondNum)).toString();
              print(firstNum);
            }
          }
          // secondNum = "50";
          secondNum = (multiplierLowerLimit +
                  random.nextInt(multiplierUpperLimit - multiplierLowerLimit))
              .toString();
          correctAns = int.parse(firstNum) * int.parse(secondNum);

          displayQuestion = firstNum + ' x ' + secondNum;
          if (displayQuestion.length <= 13) {
            displayQuestion = firstNum + ' x ' + secondNum;
            fontSize = 44.0;
            hideAppbar = true;
          } else if (displayQuestion.length > 13 &&
              displayQuestion.length <= 22) {
            displayQuestion = "  " + firstNum + '\nx ' + secondNum;
            fontSize = 40.0;
            hideAppbar = false;
          } else {
            fontSize = 34.0;
            hideAppbar = false;
          }
          //print(firstNum);
          //print(secondNum);
          print(correctAns);
          getQuestion = false;
          questionNum++;
          if (questionNum > numRows) {
            getQuestion = false;
            showResult = true;
          }
          if (questionNum % 2 == 0) {
            color = Colors.white;
          } else {
            color = Colors.yellow;
          }
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
          if (timeLeft <= 0) quizOverMsg = "Time Up!!";
          if (showResult) quizOverMsg = "Well Done";
          showResult = false;
          minLeft = totalTime ~/ 60;
          secLeft = totalTime % 60;
          if (secLeft < 10) {
            remainingTime = "0$minLeft:0$secLeft";
          } else {
            remainingTime = "0$minLeft:$secLeft";
          }
          if (resultShown == false) {
            int totalPoints = calculatePoints(
                int.parse(firstNum),
                multiplierUpperLimit,
                multipleUpperLimit,
                numRows,
                correctSums,
                totalTime);
            timeUpDialog(title, numRows, correctSums, firstNum, secondNum,
                remainingTime, incorrectSums, 0, totalPoints);
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

  showAgeRestrictionDialog(
      int rows,
      int marks,
      String first,
      String second,
      String timeTaken,
      int incorrect,
      int accuracy,
      String dateTime,
      String ops,
      String username,
      int point) {
    var percentage = ((marks / rows) * 100).toStringAsFixed(2);
    String length = "${first.length}x${second.length}";
    return Alert(
      context: context,
      style: alertStyle,
      title: "Result",
      desc:
          '$ops\nDate:$dateTime \nName:$username\nSums: $rows \nDigits: $length \nCorrect: $marks/$rows\nAccuracy: $percentage% \nTime:$timeTaken\nPoints:$point',
      // image: Image.asset("images/thanks.gif"),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pushNamed(context, '/multSetting',
              arguments: <String, String>{
                'operation': operation,
              }),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: const Text(
            "CLOSE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  int calculatePoints(int fNum, int sNum, int fLimit, int totalQuestions,
      int correctSums, int timeTaken) {
    int points = 0;
    if (operation == 'multiply') {
      fNum = (fLimit - 1).toString().length;
    } else {
      fNum = fNum.toString().length;
    }
    sNum = (sNum - 1).toString().length;
    points += (((fNum + sNum) / 2) * ((fNum + sNum) / 2)).toInt() * correctSums;
    if (correctSums > 0) {
      int sumPerSecs = timeTaken ~/ correctSums;
      points += ((1 / sumPerSecs) * 100).toInt();
    }
    if (totalQuestions == correctSums && totalQuestions >= 5) {
      points += ((totalQuestions / 3) * 5).toInt();
    }
    //print('$fNum,$sNum,$totalQuestions,$correctSums,$timeTaken,$points');
    return points;
  }

  timeUpDialog(String ops, int rows, int marks, String first, String second,
      String time, int incorrect, int accuracy, int point) async {
    String currentPhoneDate =
        DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now());
    String username = "Guest";
    if (userLoggedIn) {
      username = await send_result_to_firebase(
          title,
          "${first.length}x${second.length}",
          numRows,
          marks,
          point,
          time,
          numRows);
    }
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(title: Text(quizOverMsg),
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
                                content:
                                    Text("sending data to cloud firestore"),
                              ),
                            );
                            resultShown = true;

                            showAgeRestrictionDialog(
                                rows,
                                marks,
                                first,
                                second,
                                time,
                                incorrect,
                                accuracy,
                                currentPhoneDate,
                                ops,
                                username,
                                point);
                          },
                          child: const Text('SHOW RESULT'),
                        ),
                      ],
                    ),
                  ),
                ]));
  }

  bool answerValidate = false;
  bool textBoxEmpty = false;
  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        textBoxEmpty = true;
      });

      return false;
      // ignore: unrelated_type_equality_checks
    } else if (correctAns.toString() == userInput) {
      setState(() {
        answerValidate = true;
        textBoxEmpty = false;
        correctSums += 1;
        getQuestion = true;
        //print('right answer');
      });
    } else if (correctAns.toString() != userInput) {
      setState(() {
        answerValidate = false;
        textBoxEmpty = false;
        incorrectSums += 1;
        getQuestion = true;
        //print('wrong answer');
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userP = userProvider.user;
    userLoggedIn = (userP?.displayName ?? '').isNotEmpty;
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    multipleLowerLimit = int.parse(arguments['firstNumLower']);
    multipleUpperLimit = int.parse(arguments['firstNumUpper']);
    multiplierLowerLimit = int.parse(arguments['secondNumLower']);
    multiplierUpperLimit = int.parse(arguments['secondNumUpper']);
    numRows = int.parse(arguments['rows']);
    timeLimit = int.parse(arguments['timeLimit']);
    operation = arguments['operation'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplication'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        //height: 100.0,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
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
                                color: Colors.blue,
                              ),
                            ),
                            //SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Correct:",
                                          style: TextStyle(
                                            fontFamily: 'Itim',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "$correctSums",
                                          style: const TextStyle(
                                            fontFamily: 'Itim',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Inorrect:",
                                          style: TextStyle(
                                            fontFamily: 'Itim',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "$incorrectSums",
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
                                const SizedBox(width: 60),
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

                            Row(
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
                                /* Text(
                          " x ",
                          style: TextStyle(
                            fontFamily: 'Itim',
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "123456789",
                          style: TextStyle(
                            fontFamily: 'Itim',
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: color,
                          ),
                        )*/
                              ],
                            ),
                            //SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(52, 0, 52, 0),
                              child: TextFormField(
                                focusNode: _focusNode,
                                autofocus: showKeyboard,
                                controller: _answerController,
                                keyboardType: TextInputType.number,
                                //obscureText: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Itim',
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                    hintText: 'Enter answer',
                                    labelText: 'Answer',
                                    errorText:
                                        textBoxEmpty ? 'Enter answer' : null,
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Itim',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Itim',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    //filled: true,
                                    //fillColor: Colors.blue.shade300,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                              ),
                            ),
                            // SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 6.0, 0.0, 10.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepOrange, // background
                                  onPrimary: Colors.white, // foreground
                                  shape: RoundedRectangleBorder(
                                      //to set border radius to button
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: const EdgeInsets.fromLTRB(
                                      52.0, 14.0, 52.0, 14.0),
                                ),
                                onPressed: () {
                                  validateTextField(_answerController.text);
                                  showKeyboard = true;
                                  _answerController.clear();
                                  //FocusScope.of(context).requestFocus(FocusNode());
                                  _focusNode.requestFocus();
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
