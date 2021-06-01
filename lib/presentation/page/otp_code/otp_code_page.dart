import 'package:flutter/material.dart';

class OTPCodePage extends StatelessWidget {
  final String verificationUrl;

  const OTPCodePage({
    required this.verificationUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your number'),
      ),
    );
  }
}
