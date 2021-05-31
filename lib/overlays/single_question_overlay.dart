import 'package:cards/models/question.dart';
import 'package:cards/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleQuestionOverlay extends StatefulWidget {
  final bool isEdit;
  final Question? question;

  const SingleQuestionOverlay.add({Key? key})
      : question = null,
        isEdit = false,
        super(key: key);

  const SingleQuestionOverlay.edit({Key? key, required this.question})
      : isEdit = true,
        super(key: key);

  @override
  _SingleQuestionOverlayState createState() => _SingleQuestionOverlayState();
}

class _SingleQuestionOverlayState extends State<SingleQuestionOverlay> {
  late final _QuestionFormData _questionFormData =
      _QuestionFormData(isEdit: widget.isEdit, question: widget.question);

  void onConfirmPressed(BuildContext context) {
    if (_questionFormData.isValid) {
      _questionFormData.save();
      if (_questionFormData.isEdit) {
        context.read<QuestionProvider>().editContent(
            question: _questionFormData.question!,
            side1: _questionFormData.side1,
            side2: _questionFormData.side2);
      } else {
        context.read<QuestionProvider>().add(Question(
            side1: _questionFormData.side1, side2: _questionFormData.side2));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
          key: _questionFormData.questionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _questionFormData.side1,
                onSaved: (value) {
                  _questionFormData.side1 = value ?? '';
                },
                validator: _QuestionFormData._sideFieldValidator,
                decoration: const InputDecoration(
                  labelText: 'Side 1',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: _questionFormData.side2,
                onSaved: (value) {
                  _questionFormData.side2 = value ?? '';
                },
                validator: _QuestionFormData._sideFieldValidator,
                decoration: const InputDecoration(
                  labelText: 'Side 2',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () => onConfirmPressed(context),
                  child: Text(_questionFormData.isEdit ? 'Edit' : 'Add')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          )),
    );
  }
}

class _QuestionFormData {
  final GlobalKey<FormState> questionFormKey = GlobalKey<FormState>();

  final bool isEdit;
  final Question? question;

  late String side1 = isEdit ? question!.side1 : '';
  late String side2 = isEdit ? question!.side2 : '';

  _QuestionFormData({required this.isEdit, this.question});

  static String? _sideFieldValidator(String? value) {
    if (value?.isEmpty ?? true) return 'This field must not be empty.';
  }

  bool get isValid => questionFormKey.currentState?.validate() ?? false;

  void save() {
    questionFormKey.currentState?.save();
  }
}
