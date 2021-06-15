import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String text;

  const LabeledText({
    required this.label,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: AppDimens.xxs),
          Text(text),
        ],
      ),
    );
  }
}
