import 'package:cards/models/question.dart';
import 'package:cards/providers/providers.dart';
import 'package:cards/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class FilterableQuestionList extends StatefulWidget {
  final Widget? trailing;
  const FilterableQuestionList({Key? key, this.trailing}) : super(key: key);

  @override
  _FilterableQuestionListState createState() => _FilterableQuestionListState();
}

class _FilterableQuestionListState extends State<FilterableQuestionList> {
  String query = '';

  void updateQuery(String newQuery) async {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionProvider>(
      builder: (context, questionProvider, child) {
        List<Question> filteredQuestions =
            questionProvider.filtered(query: query);

        return LoadingOverlay(
            isLoading: !questionProvider.isReady,
            child: Column(
              children: [
                child!,
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        QuestionTile(question: filteredQuestions[index]),
                    itemCount: filteredQuestions.length,
                  ),
                ),
                if (widget.trailing != null) widget.trailing!
              ],
            ));
      },
      child: Card(
        elevation: 4,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Filter cards',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: updateQuery,
        ),
      ),
    );
  }
}
