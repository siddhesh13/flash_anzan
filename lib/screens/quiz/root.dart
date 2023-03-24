import 'package:flash_anzan/widgets/send_result.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';

class Root extends StatefulWidget {
  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final _answerController = TextEditingController();
  late FocusNode _focusNode;
  String rootSign = String.fromCharCode(0x221A);
  int randNumber = 1;
  int minNumber = 1;
  int maxNumber = 2;
  int numDigits = 9;
  int numRows = 5;
  int timeLimit = 120; //in seconds
  int timeLeft = 0;
  var displayQuestion = '';
  double fontSize = 48.0;
  late Timer timer;
  var random = Random();
  Color color = Colors.white;
  var operation = 'Square Root';
  var title = 'Square Root';
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
        if (getQuestion && showResult == false && timeLimit > 0) {
          if (operation == 'Cube Root') {
            title = "Cube Root";
            if (numDigits > 7) {
              numDigits = 7;
            }
          }
          minNumber = int.parse((pow(10, numDigits - 1)).toString());
          maxNumber = int.parse((pow(10, numDigits)).toString());
          randNumber = (minNumber + random.nextInt(maxNumber - minNumber));
          correctAns = randNumber;
          if (operation == 'Square Root') {
            title = 'Square Root';
            displayQuestion = rootSign + pow(randNumber, 2).toString();
          } else {
            if (operation == 'Cube Root') {
              title = 'Cube Root';
              //double root = pow(randNumber, 3);
              displayQuestion = "3" + rootSign + pow(randNumber, 3).toString();
            }
          }
          if (displayQuestion.length <= 10) {
            //displayQuestion = divisor + " " + divideSign + " " + divider;
            fontSize = 40.0;
          } else if (displayQuestion.length > 10 &&
              displayQuestion.length <= 14) {
            fontSize = 32.0;
          } else if (displayQuestion.length > 14 &&
              displayQuestion.length <= 18) {
            fontSize = 28.0;
          } else {
            fontSize = 24.0;
          }
          print(displayQuestion);
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

        if (elapsedTime >= 1000 && timeLeft >= 0) {
          totalTime++;
          timeLeft--;
          //print(totalTime);
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
            int points = calculatePoints(
                numDigits, numRows, correctSums, totalTime, title);
            timeUpDialog(title, numRows, correctSums, incorrectSums, numDigits,
                remainingTime, 0, points);
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
      int incorrect,
      int digits,
      String timeTaken,
      int accuracy,
      String dateTime,
      String ops,
      String username,
      int point) {
    var percentage = ((marks / rows) * 100).toStringAsFixed(2);
    //String length = first.length.toString() + "x" + second.length.toString();

    return Alert(
      context: context,
      style: alertStyle,
      title: "Result",
      desc:
          '$ops\nDate:$dateTime\nName:$username\nRows: $rows \nDigits: $digits \nCorrect:$marks\nIncorrect:$incorrect\nAccuracy: $percentage% \nTime:$timeTaken\nPoints:$point',
      // image: Image.asset("images/thanks.gif"),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pushNamed(context, '/rootSetting',
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

  int calculatePoints(int digits, int totalQuestions, int correctSums,
      int timeTaken, String ops) {
    int points = 0;
    int multiplier = 1;
    if (ops == "Square Root") {
      multiplier = 5;
    } else {
      multiplier = 15;
    }
    points += (digits * multiplier) * correctSums;
    if (correctSums > 0) {
      int sumPerSecs = timeTaken ~/ correctSums;
      points += ((1 / sumPerSecs) * 100).toInt();
    }
    if (totalQuestions == correctSums && totalQuestions >= 5) {
      points += ((totalQuestions / 3) * 5).toInt();
    }
    //print('$digits,$rows,$rowsCompleted,$timeTaken,$points,$reverse');
    return points;
  }

  timeUpDialog(String ops, int rows, int marks, int incorrect, int digits,
      String time, int accuracy, int point) async {
    String currentPhoneDate =
        DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now());
    String username = "Guest";
    if (userLoggedIn) {
      username = await send_result_to_firebase(
          ops, "$digits", rows, marks, point, time, rows);
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
                                content: Text(
                                    ""), //("sending data to cloud firestore"),
                              ),
                            );
                            resultShown = true;

                            showAgeRestrictionDialog(
                                rows,
                                marks,
                                incorrect,
                                digits,
                                time,
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
                  )
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
        print(userInput);
        print(correctAns);
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
    numDigits = int.parse(arguments['numDigits']);
    numRows = int.parse(arguments['numRows']);
    timeLimit = int.parse(arguments['timeLimit']);
    operation = arguments['operation'];
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
                            color: Colors.redAccent,
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
                        // SizedBox(height: 10),
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
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(52, 0, 52, 0),
                          child: TextField(
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
                                errorText: textBoxEmpty ? 'Enter answer' : null,
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Itim',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Itim',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                //filled: true,
                                //fillColor: Colors.blue.shade300,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
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