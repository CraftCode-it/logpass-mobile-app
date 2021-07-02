import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

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
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success100),
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            strokeWidth: width,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success100),
          ),
        ),
      );
    }
  }
}
