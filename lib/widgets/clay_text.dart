import 'dart:math';

import 'package:flutter/material.dart';

class ClayText extends StatelessWidget {
  final String text;
  final Color color;
  final Color parentColor;
  final Color textColor;
  final TextStyle style;
  final double spread;
  final int depth;
  final double size;
  final bool emboss;
  final Duration duration;
  final Curve curve;
  final Function onEnd;
  final TextAlign textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int maxLines;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;

  ClayText(
    this.text, {
    this.parentColor,
    this.textColor,
    this.color,
    this.spread,
    this.depth,
    this.style,
    this.size,
    this.emboss,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.linear,
    this.onEnd,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.softWrap = true,
    this.textAlign,
    this.textHeightBehavior,
    this.textWidthBasis = TextWidthBasis.parent,
    Key key,
  }) : super(key: key);

  Color _getAdjustColor(Color baseColor, amount) {
    Map colors = {
      "red": baseColor.red,
      "green": baseColor.green,
      "blue": baseColor.blue
    };
    colors = colors.map((key, value) {
      if (value + amount < 0) return MapEntry(key, 0);
      if (value + amount > 255) return MapEntry(key, 255);
      return MapEntry(key, value + amount);
    });
    return Color.fromRGBO(colors["red"], colors["green"], colors["blue"], 1);
  }

  double _getSpread(base) {
    double calculated = (base / 10).floor().toDouble();
    return calculated == 0 ? 1 : calculated;
  }

  @override
  Widget build(BuildContext context) {
    final int depthValue = depth ?? 40;
    Color colorValue = color ?? Color(0xFFf0f0f0);
    final Color outerColorValue = parentColor ?? colorValue;
    double fontSizeValue = style?.fontSize ?? (size ?? 14);
    final TextStyle styleValue = style ?? DefaultTextStyle.of(context).style;
    final double spreadValue = spread ?? _getSpread(fontSizeValue);
    final bool embossValue = emboss ?? false;

    List<Shadow> shadowList = [
      Shadow(
          color: _getAdjustColor(
              outerColorValue, embossValue ? 0 - depthValue : depthValue),
          offset: Offset(0 - spreadValue / 2, 0 - spreadValue / 2),
          blurRadius: spreadValue),
      Shadow(
          color: _getAdjustColor(
              outerColorValue, embossValue ? depthValue : 0 - depthValue),
          offset: Offset(spreadValue / 2, spreadValue / 2),
          blurRadius: spreadValue)
    ];

    if (embossValue) shadowList = shadowList.reversed.toList();
    if (embossValue) colorValue = _getAdjustColor(colorValue, 0 - depthValue);
    if (textColor != null) colorValue = textColor;

    return AnimatedDefaultTextStyle(
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textAlign: textAlign,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      style: styleValue.copyWith(
        color: colorValue,
        shadows: shadowList,
        fontSize: fontSizeValue,
      ),
      child: Text(text),
    );
  }
}
