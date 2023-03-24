import 'package:flash_anzan/drawer.dart';
import 'package:flutter/material.dart';

class MultiplicationSettingsPage extends StatefulWidget {
  @override
  _MultiplicationSettingsPageState createState() =>
      _MultiplicationSettingsPageState();
}

class _MultiplicationSettingsPageState
    extends State<MultiplicationSettingsPage> {
  int _timeInSeconds = 60;
  int _numOfQuestions = 5;

  final _firstNumLowController = TextEditingController();
  final _firstNumHighController = TextEditingController();
  final _secondNumLowController = TextEditingController();
  final _secondNumHighController = TextEditingController();
  //final _rowsController = TextEditingController();
  //final _secondsController = TextEditingController();
  String operation = "multiply";
  String title = "Multiplication";
  //bool _validate = false;
  bool multipleLowValidate = false;
  bool validatemultipleLowTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        multipleLowValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) > 10000000000) {
      setState(() {
        multipleLowValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        multipleLowValidate = false;
      });
    }
    return true;
  }

  bool multipleHighValidate = false;
  bool validatemultipleHighTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        multipleHighValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) > 100000000000 ||
        int.parse(userInput) <= int.parse(_firstNumLowController.text)) {
      setState(() {
        multipleHighValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        multipleHighValidate = false;
      });
    }
    return true;
  }

  bool multiplierLowValidate = false;
  bool validatemultiplierLowTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        multiplierLowValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) > 100000000000) {
      setState(() {
        multiplierLowValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        multiplierLowValidate = false;
      });
    }
    return true;
  }

  bool multiplierHighValidate = false;
  bool validatemultiplierHighTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        multiplierHighValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) > 100000000000 ||
        int.parse(userInput) <= int.parse(_secondNumLowController.text)) {
      setState(() {
        multiplierHighValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        multiplierHighValidate = false;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    operation = arguments['operation'];
    if (operation == "multiply") {
      title = 'Multiplication';
    } else {
      title = "Long Multiplication";
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Multiplication Settings'),
          centerTitle: true,
        ),
        drawer: TrendingSidebar(
            /*  username: "username",
            email: "email",
            photo: "photo",
            level: "Level"*/),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
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
                          TextFormField(
                            controller: _firstNumLowController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Lowest Number to Multiply',
                              labelText: 'Lowest Number to Multiply',
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
                              errorText: multipleLowValidate
                                  ? 'Lowest Number to Multiply'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            ),
                            style: const TextStyle(color: Colors.deepOrange),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _firstNumHighController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Highest Number to Multiply',
                              labelText: 'Highest Number to Multiply',
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
                              errorText: multipleHighValidate
                                  ? 'Highest Number to Multiply'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            ),
                            style: const TextStyle(color: Colors.deepOrange),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _secondNumLowController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Lowest Number to Multiply By',
                              labelText: 'Lowest Number to Multiply By',
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
                              errorText: multiplierLowValidate
                                  ? 'Lowest Number to Multiply By'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            ),
                            style: const TextStyle(color: Colors.deepOrange),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _secondNumHighController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Highest Number to Multiply By',
                              labelText: 'Highest Number to Multiply By',
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
                              errorText: multiplierHighValidate
                                  ? 'Enter Highest Number to Multiply By'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                            ),
                            style: const TextStyle(color: Colors.deepOrange),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Total Time in Seconds  ',
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
                            min: 1,
                            max: 600,
                            activeColor: Colors.purple,
                            inactiveColor: Colors.purple.shade100,
                            thumbColor: Colors.deepOrange,
                            value: _timeInSeconds.toDouble(),
                            label: '${_timeInSeconds.toInt()}',
                            divisions: 600,
                            onChanged: (value) {
                              setState(() {
                                _timeInSeconds = value.toInt();
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
                            max: 200,
                            activeColor: Colors.purple,
                            inactiveColor: Colors.purple.shade100,
                            thumbColor: Colors.deepOrange,
                            value: _numOfQuestions.toDouble(),
                            label: '${_numOfQuestions.round()}',
                            divisions: 200,
                            onChanged: (value) {
                              setState(() {
                                _numOfQuestions = value.toInt();
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
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
                              validatemultipleLowTextField(
                                  _firstNumLowController.text);
                              if (multipleLowValidate == false) {
                                validatemultipleHighTextField(
                                    _firstNumHighController.text);
                                if (multipleHighValidate == false) {
                                  validatemultiplierLowTextField(
                                      _secondNumLowController.text);
                                  if (multiplierLowValidate == false) {
                                    validatemultiplierHighTextField(
                                        _secondNumHighController.text);
                                    if (multiplierHighValidate == false) {
                                      Navigator.pushNamed(
                                        context,
                                        "/multiplicationQuiz",
                                        arguments: <String, String>{
                                          'firstNumLower':
                                              _firstNumLowController.text,
                                          'firstNumUpper':
                                              _firstNumHighController.text,
                                          'secondNumLower':
                                              _secondNumLowController.text,
                                          'secondNumUpper':
                                              _secondNumHighController.text,
                                          'rows': _numOfQuestions.toString(),
                                          'timeLimit':
                                              _timeInSeconds.toString(),
                                          'operation': operation,
                                        },
                                      );
                                    }
                                  }
                                }
                              }
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
          ),
        ));
  }
}
