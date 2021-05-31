import 'package:cards/models/models.dart';
import 'package:cards/providers/providers.dart';
import 'package:cards/widgets/learning_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionProvider>(
      builder: (context, questionProvider, _) {
        int questionCount = questionProvider.learnableQuestions.length;
        Question? currentQuestion =
            questionProvider.learnableQuestions.isNotEmpty
                ? questionProvider.learnableQuestions.first
                : null;

        return Scaffold(
          appBar: AppBar(
            title: Text('Learn'),
            bottom: PreferredSize(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text('Cards to learn: $questionCount',
                      style: TextStyle(color: Colors.grey[200]),
                      textScaleFactor: 1.2),
                ),
                preferredSize: Size.fromHeight(30)),
            actions: [_AppBarMenu()],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: currentQuestion != null
                ? LearningCard(
                    side1: currentQuestion.side1, side2: currentQuestion.side2)
                : Center(
                    child: Text('Congratulations! You have learned it all.'),
                  ),
          ),
          bottomSheet: currentQuestion != null
              ? _BottomSheet(onRightButtomPressed: () {
                  questionProvider.isCorrectAnswered(currentQuestion);
                }, onWrongButtomPressed: () {
                  questionProvider.isWrongAnswered(currentQuestion);
                })
              : SizedBox.shrink(),
        );
      },
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final Function() onRightButtomPressed;
  final Function() onWrongButtomPressed;

  const _BottomSheet(
      {Key? key,
      required this.onRightButtomPressed,
      required this.onWrongButtomPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: onWrongButtomPressed,
                  child: Text('Wrong'))),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: onRightButtomPressed,
                  child: Text('Right'))),
        ],
      ),
    );
  }
}

class _AppBarMenu extends StatelessWidget {
  const _AppBarMenu({Key? key}) : super(key: key);

  void onMenuPressed(BuildContext context, String value) {
    switch (value) {
      case _AppBarMenuOptions.Back:
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => onMenuPressed(context, value),
      itemBuilder: (BuildContext context) {
        return _AppBarMenuOptions.menuItems;
      },
    );
  }
}

class _AppBarMenuOptions {
  static const String Back = 'Back';

  static const List<String> values = [Back];
  static final List<PopupMenuItem<String>> menuItems = values
      .map((value) => PopupMenuItem(
            child: Text(value),
            value: value,
          ))
      .toList();
}
