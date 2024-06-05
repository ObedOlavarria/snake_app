import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snake_app/blank_pixel.dart';
import 'package:snake_app/food_pixel.dart';
import 'package:snake_app/highscore_tile.dart';
import 'package:snake_app/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberofSquares = 100;
  int currentScore = 0;
  bool gameHasStarted = false;
  final _nameController = TextEditingController();

  List<int> snakePos = [0, 1, 2];
  var currentDirection = snake_Direction.RIGHT;
  int foodPos = 55;

  List<String> highscoreDocIds = [];
  late Future<void> getDocIdsFuture;

  @override
  void initState() {
    super.initState();
    totalNumberofSquares = rowSize * rowSize;
    getDocIdsFuture = getDocIds();
  }

  Future<void> getDocIds() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(10)
        .get();

    setState(() {
      highscoreDocIds = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();

        if (gameOver()) {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Your score is: $currentScore'),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(hintText: 'Enter name'),
                      )
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submitScore();
                        newGame();
                      },
                      child: Text('Submit'),
                      color: Colors.pink,
                    )
                  ],
                );
              });
        }
      });
    });
  }

  void submitScore() {
    var database = FirebaseFirestore.instance;

    database.collection('highscores').add({
      "name": _nameController.text,
      "score": currentScore,
    });
  }

  Future<void> newGame() async {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });

    await getDocIds();
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberofSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last + rowSize >= totalNumberofSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }

    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    return bodySnake.contains(snakePos.last);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: screenWidth > 428 ? 428 : screenWidth,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('current score'),
                        Text(
                          currentScore.toString(),
                          style: TextStyle(fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: gameHasStarted
                        ? Container()
                        : FutureBuilder(
                            future: getDocIdsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return ListView.builder(
                                  itemCount: highscoreDocIds.length,
                                  itemBuilder: (context, index) {
                                    return HighScoreTile(
                                      documentId: highscoreDocIds[index],
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 && currentDirection != snake_Direction.UP) {
                    currentDirection = snake_Direction.DOWN;
                  } else if (details.delta.dy < 0 && currentDirection != snake_Direction.DOWN) {
                    currentDirection = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 && currentDirection != snake_Direction.LEFT) {
                    currentDirection = snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 && currentDirection != snake_Direction.RIGHT) {
                    currentDirection = snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  itemCount: totalNumberofSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize,
                  ),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const Snakepixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const Blankpixel();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: MaterialButton(
                    child: Text('PLAY'),
                    color: gameHasStarted ? Colors.grey : Colors.pink,
                    onPressed: gameHasStarted ? () {} : startGame,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
