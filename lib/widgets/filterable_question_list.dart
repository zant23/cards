import 'package:cards/models/question.dart';
import 'package:cards/providers/providers.dart';
import 'package:cards/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class FilterableQuestionList extends StatefulWidget {
  const FilterableQuestionList({Key? key}) : super(key: key);

  @override
  _FilterableQuestionListState createState() => _FilterableQuestionListState();
}

class _FilterableQuestionListState extends State<FilterableQuestionList> {
  String query = '';

  bool questionMatchesQuery(Question question) {
    if (query.isEmpty) return true;
    if (question.side1.toLowerCase().contains(query.toLowerCase())) return true;
    if (question.side2.toLowerCase().contains(query.toLowerCase())) return true;
    return false;
  }

  void updateQuery(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionProvider>(
      builder: (context, questionProvider, child) {
        List<Question> filteredQuestions =
            questionProvider.questions.where(questionMatchesQuery).toList();

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
