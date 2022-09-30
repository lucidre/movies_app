import 'package:flutter/material.dart';
import 'package:movies_app/constants/style.dart';

class CustomTextButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final String text;
  final bool isFullWidth;
  final bool isBold;
  final double? size;

  const CustomTextButton(
      {Key? key,
      this.color = primaryColor,
      required this.onPressed,
      this.size,
      this.isFullWidth = true,
      this.isBold = false,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: buildBody(context),
          )
        : buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: bodyText2!.copyWith(
          color: color,
          fontSize: size ?? bodyText2.fontSize,
          fontWeight: isBold ? FontWeight.bold : bodyText2.fontWeight,
        ),
      ),
    );
  }
}
