import 'package:flutter/material.dart';

import 'game.dart';
void main() {
  const app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  late Game _game;
  static const buttonSize = 60.0;

  HomePage({Key? key}) : super(key: key) {
    _game = Game(maxRandom: 100);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _inputstate = '';
  String _message = '';

  void _showOkDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //var showSeven = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GUESS THE NUMBER'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange.shade200,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: Offset(5.0, 5.0),
                spreadRadius: 2.0,
                blurRadius: 5.0,
              )
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/guess_logo.png', width: 90.0),
                    SizedBox(width: 8.0),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GUESS',
                            style: TextStyle(
                                fontSize: 36.0, color: Colors.pink.shade500)),
                        Text(
                          'THE NUMBER',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.pink.shade300,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_inputstate,
                    style: TextStyle(fontSize: 50.0, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_message,
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 3; i++) buildButton(num: i),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 4; i <= 6; i++) buildButton(num: i),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 7; i <= 9; i++) buildButton(num: i),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildButton(num: -1),
                  buildButton(num: 0),
                  buildButton(num: -2),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Text('GUESS'),
                  onPressed: () {
                    var input = _inputstate;
                    int? guess = int.tryParse(input);
                    var guessResult = widget._game.doGuess(guess!);
                    if (guessResult > 0) {
                      setState(() {
                        _message = '$guess มากเกินไป กรุณาลองใหม่';
                        _inputstate = _inputstate.substring(0, 0);
                      });
                    } else if (guessResult < 0) {
                      setState(() {
                        _message = '$guess น้อยเกินไป กรุณาลองใหม่';
                        _inputstate = _inputstate.substring(0, 0);
                      });
                    } else {
                      setState(() {
                        _message =
                        '$guess เป็นคำตอบที่ถูกต้อง เก่งมาก กล้ามาก ขอบใจ🎉\n คุณทายทั้งหมด ${widget
                            ._game
                            .guessCount} ครั้ง';
                        _inputstate = _inputstate.substring(0, 0);
                      });
                    }

                    //_showOkDialog(context, 'RESULT', message);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({int? num}) {
    Widget? child;
    if (num == -1){
      child = Icon(Icons.clear);}
    else if (num == -2){
      child = Icon(Icons.backspace);}
    else{
      child = Text('$num');}
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (num == -1) {
            print('Clear');
            setState(() {
              _inputstate = _inputstate.substring(0, 0);
              child = Icon(Icons.delete);
            });
          }
          else if (num == -2) {
            print('Backspace');
            setState(() {
              var length = _inputstate.length;
              _inputstate = _inputstate.substring(0, length - 1);
              child = Icon(Icons.backspace);
            });
          } else {
              print('$num');
            setState(() {
              _inputstate = '$_inputstate$num';
            });
            child = Text('$num');
          }
        },
        borderRadius: BorderRadius.circular(HomePage.buttonSize / 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade300,
            border: Border.all(color: Colors.pinkAccent, width: 3.0),
            borderRadius: BorderRadius.circular(7.0),
          ),
          alignment: Alignment.center,
          width: HomePage.buttonSize,
          height: HomePage.buttonSize,
          child: Container(child: child
          ),
        ),
      ),
    );
  }
}
