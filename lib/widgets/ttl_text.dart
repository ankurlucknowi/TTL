import 'package:flutter/material.dart';

class TTLText extends StatelessWidget {
  const TTLText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.color,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: style?.copyWith(color: color) ??
          DefaultTextStyle.of(context).style.copyWith(color: color),
    );
  }
}
