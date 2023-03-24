import 'package:flash_anzan/widgets/send_result.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

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
  String digits,
  int rows,
  int totalQuestions,
  int marks,
  int correct,
  String timeTaken,
  int accuracy,
  int point,
  String dateTime,
  List wrong,
  String userName,
  String ops,
  String path,
  String pathVal,
) {
  var percentage = ((correct / totalQuestions) * 100).toStringAsFixed(2);
  var result = "";
  if (totalQuestions == 1) {
    result =
        "$ops\nDate: $dateTime\nName: $userName\nRows: $rows \nDigits: $digits \nQuestions: $totalQuestions \nAttempts: $marks \nTime:$timeTaken \nPoints: $point";
  } else {
    result =
        "$ops\nDate: $dateTime\nName: $userName\nRows: $rows \nDigits: $digits \nCorrect: $correct/$totalQuestions \nPercentage: $percentage% \nTime:$timeTaken \nIncorrect: $wrong \nPoints: $point";
  }
  var context;
  return Alert(
    context: context,
    style: alertStyle,
    title: "Result",
    desc: result,
    //'Date:,
    // image: Image.asset("images/thanks.gif"),
    buttons: [
      DialogButton(
        onPressed: () =>
            Navigator.pushNamed(context, path, arguments: <String, String>{
          'operation': pathVal,
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

timeUpDialog(
    String digits,
    int rows,
    int totalQuestions,
    int marks,
    int correct,
    int incorrect,
    int accuracy,
    int point,
    String time,
    List wrongAnsList,
    String title,
    String path,
    String pathVal) async {
  String currentPhoneDate =
      DateFormat('EEE d MMMy, hh:mm:ss a').format(DateTime.now()); //DateTime

  String username = await send_result_to_firebase(
      title, digits, rows, correct, point, time, totalQuestions);
  var context;
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
                        digits,
                        rows,
                        totalQuestions,
                        marks,
                        correct,
                        time,
                        accuracy,
                        point,
                        currentPhoneDate,
                        wrongAnsList,
                        username,
                        title,
                        path,
                        pathVal);
                  },
                  child: const Text('SHOW RESULT'),
                ),
              ],
            )),
      ],
    ),
  );
}
