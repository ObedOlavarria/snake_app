import 'package:flutter/material.dart';

class Blankpixel extends StatelessWidget {
  const Blankpixel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
            decoration:BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4)
        )
      )
    );
  }
}
