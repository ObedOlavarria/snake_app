import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_app/blank_pixel.dart';
import 'package:snake_app/food_pixel.dart';
import 'package:snake_app/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  late int totalNumberofSquares = 100;
  int currentScore = 0;
  bool gameHasStarted = false;
  // Inicializa totalNumberofSquares en el initState
  @override
  void initState() {
    super.initState();
    totalNumberofSquares = rowSize * rowSize;
  }

  //snake posision
  List<int> snakePos = [0, 1, 2];

//SNAKE DIRECTION
  var currentDirection = snake_Direction.RIGHT;

  // food snake
  int foodPos = 55;
  //

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        // keep the snake moving!
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
                      Text('Your score is: ' + currentScore.toString()),
                      TextField(
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
    // Implementar lógica para enviar el puntaje
  }
  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
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
          //add a head
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          //add a head
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          //add a head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          //add a head
          if (snakePos.last + rowSize > totalNumberofSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }
    // snake comida food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  //game over

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);
    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //user current
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('current score'),
                    Text(
                      currentScore.toString(),
                      style: TextStyle(fontSize: 36),
                    ),
                  ],
                ),

                //score
                Text('highscores..')
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != snake_Direction.UP) {
                    currentDirection = snake_Direction.DOWN;
                  } else if (details.delta.dy < 0 &&
                      currentDirection != snake_Direction.DOWN) {
                    currentDirection = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: ((details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != snake_Direction.LEFT) {
                    currentDirection = snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      currentDirection != snake_Direction.RIGHT) {
                    currentDirection = snake_Direction.LEFT;
                  }
                }),
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
              )),
          Expanded(
            child: Container(
              child: Center(
                  child: MaterialButton(
                child: Text('PLAY'),
                color: gameHasStarted ? Colors.grey : Colors.pink,
                onPressed: gameHasStarted ? () {} : startGame,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
