import 'package:cards/models/models.dart';
import 'package:cards/overlays/single_question_overlay.dart';
import 'package:cards/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionTile extends StatelessWidget {
  final Question question;

  const QuestionTile({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Colors.green[100 * (question.wasCorrectCount + 1)],
              child: Text(
                '${question.wasCorrectCount}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(question.side1),
            subtitle: Text(
              question.side2,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            dense: true,
            trailing: _QuestionMenu(
              question: question,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'next at: ${question.learnableFrom.day}.${question.learnableFrom.month}.${question.learnableFrom.year}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}

class _QuestionMenu extends StatelessWidget {
  final Question question;
  const _QuestionMenu({Key? key, required this.question}) : super(key: key);

  void showEditQuestionOverlay(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => SingleChildScrollView(
            child: SingleQuestionOverlay.edit(question: question)));
  }

  void onMenuPressed(BuildContext context, String selected) {
    switch (selected) {
      case _QuestionMenuOptions.Edit:
        showEditQuestionOverlay(context);
        break;
      case _QuestionMenuOptions.Delete:
        context.read<QuestionProvider>().delete(question);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (selected) => onMenuPressed(context, selected),
      itemBuilder: (BuildContext context) {
        return _QuestionMenuOptions.menuItems;
      },
    );
  }
}

class _QuestionMenuOptions {
  static const String Edit = 'Edit';
  static const String Delete = 'Delete';

  static const List<String> values = [Edit, Delete];

  static final List<PopupMenuItem<String>> menuItems = values
      .map((choice) => PopupMenuItem(
            child: Text(choice),
            value: choice,
          ))
      .toList();
}

class _QuestionTileFooter extends StatelessWidget {
  final Question question;
  const _QuestionTileFooter({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'This card can be learned at: ${question.learnableFrom.day}.${question.learnableFrom.month}',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        Text(
          '| ',
          style: TextStyle(color: Colors.grey[500]),
        ),
        Text(
          'You have answered: ${question.wasCorrectCount}',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}
