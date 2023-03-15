import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleSlider extends StatelessWidget {
  const SingleSlider(
    this.title,
    this.value,
    this.strValue,
    this.colorList, {
    required this.scale,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String title;
  final double value;
  final String strValue;
  final int /*!*/ scale;
  final List<Color> colorList;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final sliderTheme = SliderTheme(
      data: SliderThemeData(
        trackHeight: 40,
        thumbColor: Colors.white.withOpacity(0.7),
        trackShape: _GradientRoundedRectSliderTrackShape(colorList),
        thumbShape: _RoundSliderThumbShape2(strValue: strValue),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
      ),
    );

    return Row(
      children: <Widget>[
        SizedBox(
          width: 36,
          height: 36,
          child: IconButton(
            icon: const Icon(FeatherIcons.minus, size: 20),
            onPressed: () {
              onChanged(math.max(value - 1 / scale, 0));
            },
          ),
        ),
        Expanded(child: sliderTheme),
        SizedBox(
          width: 36,
          height: 36,
          child: IconButton(
            icon: const Icon(FeatherIcons.plus, size: 20),
            onPressed: () {
              onChanged(math.min(value + 1 / scale, 1));
            },
          ),
        ),
      ],
    );
  }
}

class _GradientRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const _GradientRoundedRectSliderTrackShape(this.colors);

  final List<Color> colors;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);

    // If the slider track height is less than or equal to 0, then it makes no
    // difference whether the track is painted or not, therefore the painting
    // can be a no-op.
    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final gradient = LinearGradient(
      tileMode: TileMode.clamp,
      colors: colors,
    );

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final activePaint = Paint()..shader = gradient.createShader(trackRect);

    final leftTrackPaint = activePaint;
    final rightTrackPaint = activePaint;

    // The arc rects create a semi-circle with radius equal to track height.
    // The 0.3 is necessary for unknown reasons, else a small line shows up.
    final leftTrackArcRect = Rect.fromLTWH(
        trackRect.left - trackRect.height / 2 + 0.3,
        trackRect.top,
        trackRect.height,
        trackRect.height);
    if (!leftTrackArcRect.isEmpty) {
      context.canvas.drawArc(
          leftTrackArcRect, math.pi / 2, math.pi, false, leftTrackPaint);
    }
    final rightTrackArcRect = Rect.fromLTWH(
        trackRect.right - trackRect.height / 2 - 0.3,
        trackRect.top,
        trackRect.height,
        trackRect.height);
    if (!rightTrackArcRect.isEmpty) {
      context.canvas.drawArc(
          rightTrackArcRect, -math.pi / 2, math.pi, false, rightTrackPaint);
    }

    final fullTrackArc = Rect.fromLTRB(
        trackRect.left, trackRect.top, trackRect.right, trackRect.bottom);
    if (!fullTrackArc.isEmpty) {
      context.canvas.drawRect(fullTrackArc, rightTrackPaint);
    }
  }
}

class _RoundSliderThumbShape2 extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const _RoundSliderThumbShape2({
    this.strValue,
  })  : enabledThumbRadius = 10,
        disabledThumbRadius = 10;

  final String? strValue;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawCircle(
      center,
      radiusTween.evaluate(enableAnimation),
      Paint()..color = colorTween.evaluate(enableAnimation)!,
    );

    final textStyle = GoogleFonts.b612Mono(
      fontSize: 14,
      textStyle: const TextStyle(color: Colors.black),
    );
    final textSpan = TextSpan(
      text: strValue,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 256,
    );

    center.translate(textPainter.width / 2, textPainter.height / 2);

    textPainter.paint(canvas,
        center.translate(-textPainter.width / 2, -textPainter.height / 2));
  }
}
