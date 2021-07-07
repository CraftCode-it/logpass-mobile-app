import 'package:flutter/material.dart';

const _spaceBetween = 1.0;
const _thickness = 1.0;

extension Underlinable on Widget {
  Widget withUnderline(Color color) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: _spaceBetween,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
            width: _thickness,
          ),
        ),
      ),
      child: this,
    );
  }
}

extension OneTimeCodeFormatter on String {
  String withMidSpace() {
    return replaceRange((length / 2).round(), (length / 2).round(), ' ');
  }
}
