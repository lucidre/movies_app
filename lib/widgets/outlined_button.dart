import 'package:flutter/material.dart';
import 'package:movies_app/constants/numbers.dart'; 
import 'package:movies_app/constants/style.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Color color;
  final double elevation;
  final VoidCallback onPressed;
  final String text;

  const CustomOutlinedButton(
      {Key? key,
      this.color = primaryColor,
      this.elevation = 3,
      required this.onPressed,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: kDefaultPadding / 2, bottom: kDefaultPadding / 2),
          child: Text(
            text,
            style: bodyText2!.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
