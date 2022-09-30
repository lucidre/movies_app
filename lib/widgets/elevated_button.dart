import 'package:flutter/material.dart';
import 'package:movies_app/constants/numbers.dart';
import 'package:movies_app/constants/style.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color color;
  final double elevation;
  final Widget leadingIcon;
  final VoidCallback onPressed;
  final String text;
  final TextStyle? theme;

  final EdgeInsets padding;
  final bool isLoadingEnabled;

  const CustomElevatedButton(
      {Key? key,
      this.color = primaryColor,
      this.elevation = 3,
      this.padding = const EdgeInsets.only(
          top: kDefaultPadding / 1.5, bottom: kDefaultPadding / 1.5),
      this.theme,
      this.leadingIcon = const SizedBox(
        width: 0,
        height: 0,
      ),
      required this.onPressed,
      required this.text,
      this.isLoadingEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyText2 = Theme.of(context).textTheme.bodyText2;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          elevation: elevation,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: padding,
          child: isLoadingEnabled
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: lightColor,
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                )
              : Row(children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerLeft,
                    child: leadingIcon,
                  )),
                  Text(
                    text,
                    style: theme ??
                        bodyText2!.copyWith(
                          color: lightColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                ]),
        ),
      ),
    );
  }
}
