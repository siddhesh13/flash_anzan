import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:excel/excel.dart';
import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoFormula extends StatefulWidget {
  static const String routeName = "/additionPage";
  @override
  State<NoFormula> createState() => _NoFormulaState();
}

class _NoFormulaState extends State<NoFormula> {
  final _answerController = TextEditingController();
  late FocusNode _focusNode;
  Color color = Colors.white;
  double fontSize = 46.0;
  int numDigits = 2;
  int numRows = 10;
  double timeGap = 1.0;
  var operation = 'Addition';
  String title = "Addition";
  bool getQuestion = true;
  var elapsedTime = 0;
  var totalTime = 0;
  var minLeft = 0;
  var secLeft = 0;
  var millisPassed = 0;
  var remainingTime = "";
  int correctAns = 0;
  String currentNum = "START";
  int numIndex = 0;
  late Timer timer;
  List question = [];
  List wrongAnswers = [];
  int currentQuestionNum = 0;
  int totalQuestions = 1;
  int finalTime = 0;
  int attempts = 1;
  int correct = 0;
  int incorrect = 0;
  String progress = "";
  //widget variables
  bool isVisible = false;
  bool replayVisible = false;
  bool startAgain = true;
  bool lessTime = true;
  var excelColumns = [];
  bool firstRequest = false;
  bool getExcel = true;
  int questionNumber = 0;
  late Sheet questionSheet;
  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _answerController.clear();
    });
    super.initState();
    Timer.run(() async {
      if (getExcel) {
        questionSheet = await _getColumnValues();
        getExcel = false;
      }
    });
    if (mounted) {
      startTimer();
    }
  }

  @override
  void dispose() {
    timer.cancel(); // cancel the timer if it's still running
    _focusNode.dispose(); // dispose the focus node
    super.dispose();
  }

  startTimer() async {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        elapsedTime += 100;
        millisPassed += 100;
        if (getQuestion) {
          var random = Random();
          int randInt = random.nextInt(questionSheet.maxCols);
          question = [];
          //print("Add random columns");
          for (var row in questionSheet.rows) {
            if (question.length < numRows) {
              question.add(row[randInt]!.value);
              correctAns += int.parse(row[randInt]!.value.toString());
            }
          }
          questionNumber += 1;
          //print(question);
          getQuestion = false;
          print(question);
          print(correctAns);
        }

        if (getExcel == false) {
          if (startAgain) {
            if (millisPassed >= timeGap * 1000) {
              if (timeGap < 1 && lessTime == true) {
                lessTime = false;
              } else if (numIndex < question.length) {
                currentNum = question[numIndex].toString();
                numIndex++;
                /* if (numDigits <= 6) {
                fontSize = 60.0;
              } else if (numDigits > 6 && numDigits <= 10) {
                fontSize = 50.0;
              } else {
                fontSize = 32.0;
              }*/

                if (numIndex % 2 == 0) {
                  color = Colors.white;
                } else {
                  color = Colors.yellow;
                }
                isVisible = false;
                replayVisible = false;
              }
              if (numIndex == question.length) {
                isVisible = true;
                if (totalQuestions == 1) replayVisible = true;
                startAgain = false;
              }
              millisPassed = 0;
            }
          }
          if (elapsedTime == 1000) {
            totalTime++;
            //print(totalTime);
            minLeft = totalTime ~/ 60;
            secLeft = totalTime % 60;
            if (secLeft < 10) {
              remainingTime = "$minLeft:0$secLeft";
            } else {
              remainingTime = "$minLeft:$secLeft";
            }
            elapsedTime = 0;
          }
          //}
          //if (totalTime < 0) {
          //accuracy = time ~/ marks;
          //timeUpDialog(rows, marks, digits, time, accuracy, currentQuestionNum);
        }
        //}
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
    int correct,
    String timeTaken,
    int accuracy,
    int totalQuestions,
    String dateTime,
    List wrong,
  ) {
    var percentage = ((correct / totalQuestions) * 100).toStringAsFixed(2);
    var result = "";
    if (totalQuestions == 1) {
      result =
          "No Formula Add/Sub\nDate: $dateTime\nRows: $rows \nDigits: 1 \nQuestions: $totalQuestions \nAttempts: $marks \nTime:$timeTaken";
    } else {
      result =
          "No Formula Add/Sub\nDate: $dateTime\n\nRows: $rows \nDigits: 1 \nCorrect: $correct/$totalQuestions \nPercentage: $percentage% \nTime:$timeTaken \nIncorrect: $wrong";
    }
    return Alert(
      context: context,
      style: alertStyle,
      title: "Result",
      desc: result,
      //'Date:,
      // image: Image.asset("images/thanks.gif"),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/noFormulaSetting',
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

  Future<Sheet> _getColumnValues() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('asset/noFormula.xlsx');
    Uint8List? file = await ref.getData();
    var buffer = file?.buffer;
    var excel = Excel.decodeBytes(buffer?.asUint8List() ?? []);

    var sheet = excel['Sheet1'];
    return sheet;
  }

  timeUpDialog(int rows, int marks, int correct, int incorrect, int digits,
      String time, int accuracy, int totalQuestions) async {
    String currentPhoneDate =
        DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now()); //DateTime

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Thank You!!"),
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
                    onPressed: () async {
                      showAgeRestrictionDialog(
                        rows,
                        marks,
                        correct,
                        time,
                        accuracy,
                        totalQuestions,
                        currentPhoneDate,
                        wrongAnswers,
                      );
                    },
                    child: const Text('SHOW RESULT'),
                  ),
                ],
              )),
        ],
      ),
    );
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
        //print('right answer');
        correct += 1;
        if (currentQuestionNum + 1 == totalQuestions) {
          startAgain = false;
          getQuestion = false;
          timeUpDialog(numRows, attempts, correct, incorrect, numDigits,
              remainingTime, 0, totalQuestions);
        }
      });
    } else if (correctAns.toString() != userInput) {
      setState(() {
        answerValidate = false;
        textBoxEmpty = false;
        if (totalQuestions == 1) {
          replayVisible = true;
          attempts += 1;
        } else {
          wrongAnswers.add(currentQuestionNum + 1);
          incorrect += 1;
          if (currentQuestionNum + 1 == totalQuestions) {
            startAgain = false;
            getQuestion = false;
            timeUpDialog(numRows, attempts, correct, incorrect, numDigits,
                remainingTime, 0, totalQuestions);
          }
        }
        //print('wrong answer');
      });
    }
    //print("Q: $currentQuestionNum");
    if (totalQuestions > 1) {
      currentQuestionNum++;
      numIndex = 0;
      getQuestion = true;
      startAgain = true;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    numRows = int.parse(arguments['rows']);
    totalQuestions = int.parse(arguments['totalQuestions']);
    timeGap = double.parse(arguments['seconds']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Learners Hub'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          //height: 100.0,
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 50),
                          margin: const EdgeInsets.only(
                              bottom: 6.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: NetworkImage(
                                  //"https://picsum.photos/250?image=9"),
                                  "https://firebasestorage.googleapis.com/v0/b/the-learners-hub-abacus-quiz.appspot.com/o/blackboard2.jpg?alt=media&token=c8fa2be2-664c-42b6-949a-3f733de234d1"),
                              fit: BoxFit.cover,
                              //scale: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.black87,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: Column(children: [
                            const Text(
                              "No Formula Add/Sub",
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                color: Colors.redAccent,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    if (totalQuestions == 1) ...[
                                      const Text(
                                        "Attempts: ",
                                        style: TextStyle(
                                          fontFamily: 'Itim',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "$attempts",
                                        style: const TextStyle(
                                          fontFamily: 'Itim',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ] else ...[
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
                                                "$correct",
                                                style: const TextStyle(
                                                  fontFamily: 'Itim',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 15),
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
                                                "$incorrect",
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
                                      )
                                    ],
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
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              currentNum,
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(52, 10, 52, 10),
                              child: Visibility(
                                visible: isVisible,
                                child: TextField(
                                  focusNode: _focusNode,
                                  controller: _answerController,
                                  keyboardType: TextInputType.number,
                                  //obscureText: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Itim',
                                    fontSize: 20.0,
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
                                        borderSide:
                                            BorderSide(color: Colors.blue),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 6.0, 0.0, 10.0),
                              child: Visibility(
                                visible: isVisible,
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
                                    _answerController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 6.0, 0.0, 10.0),
                              child: Visibility(
                                visible: replayVisible,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orange, // background
                                    onPrimary: Colors.white, // foreground
                                    shape: RoundedRectangleBorder(
                                        //to set border radius to button
                                        borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.fromLTRB(
                                        52.0, 14.0, 52.0, 14.0),
                                  ),
                                  onPressed: () {
                                    //validateTextField(_answerController.text);
                                    //_answerController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    numIndex = 0;
                                    startAgain = true;
                                  },
                                  child: const Text(
                                    'Replay',
                                    style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Future<List<dynamic>> _getColumnValues(
      int numOfRows, int numQuestions) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('asset/noFormula.xlsx');
    Uint8List? file = await ref.getData();
    var buffer = file?.buffer;
    var excel = Excel.decodeBytes(buffer?.asUint8List() ?? []);

    var sheet = excel['Sheet1'];

    var questionList = [];
    var random = Random();
    print("Add random columns");
    for (var table in excel.tables.keys) {
      int randNum = random.nextInt(excel.tables[table]!.maxCols);
      //print(table); //sheet Name
      //print(excel.tables[table]!.maxCols);
      //print(excel.tables[table]!.maxRows);
      var rand = Random();
      int randInt = rand.nextInt(excel.tables[table]!.maxCols);
      for (int i = 0; i < numQuestions; i++) {
        var columnValues = [];
        for (var row in excel.tables[table]!.rows) {
          //print('row: ${row[0]!.value}');
          if (columnValues.length < numOfRows) {
            columnValues.add(row[randInt]!.value);
          }
        }
        questionList.add(columnValues);
      }
    }
    print("added random columns");
    return questionList;
  }


*/