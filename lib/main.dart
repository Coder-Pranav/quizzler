import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(MyApp());
}

Color baseColor = Color(0xFF54457f);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: baseColor,
        body: Center(child: QuizPage()),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Container checkAnswerIcon({IconData checkIcon, Color iconColor}) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: ClayContainer(
        depth: 20,
        color: baseColor,
        borderRadius: 50,
        child: Icon(
          checkIcon,
          color: iconColor,
        ),
      ),
    );
  }

  List<Container> scoreKeeper = [];
  int answersRight = 0;

  @override
  Widget build(BuildContext context) {
    TextButton customButton({String textNeeded, Color buttonColor}) {
      // Color buttonColor = Color(0xFFff595e);
      return TextButton(
        onPressed: () {
          setState(() {
            if (textNeeded.toLowerCase() == quizBrain.getAnswer().toString()) {
              answersRight++;
              scoreKeeper.add(
                checkAnswerIcon(
                    checkIcon: Icons.done, iconColor: Color(0xFFade25d)),
              );
            } else {
              scoreKeeper.add(
                checkAnswerIcon(
                    checkIcon: Icons.clear, iconColor: Color(0xFFff595e)),
              );
            }
            bool checkEndOfQuestions = quizBrain.nextQuestion();
            if (checkEndOfQuestions == false) {
              Alert(
                context: context,
                type: AlertType.success,
                onWillPopActive: true,
                title: "Congrats",
                desc: "You got $answersRight right out of 13.",
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: Color.fromRGBO(0, 179, 134, 1.0),
                    radius: BorderRadius.circular(0.0),
                  ),
                ]
              ).show();
              answersRight = 0;
              scoreKeeper.clear();
            }
          });
        },
        child: ClayContainer(
          width: double.infinity,
          borderRadius: 20,
          surfaceColor: buttonColor,
          parentColor: baseColor,
          depth: 40,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ClayText(
              textNeeded,
              emboss: true,
              size: 30,
              color: buttonColor,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ClayContainer(
                depth: 40,
                height: 100,
                borderRadius: 20,
                color: baseColor,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: ClayText(
                    quizBrain.getQuestion(),
                    emboss: true,
                    color: baseColor,
                    style: TextStyle(fontSize: 30),
                  ),
                )),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: customButton(
                  textNeeded: 'True', buttonColor: Color(0xFFade25d)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: customButton(
                  textNeeded: 'False', buttonColor: Color(0xFFff595e)),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(direction: Axis.horizontal, children: scoreKeeper)
          ],
        ),
      ),
    );
  }
}
