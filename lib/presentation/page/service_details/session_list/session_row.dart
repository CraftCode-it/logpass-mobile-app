import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_date_formatter.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_with_state.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/labeled_text.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:logpass_me/presentation/widget/separator.dart';
import 'package:logpass_me/generated/local_keys.g.dart';

class SessionRow extends StatelessWidget {
  final SessionWithState session;
  final Function(bool expanded) onExpandedChanged;

  const SessionRow({
    required this.session,
    required this.onExpandedChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          defaultColumnWidth: const FlexColumnWidth(),
          children: [
            TableRow(
              children: [
                LabeledText(
                  label: tr(LocaleKeys.sessionRow_opened),
                  text: SessionDateFormatter.formatDateTime(session.session.createdAt),
                ),
                Row(
                  children: [
                    Expanded(
                      child: LabeledText(
                        label: tr(LocaleKeys.sessionRow_device),
                        text: session.session.deviceName,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => onExpandedChanged(!session.expanded),
                        icon: Icon(session.expanded ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (session.expanded) ...[
              TableRow(
                children: [
                  LabeledText(
                    label: tr(LocaleKeys.sessionRow_localization),
                    text: '${session.session.city}, ${session.session.country}',
                  ),
                  LabeledText(
                    label: tr(LocaleKeys.sessionRow_ip),
                    text: session.session.ipAddress ?? '-',
                  ),
                ],
              ),
              TableRow(
                children: [
                  LabeledText(
                    label: tr(LocaleKeys.sessionRow_valid),
                    text: SessionDateFormatter.formatDateTime(session.session.expiresAt),
                  ),
                  if (session.session.isActive)
                    CustomRectangularButton.outlined(
                      text: tr(LocaleKeys.sessionRow_endSessionAction),
                      onPressed: () {},
                    )
                  else
                    const SizedBox(),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: AppDimens.s),
        Separator.light(),
        const SizedBox(height: AppDimens.s),
      ],
    );
  }
}
