import 'package:flash_anzan/drawer.dart';
import 'package:flutter/material.dart';

class DivisionSettingsPage extends StatefulWidget {
  @override
  _DivisionSettingsPageState createState() => _DivisionSettingsPageState();
}

class _DivisionSettingsPageState extends State<DivisionSettingsPage> {
  int _timeInSeconds = 60;
  int _numOfQuestions = 5;

  final _minAnswerController = TextEditingController();
  final _maxAnswerController = TextEditingController();
  final _minNumberController = TextEditingController();
  final _maxNumberController = TextEditingController();

  bool minAnswerValidate = false;

  bool validateMinAnswerTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        minAnswerValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else if (int.parse(userInput) > 100000) {
      setState(() {
        minAnswerValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        minAnswerValidate = false;
      });
    }
    return true;
  }

  bool maxAnswerValidate = false;

  bool validateMaxAnswerTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        maxAnswerValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else if (int.parse(userInput) <= int.parse(_minAnswerController.text) ||
        int.parse(userInput) > 100000) {
      setState(() {
        maxAnswerValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        maxAnswerValidate = false;
      });
    }
    return true;
  }

  bool minNumberValidate = false;

  bool validateMinNumberTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        minNumberValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else if (int.parse(userInput) > 100000) {
      setState(() {
        minNumberValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        minNumberValidate = false;
      });
    }
    return true;
  }

  bool maxNumberValidate = false;

  bool validateMaxNumberTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        maxNumberValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else if (int.parse(userInput) <= int.parse(_minNumberController.text) ||
        int.parse(userInput) > 100000000) {
      setState(() {
        maxNumberValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    } else {
      setState(() {
        maxNumberValidate = false;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Division Settings'),
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
                          const Text(
                            "Division",
                            style: TextStyle(
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
                            controller: _minAnswerController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Minimum Answer Value',
                              labelText: 'Minimum Answer Value',
                              errorText: minAnswerValidate
                                  ? 'Enter Minimum Answer Value'
                                  : null,
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
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
                            controller: _maxAnswerController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Maximum Answer Value',
                              labelText: 'Maximum Answer Value',
                              errorText: maxAnswerValidate
                                  ? 'Enter Maximum Answer Value'
                                  : null,
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
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
                            controller: _minNumberController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Lowest Number to Divide By',
                              labelText: 'Lowest Number to Divide By',
                              errorText: minNumberValidate
                                  ? 'Lowest Number to Divide By'
                                  : null,
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
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
                            controller: _maxNumberController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Highest Number to Divide By',
                              labelText: 'Highest Number to Divide By',
                              errorText: maxNumberValidate
                                  ? 'Enter Highest Number to Divide By'
                                  : null,
                              hintStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.redAccent),
                              labelStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.blue),
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
                              validateMinAnswerTextField(
                                  _minAnswerController.text);
                              if (minAnswerValidate == false) {
                                validateMaxAnswerTextField(
                                    _maxAnswerController.text);
                                if (maxAnswerValidate == false) {
                                  validateMinNumberTextField(
                                      _minNumberController.text);
                                  if (minNumberValidate == false) {
                                    validateMaxNumberTextField(
                                        _maxNumberController.text);
                                    if (maxNumberValidate == false) {
                                      Navigator.pushNamed(
                                        context,
                                        "/divisionQuiz",
                                        arguments: <String, String>{
                                          'minAnswer':
                                              _minAnswerController.text,
                                          'maxAnswer':
                                              _maxAnswerController.text,
                                          'minNumber':
                                              _minNumberController.text,
                                          'maxNumber':
                                              _maxNumberController.text,
                                          'rows': _numOfQuestions.toString(),
                                          'timeLimit':
                                              _timeInSeconds.toString(),
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
