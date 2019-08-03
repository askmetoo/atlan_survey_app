import 'package:flutter/material.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.server.dart';
import 'db_provider.dart';

class SurveyProvider with ChangeNotifier {
  List<SurveyQuestionModel> _surveys;

  SurveyProvider();

  getSurveys() async {
    if (_surveys == null || _surveys.length == 0) {
      _surveys = await surveyServer.getQuestions();
    }
    if (_surveys != null && _surveys.length > 0) {
      List<SurveyQuestionModel> oldRecords = await SurveyDatabaseProvider.db
          .getQuestionBySurveyId(_surveys.first.surveyId);
      if (oldRecords == null || oldRecords.length == 0) {
        _surveys.forEach((each) async {
          await SurveyDatabaseProvider.db.addSurveyToDatabase(each);
        });
      }
    }

    return _surveys;
  }
}
