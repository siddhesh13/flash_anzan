import 'package:flash_anzan/drawer.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';

class NoFormulaSettingsPage extends StatefulWidget {
  @override
  _NoFormulaSettingsPageState createState() => _NoFormulaSettingsPageState();
}

class _NoFormulaSettingsPageState extends State<NoFormulaSettingsPage> {
  int _numOfRows = 10;
  double _timeInSeconds = 1.0;
  int _numOfQuestions = 5;
  bool digitsValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('No Formula Add/Sub Settings'),
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
                        const Text(
                          'No Formula Add/Sub Settings',
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
                          max: 16,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _numOfRows.toDouble(),
                          label: '${_numOfRows.toInt()}',
                          divisions: 16,
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
                          label: '$_timeInSeconds',
                          divisions: 10,
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
                          max: 20,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.purple.shade100,
                          thumbColor: Colors.deepOrange,
                          value: _numOfQuestions.toDouble(),
                          label: '${_numOfQuestions.round()}',
                          divisions: 20,
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
                            Navigator.pushNamed(
                              context,
                              "/noFormulaQuiz",
                              arguments: <String, String>{
                                'rows': _numOfRows.toString(),
                                'totalQuestions': _numOfQuestions.toString(),
                                'seconds': _timeInSeconds.toString(),
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
