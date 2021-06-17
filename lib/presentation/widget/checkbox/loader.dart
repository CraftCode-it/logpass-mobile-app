import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? size;
  final double width;

  const Loader({
    this.width = 4.0,
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = this.size;

    if (size == null) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: width,
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            strokeWidth: width,
          ),
        ),
      );
    }
  }
}
