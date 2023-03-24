import 'package:flash_anzan/drawer.dart';
import 'package:flash_anzan/widgets/rangeSlider.dart';
import 'package:flash_anzan/widgets/slider.dart';
import 'package:flutter/material.dart';

class AdditionSettingsPage extends StatefulWidget {
  @override
  _AdditionSettingsPageState createState() => _AdditionSettingsPageState();
}

class _AdditionSettingsPageState extends State<AdditionSettingsPage> {
  int _numOfDigits = 2;
  int _numOfRows = 10;
  double _timeInSeconds = 1.0;
  int _numOfQuestions = 5;
  String operation = "Addition";
  String title = "Addition";

  /*bool digitsValidate = false;

  bool validateDigitsTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        digitsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) >= 10) {
      setState(() {
        digitsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        digitsValidate = false;
      });
    }
    return true;
  }

  bool rowsValidate = false;
  bool validateRowsTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        rowsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) > 100000) {
      setState(() {
        rowsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        rowsValidate = false;
      });
    }
    return true;
  }

  bool secondsValidate = false;
  bool validateTimeTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        secondsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (double.parse(userInput) == 0.0) {
      setState(() {
        secondsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        secondsValidate = false;
      });
    }
    return true;
  }

  onDigitChanged(double val) {
    _numOfDigits = val.toInt();
  }
*/
  @override
  Widget build(BuildContext context) {
    
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments != null) {
      operation = arguments['operation'];
      if (operation == "add") {
        title = "Addition";
      } else if (operation == "decimal") {
        title = "Decimal Add/Sub";
      } else {
        title = "Addition/Subtraction";
      }
      //print(operation);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Addition Settings'),
          centerTitle: true,
        ),
        drawer: TrendingSidebar(
            /*  username: "username",
            email: "email",
            photo: "photo",
            level: "Level"*/),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20.0),
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

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /*ConfigurableRangeSlider(
                min: 0,
                max: 100,
                onChanged: (start, end) {
                  print('Start value: $start, End value: $end');
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),*/
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Itim',
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            color: Colors.redAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Number Of Digits  ',
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '$_numOfDigits',
                              style: const TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.deepOrange,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Slider(
                          min: 1,
                          max: 9,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _numOfDigits.toDouble(),
                          label: '${_numOfDigits.toInt()}',
                          divisions: 9,
                          onChanged: (value) {
                            setState(() {
                              _numOfDigits = value.toInt();
                            });
                          },
                        ),
                        Row(
                          children: [
                            const Text(
                              'Number Of Rows  ',
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '$_numOfRows',
                              style: const TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.deepOrange,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Slider(
                          min: 1,
                          max: 1000,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _numOfRows.toDouble(),
                          label: '${_numOfRows.toInt()}',
                          divisions: 200,
                          onChanged: (value) {
                            setState(() {
                              _numOfRows = value.toInt();
                            });
                          },
                        ),
                        Row(
                          children: [
                            const Text(
                              'Time in Seconds  ',
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '$_timeInSeconds',
                              style: const TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.deepOrange,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Slider(
                          min: 0,
                          max: 5.0,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _timeInSeconds,
                          label: '${_timeInSeconds}',
                          divisions: 40,
                          onChanged: (value) {
                            setState(() {
                              _timeInSeconds = value;
                            });
                          },
                        ),
                        Row(
                          children: [
                            const Text(
                              'Number Of Questions  ',
                              style: TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '$_numOfQuestions',
                              style: const TextStyle(
                                fontFamily: 'Itim',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.deepOrange,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Slider(
                          min: 1,
                          max: 100,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _numOfQuestions.toDouble(),
                          label: '${_numOfQuestions.round()}',
                          divisions: 100,
                          onChanged: (value) {
                            setState(() {
                              _numOfQuestions = value.toInt();
                            });
                          },
                        ),
                        /*
              DropdownButtonFormField(
                value: _numOfDigits,
                items: [
                  DropdownMenuItem(value: 1, child: Text('1 Digit')),
                  DropdownMenuItem(value: 2, child: Text('2 Digits')),
                  DropdownMenuItem(value: 3, child: Text('3 Digits')),
                  DropdownMenuItem(value: 4, child: Text('4 Digits')),
                  DropdownMenuItem(value: 5, child: Text('5 Digits')),
                  DropdownMenuItem(value: 6, child: Text('6 Digits')),
                  DropdownMenuItem(value: 7, child: Text('7 Digits')),
                  DropdownMenuItem(value: 8, child: Text('8 Digits')),
                  DropdownMenuItem(value: 9, child: Text('9 Digits')),
                ],
                onChanged: (dynamic value) {
                  setState(() {
                    _numOfDigits = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Number of Digits',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of Rows',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numOfRows = int.tryParse(value) ?? 3;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Time in seconds',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _timeInSeconds = double.tryParse(value) ?? 1.0;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of questions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numOfQuestions = int.tryParse(value) ?? 10;
                  });
                },
              ),*/
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange, // background
                            onPrimary: Colors.white, // foreground
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(4)),
                            padding:
                                EdgeInsets.fromLTRB(52.0, 14.0, 52.0, 14.0),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/additionQuiz",
                              arguments: <String, String>{
                                'digits': _numOfDigits.toString(),
                                'rows': _numOfRows.toString(),
                                'totalQuestions': _numOfQuestions.toString(),
                                'seconds': _timeInSeconds.toString(),
                                'operation': operation,
                              },
                            );
                          },
                          child: const Text(
                            'Start',
                            style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
