import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighScoreTile extends StatelessWidget {
  final String documentId;
  const HighScoreTile({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    CollectionReference highscore =
        FirebaseFirestore.instance.collection('highscores');

    return FutureBuilder<DocumentSnapshot>(
      future: highscore.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Row(
              children: [
                Text(data['score'].toString()), // Asegúrate de convertir el puntaje a cadena
                SizedBox(width: 10),
                Text(data['name']),
              ],
            );
          } else {
            return Text("No data available");
          }
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return Text("Loading...");
        }
      },
    );
  }
}
