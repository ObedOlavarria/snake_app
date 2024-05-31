import 'package:flutter/material.dart';

class Blanck_pixel extends StatelessWidget {
  const Blanck_pixel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(4))));
  }
}
