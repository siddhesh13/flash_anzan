import 'package:flash_anzan/drawer.dart';
import 'package:flutter/material.dart';

class TableSettingsPage extends StatefulWidget {
  @override
  _TableSettingsPageState createState() => _TableSettingsPageState();
}

class _TableSettingsPageState extends State<TableSettingsPage> {
  int _timeInSeconds = 60;

  final _digitController = TextEditingController();
  final _rowController = TextEditingController();
  bool checkedValue = false;
  bool digitsValidate = false;
  bool validateDigitsTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        digitsValidate = true;
      });
      return false;
      // ignore: unrelated_type_equality_checks
    }
    if (int.parse(userInput) >= 100000) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tables Settings'),
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
                            "Tables",
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
                            controller: _digitController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter table of',
                              labelText: 'Enter table of',
                              errorText:
                                  digitsValidate ? 'Enter table of' : null,
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
                            controller: _rowController,
                            keyboardType: TextInputType.number,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Number of Rows Here',
                              labelText: 'Number of Rows',
                              errorText:
                                  rowsValidate ? 'Enter number of rows' : null,
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
                          Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.blue),
                            child: CheckboxListTile(
                              title: const Text(
                                "Reverse Table",
                                style: TextStyle(
                                  fontFamily: 'Itim',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              value: checkedValue,

                              activeColor: Colors.deepOrange,

                              onChanged: (dynamic newValue) {
                                setState(() {
                                  checkedValue = newValue;
                                });
                                //print(checkedValue);
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
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
                              validateDigitsTextField(_digitController.text);
                              if (digitsValidate == false) {
                                validateRowsTextField(_rowController.text);
                                if (rowsValidate == false) {
                                  Navigator.pushNamed(
                                    context,
                                    "/tablesQuiz",
                                    arguments: <String, String>{
                                      'tableOf': _digitController.text,
                                      'rows': _rowController.text,
                                      'timeLimit': _timeInSeconds.toString(),
                                      'reverseTable': checkedValue.toString()
                                    },
                                  );
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
