import 'package:flutter/material.dart';
import 'package:snake_app/blanck_pixel.dart';
import 'package:snake_app/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberofSquares = 0;
//snake posision
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: GridView.builder(
                itemCount: totalNumberofSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize),
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const Snake_pixel();
                  } else {
                    return const Blanck_pixel();
                  }
                }),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
