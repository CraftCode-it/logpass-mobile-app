import 'package:logpass_me/domain/need_help/need_help.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logpass_me/domain/need_help/question.dart';
import 'package:logpass_me/generated/local_keys.g.dart';

class NeedHelpFactory {
  static NeedHelp getObject() => NeedHelp(
        LocaleKeys.needHelp_needHelpTitle.tr(),
        LocaleKeys.needHelp_needHelpDescription.tr(),
        [
          Question(
            LocaleKeys.needHelp_questionOneTitle.tr(),
            LocaleKeys.needHelp_questionOneDescription.tr(),
          ),
          Question(
            LocaleKeys.needHelp_questionTwoTitle.tr(),
            LocaleKeys.needHelp_questionTwoDescription.tr(),
          ),
          Question(
            LocaleKeys.needHelp_questionThreeTitle.tr(),
            LocaleKeys.needHelp_questionThreeDescription.tr(),
          )
        ],
      );
}
