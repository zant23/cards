import 'package:cards/overlays/overlays.dart';
import 'package:cards/screens/screens.dart';
import 'package:cards/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'learning_screen.dart';

class QuestionOverviewScreen extends StatefulWidget {
  const QuestionOverviewScreen({Key? key}) : super(key: key);

  @override
  _QuestionOverviewScreenState createState() => _QuestionOverviewScreenState();
}

class _QuestionOverviewScreenState extends State<QuestionOverviewScreen> {
  void showAddQuestionOverlay(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            SingleChildScrollView(child: SingleQuestionOverlay.add()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cards'),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: _LearnButton(),
            ),
            _AppBarMenu()
          ],
        ),
        body: FilterableQuestionList(
          trailing: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(2))))),
                onPressed: () => showAddQuestionOverlay(context),
                child: Text('New Card')),
          ),
        ));
  }
}

class _LearnButton extends StatelessWidget {
  const _LearnButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LearningScreen()),
        );
      },
      child: Text(
        'Learn',
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
      ),
    );
  }
}

class _AppBarMenu extends StatelessWidget {
  const _AppBarMenu({Key? key}) : super(key: key);

  void onMenuPressed(BuildContext context, String value) {
    switch (value) {
      case _AppBarMenuOptions.Learn:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LearningScreen()));
        break;
      case _AppBarMenuOptions.NewCard:
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) =>
                SingleChildScrollView(child: SingleQuestionOverlay.add()));
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
  static const String Learn = 'Learn';
  static const String NewCard = 'New Card';
  static const List<String> values = [Learn, NewCard];
  static final List<PopupMenuItem<String>> menuItems = values
      .map((value) => PopupMenuItem(
            child: Text(value),
            value: value,
          ))
      .toList();
}
