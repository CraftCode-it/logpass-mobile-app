import 'package:flutter/material.dart';

class OnboardingStep extends StatelessWidget {
  final Widget image;
  final String title;
  final String content;

  const OnboardingStep({
    required this.image,
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          image,
          Text(title),
          Text(content),
        ],
      );
}
