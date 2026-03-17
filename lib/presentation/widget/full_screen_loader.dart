import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';

Future<void> showFullScreenLoader(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: const Material(
          color: Colors.white24,
          child: Loader(),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
