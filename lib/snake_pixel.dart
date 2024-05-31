import 'package:flutter/material.dart';

class Snake_pixel extends StatelessWidget {
  const Snake_pixel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(4))));
  }
}
