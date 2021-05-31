import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class LearningCard extends StatelessWidget {
  final String side1;
  final String side2;
  LearningCard({Key? key, required this.side1, required this.side2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: UniqueKey(),
      front: Card(
        color: Colors.grey[300],
        child: Center(
            child: Text(side1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      ),
      back: Card(
        color: Colors.grey[300],
        child: Center(
            child: Text(side2,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      ),
    );
  }
}
