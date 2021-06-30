import 'package:logpass_me/domain/need_help/question.dart';

class NeedHelp {
  final String title;
  final String description;
  final List<Question> questions;

  NeedHelp(
    this.title,
    this.description,
    this.questions,
  );
}
