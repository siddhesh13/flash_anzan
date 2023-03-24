import 'package:flash_anzan/drawer.dart';
import 'package:flutter/material.dart';

class FlashcardSetting extends StatefulWidget {
  @override
  State<FlashcardSetting> createState() => _FlashcardSettingState();
}

class _FlashcardSettingState extends State<FlashcardSetting> {
  int _minNumber = 1;
  int _maxNumber = 100;
  double _timeInSeconds = 30.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("THE LEARNERS HUB"),
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
          child: Column(children: [
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
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Flashcard Settings",
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
                      Row(
                        children: [
                          const Text(
                            'Minimum Number  ',
                            style: TextStyle(
                              fontFamily: 'Itim',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '$_minNumber',
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
                        value: _minNumber.toDouble(),
                        label: '${_minNumber.toInt()}',
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            _minNumber = value.toInt();
                          });
                        },
                      ),
                      Row(
                        children: [
                          const Text(
                            'Maximum Number  ',
                            style: TextStyle(
                              fontFamily: 'Itim',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '$_maxNumber',
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
                        min: _minNumber.toDouble(),
                        max: 1000,
                        activeColor: Colors.purple,
                        inactiveColor: Colors.purple.shade100,
                        thumbColor: Colors.deepOrange,
                        value: _maxNumber.toDouble(),
                        label: '${_maxNumber.toInt()}',
                        divisions: 200,
                        onChanged: (value) {
                          setState(() {
                            _maxNumber = value.toInt();
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
                        max: 600.0,
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
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange, // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(4)),
                          padding: EdgeInsets.fromLTRB(75.0, 14.0, 75.0, 16.0),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/flashcardQuiz",
                            arguments: <String, String>{
                              'minm': _minNumber.toString(),
                              'maxm': _maxNumber.toString(),
                              'timeLimit': _timeInSeconds.toString(),
                            },
                          );
                        },
                        child: Text(
                          'Start',
                          style: TextStyle(
                            fontFamily: 'Itim',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
