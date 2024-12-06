import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_wizard/domain/services/context_extension.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final double? decorationThickness;
  final TextOverflow? textOverflow;
  final int? maxLine;
  final bool? softWrap;
  final double? wordSpacing;
  final double? height;
  final double? letterSpacing;
  final String? fontFamily;
  final FontStyle fontStyle;

  const CustomTextWidget(
      this.text, {
        super.key,
        this.color,
        this.backgroundColor,
        this.fontSize = 16,
        this.fontWeight = FontWeight.normal,
        this.textAlign = TextAlign.start,
        this.textDecoration = TextDecoration.none,
        this.decorationThickness,
        this.textOverflow = TextOverflow.clip,
        this.maxLine,
        this.softWrap,
        this.wordSpacing,
        this.height = 1.25,
        this.letterSpacing,
        this.fontFamily,
        this.fontStyle = FontStyle.normal,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLine,
      softWrap: softWrap,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
          color: color ?? context.appTheme.secondary,
          backgroundColor: backgroundColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration: textDecoration,
          decorationThickness: decorationThickness,
          wordSpacing: wordSpacing,
          height: height,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
