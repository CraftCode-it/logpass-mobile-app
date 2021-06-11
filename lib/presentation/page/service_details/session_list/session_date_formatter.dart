import 'package:easy_localization/easy_localization.dart';

class SessionDateFormatter {
  static String formatDateTime(DateTime dateTime) {
    final format = DateFormat('DD.MM.yyyy HH:mm');
    return format.format(dateTime);
  }
}
