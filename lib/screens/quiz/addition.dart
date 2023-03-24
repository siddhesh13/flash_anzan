import 'dart:async';
import 'package:flash_anzan/widgets/send_result.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flash_anzan/provider/userProvider.dart';
import 'package:flash_anzan/widgets/constants.dart';

class Addition extends StatefulWidget {
  static const String routeName = "/additionPage";
  @override
  State<Addition> createState() => _AdditionState();
}

class _AdditionState extends State<Addition> {
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
  var correctAns;
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

  startTimer() async {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        elapsedTime += 100;
        millisPassed += 100;
        if (getQuestion) {
          question = questionList(numRows, numDigits, operation);
          //print(question);
          getQuestion = false;
          //print("time gap: $timeGap");
        }
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
                color = questionColor1;
              } else {
                color = questionColor2;
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
            remainingTime = "0$minLeft:0$secLeft";
          } else {
            remainingTime = "0$minLeft:$secLeft";
          }
          elapsedTime = 0;
        }
      }
          //if (totalTime < 0) {
          //accuracy = time ~/ marks;
          //timeUpDialog(rows, marks, digits, time, accuracy, currentQuestionNum);
          //}
          );
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
      int digits,
      String timeTaken,
      int accuracy,
      int totalQuestions,
      String dateTime,
      List wrong,
      String userName,
      String ops,
      int point) {
    var percentage = ((correct / totalQuestions) * 100).toStringAsFixed(2);
    var result = "";
    if (totalQuestions == 1) {
      result =
          "$ops\nDate: $dateTime\nName: $userName\nRows: $rows \nDigits: $digits \nQuestions: $totalQuestions \nAttempts: $marks \nTime:$timeTaken \nPoints: $point";
    } else {
      result =
          "$ops\nDate: $dateTime\nName: $userName\nRows: $rows \nDigits: $digits \nCorrect: $correct/$totalQuestions \nPercentage: $percentage% \nTime:$timeTaken \nIncorrect: $wrong \nPoints: $point";
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
          onPressed: () => Navigator.pushNamed(context, '/addSetting',
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

  timeUpDialog(int rows, int marks, int correct, int incorrect, int digits,
      String time, int accuracy, int totalQuestions, int point) async {
    String currentPhoneDate =
        DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now()); //DateTime
    String username = "Guest";
    if (userLoggedIn) {
      username = await send_result_to_firebase(title, digits.toString(),
          numRows, correct, point, time, totalQuestions);
    }
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("sending data to cloud firestore"),
                        ),
                      );

                      showAgeRestrictionDialog(
                          rows,
                          marks,
                          correct,
                          digits,
                          time,
                          accuracy,
                          totalQuestions,
                          currentPhoneDate,
                          wrongAnswers,
                          username,
                          title,
                          point);
                    },
                    child: const Text('SHOW RESULT'),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  List questionList(int rows, int digits, String ops) {
    List<int> question = [];
    List<double> decimalQuestion = [];
    int num;
    double decNum;
    int finalAns = 0;
    int endNum = (pow(10, digits)).toInt();
    int increment = 0;
    var random = Random();
    double total = 0.0;
    while (increment < rows) {
      if (ops == 'add') {
        title = 'Addition';
        num = random.nextInt((endNum - 1) + endNum) - (endNum - 1);
        if ((finalAns + num) < 0) {
        } else if (num > (pow(10, digits - 1))) {
          finalAns += num;
          question.add(num);
          increment++;
        }
      } else if (ops == 'decimal') {
        fontSize = 40.0;
        decNum = 0.0;
        title = 'Decimal Add/Sub';
        decNum = random.nextInt((endNum - 1) + endNum) -
            (endNum - 1) * random.nextDouble();
        decNum = double.parse(decNum.toStringAsFixed(1));
        if ((total + decNum) < 0) {
        } else if (((decNum >= pow(10, digits - 1)) &&
                (decNum < pow(10, digits))) ||
            ((decNum <= (pow(10, digits - 1)) * -1) &&
                (decNum > (pow(10, digits)) * -1))) {
          decimalQuestion.add(decNum);
          total += decNum;
          increment++;
        }
      } else {
        title = 'Addition/Subtraction';
        num = random.nextInt((endNum - 1) + endNum) - (endNum - 1);
        if ((finalAns + num) < 0) {
        } else if (((num >= pow(10, digits - 1)) && (num < pow(10, digits))) ||
            ((num <= (pow(10, digits - 1)) * -1) &&
                (num > (pow(10, digits)) * -1))) {
          finalAns += num;
          question.add(num);
          increment++;
        }
      }
    }
    if (operation == 'add') {
      print(question);
      print(finalAns);
      correctAns = finalAns;
      return question;
    } else if (operation == 'decimal') {
      print(decimalQuestion);
      correctAns = total.toStringAsFixed(1);
      print("$total,$correctAns");
      return decimalQuestion;
    } else {
      print(question);
      print(finalAns);
      correctAns = finalAns;
      return question;
    }
  }

  int calculatePoints() {
    int totalPoints = 0;
    int multiplier = 1;
    if (operation == 'add') {
      multiplier = 2;
    } else if (operation == 'decimal') {
      multiplier = 4;
    } else {
      multiplier = 3;
    }
    if (timeGap > 0.5) {
      totalPoints += 15;
    } else if (timeGap >= 0.5 && timeGap < 1.0) {
      totalPoints += 10;
    } else if (timeGap == 1.0) {
      totalPoints += 5;
    } else {
      totalPoints += 1;
    }
    if (totalQuestions >= 3 && numRows >= 10) {
      if (correct == totalQuestions) {
        totalPoints += (totalQuestions) * (totalQuestions ~/ 2);
      }
      totalPoints += ((numDigits * multiplier) + (numRows ~/ 10)) * correct;
    } else {
      totalPoints += ((numDigits * multiplier) + (numRows ~/ 10)) * correct;
    }
    if (totalQuestions == 1) {
      if (attempts == 1) {
        totalPoints += ((numDigits * multiplier) + (numRows ~/ 10)) + 2;
      } else {
        totalPoints = 3;
      }
    }
    if (correct == 0) totalPoints = 0;
    return totalPoints;
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
          int totalPoints = calculatePoints();
          timeUpDialog(numRows, attempts, correct, incorrect, numDigits,
              remainingTime, 0, totalQuestions, totalPoints);
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
            int totalPoints = calculatePoints();
            timeUpDialog(numRows, attempts, correct, incorrect, numDigits,
                remainingTime, 0, totalQuestions, totalPoints);
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
    final userProvider = Provider.of<UserProvider>(context);
    final userP = userProvider.user;
    userLoggedIn = (userP?.displayName ?? '').isNotEmpty;
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    numDigits = int.parse(arguments['digits']);
    numRows = int.parse(arguments['rows']);
    totalQuestions = int.parse(arguments['totalQuestions']);
    operation = arguments['operation'];
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
                            Text(
                              title,
                              style: const TextStyle(
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
