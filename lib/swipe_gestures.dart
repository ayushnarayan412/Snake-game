import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SwipeGestures extends StatefulWidget {
  const SwipeGestures({super.key});

  @override
  State<SwipeGestures> createState() => _SwipeGesturesState();
}

class _SwipeGesturesState extends State<SwipeGestures> {
  int numberOfSquares = 680;
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  final duration = const Duration(milliseconds: 200);
  bool gameRunning = false;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(600);
  var score = 0;
  void generateFood() {
    food = randomNumber.nextInt(600);
  }

  void startGame() {
    gameRunning = true;
    direction = 'down';
    snakePosition = [45, 65, 85, 105, 125];

    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        gameRunning = false;
        timer.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GameOver(
                      score: score        )));
      }
    });
  }

  var direction = '';
  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 659) {
            snakePosition.add(snakePosition.last + 20 - 680);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;

        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 680);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;

        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;

        case 'right':
          if (snakePosition.last % 20 == 19) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if (snakePosition.last == food) {
        score += 5;
        generateFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Score : $score",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                  onPressed: gameRunning ? null : startGame,
                  child: const Text(
                    'Start game',
                    style: TextStyle(
                      color: Colors.purple,
                      letterSpacing: 2
                    ),
                  )),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.purple, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: numberOfSquares,
                      itemBuilder: (context, index) {
                        if (snakePosition.contains(index)) {
                          if (index == snakePosition.last) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        if (index == food) {
                          return Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.lime,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: const Color.fromARGB(109, 223, 243, 164),
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ))
            ],
          ),
        ));
  }
}

class GameOver extends StatelessWidget {
  final int score;
  const GameOver({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game over',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.08,
                      color: Colors.white),
                ),
                Text(
                  'Your Score : $score',
                  style: TextStyle(
                      fontSize: screenSize.width * 0.07, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 221, 206, 224),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      elevation: 5),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
