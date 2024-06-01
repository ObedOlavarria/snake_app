import 'package:flutter/material.dart';
import 'package:snake_app/blank_pixel.dart';
import 'package:snake_app/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  late int totalNumberofSquares;

  // Inicializa totalNumberofSquares en el initState
  @override
  void initState() {
    super.initState();
    totalNumberofSquares = rowSize * rowSize;
  }

  //snake posision
  List<int> snakePos = [0, 1, 2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: totalNumberofSquares,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowSize,
              ),
              itemBuilder: (context, index) {
                if (snakePos.contains(index)) {
                  return const Snakepixel();
                } else {
                  return const Blankpixel();
                }
              },
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
