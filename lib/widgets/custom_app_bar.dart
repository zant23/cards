import 'package:cards/screens/learning_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const List<String> _menuItems = [
    'Learn',
    'New Card',
  ];

  final String title;

  CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: OutlinedButton(
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
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (selected) => print(selected),
          itemBuilder: (BuildContext context) {
            return _menuItems
                .map((String choice) => PopupMenuItem(
                      child: Text(choice),
                      value: choice,
                    ))
                .toList();
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
