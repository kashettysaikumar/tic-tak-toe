import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tictactoe/color.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = true;
  List<String> displayXO = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  bool WinnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  void _tapped(int index) {
    final isRunning =timer == null? false :timer!.isActive;
    setState(() {
      if (oTurn && displayXO[index] == "") {
        displayXO[index] = "0";
        filledBoxes++;
      } else if (!oTurn && displayXO[index] == '') {
        displayXO[index] = "X";
        filledBoxes++;
      }
      oTurn = !oTurn;
      _checkWinner();
      print(displayXO);
    });
  }

  void _updateScore(String winner) {
    if (winner == "0") {
      oScore++;
    } else if (winner == 'x') {
      xScore++;
    }
    WinnerFound = true;
  }

  void _ClearBoad() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = "";
      }
      resultDeclaration = "";
    });
    filledBoxes = 0;
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 8,
            backgroundColor: MainColor.accentColor,
          )
        ],
      ),
    )
        : ElevatedButton(
      onPressed: () {
        _ClearBoad();
      },
      child: Text(
        "play Again!",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }

  void _checkWinner() {
    // 1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[0] + ' wins!';
        _updateScore(displayXO[0]);
      });
    }

    //  2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[3] + ' wins!';
        _updateScore(displayXO[3]);
      });
    }

    // 3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[6] + ' wins!';
        _updateScore(displayXO[6]);
      });
    }

    //1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[0] + ' wins!';
        _updateScore(displayXO[0]);
      });
    }
    // 2nd column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[1] + ' wins!';
        _updateScore(displayXO[1]);
      });
    }
    // 3rd column
    if (displayXO[2] == displayXO[1] &&
        displayXO[2] == displayXO[2] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[2] + ' wins!';
        _updateScore(displayXO[3]);
      });
    }

    // cross 1

    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[0] + ' wins!';
        _updateScore(displayXO[0]);
      });
    }

    // cross 2
    if (displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = "player " + displayXO[6] + ' wins!';
        _updateScore(displayXO[6]);
      });
    }
    if (!WinnerFound && filledBoxes == 9) {
      setState(() {
        resultDeclaration = "Nobody Wins!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'player O',
                          style: customFontWhite,
                        ),
                        Text(
                          oScore.toString(),
                          style: customFontWhite,
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'player X',
                          style: customFontWhite,
                        ),
                        Text(
                          xScore.toString(),
                          style: customFontWhite,
                        ),
                        SizedBox(
                            height: 10),
                        _buildTimer()
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                        print(filledBoxes);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 5,
                            color: MainColor.primaryColor,
                          ),
                          color: MainColor.secondaryColor,
                        ),
                        child: Center(
                          child: Text(
                            displayXO[index],
                            style: GoogleFonts.coiny(
                                textStyle: TextStyle(
                                    fontSize: 64,
                                    color: MainColor.primaryColor)),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
                flex: 2,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          resultDeclaration,
                          style: customFontWhite,
                        ),
                        SizedBox(height: 10),
                        /*ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16)),
                      onPressed: () {
                        startTimer();
                        _ClearBoad();
                      },
                      child: Text(
                        "Play Again!",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    )*/
                      ],
                    ))),
          ]),
        ),
      ),
    );
  }
}
