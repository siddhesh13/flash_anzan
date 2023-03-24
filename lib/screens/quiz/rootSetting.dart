import 'package:flash_anzan/drawer.dart';
import 'package:flutter/material.dart';

class RootSettingsPage extends StatefulWidget {
  @override
  _RootSettingsPageState createState() => _RootSettingsPageState();
}

class _RootSettingsPageState extends State<RootSettingsPage> {
  int _numOfDigits = 2;
  int _numOfRows = 10;
  double _timeInSeconds = 1.0;
  int _numOfQuestions = 5;
  String title = "Addition";
  String operation = 'Square Root';
  String hint = 'Enter number of square root digits';
  String label = 'Enter number of square root digits';
  String msg = 'Enter less than 10';
  int limit = 10;
  

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    operation = arguments['operation'];
    if (operation == 'Square Root') {
      label = 'Number of square root digits  ';
      limit = 10;
      title = "Sqaure Root";
    } else {
      label = 'Number of cube root digits';
      limit = 8;
      title = "Cube Root";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('$title Settings'),
          centerTitle: true,
        ),
        drawer: TrendingSidebar(
          /*  username: "username",
            email: "email",
            photo: "photo",
            level: "Level"*/),
        body: Center(
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
                        Row(
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
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
                          max: (limit - 1).toDouble(),
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
                          max: 500,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _numOfRows.toDouble(),
                          label: '${_numOfRows.toInt()}',
                          divisions: 250,
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
                              '${_timeInSeconds.toInt()}',
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
                          value: _timeInSeconds,
                          label: '${_timeInSeconds.toInt()}',
                          divisions: 600,
                          onChanged: (value) {
                            setState(() {
                              _timeInSeconds = value;
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
                            Navigator.pushNamed(
                              context,
                              "/rootQuiz",
                              arguments: <String, String>{
                                'numDigits': _numOfDigits.toString(),
                                'numRows': _numOfRows.toString(),
                                'timeLimit': _timeInSeconds.toInt().toString(),
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
