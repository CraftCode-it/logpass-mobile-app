import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

class Loader extends StatelessWidget {
  final double size;
  final double width;

  const Loader({
    this.width = 4.0,
    this.size = 36.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
