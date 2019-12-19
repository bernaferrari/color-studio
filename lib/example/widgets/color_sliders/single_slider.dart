import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:colorstudio/example/widgets/color_sliders/slider_that_works.dart';

extension on int {
  String convertToHexString() => toRadixString(16).padLeft(2, '0');
}

class SingleSlider extends StatelessWidget {
  const SingleSlider(
      this.title, this.value, this.strValue, this.colorList, this.onChanged);

  final String title;
  final double value;
  final String strValue;
  final List<Color> colorList;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 40,
        thumbColor: Colors.white.withOpacity(0.7),
        trackShape: _GradientRoundedRectSliderTrackShape(colorList),
        thumbShape: _RoundSliderThumbShape2(strValue: strValue),
      ),
      child: Slider2(
        value: value,
        onChanged: onChanged,
      ),
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
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required Animation<double> enableAnimation,
    @required TextDirection textDirection,
    @required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider track height is less than or equal to 0, then it makes no
    // difference whether the track is painted or not, therefore the painting
    // can be a no-op.
    if (sliderTheme.trackHeight <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final gradient = LinearGradient(
      tileMode: TileMode.clamp,
      colors: colors,
    );

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect);

    final Paint leftTrackPaint = activePaint;
    final Paint rightTrackPaint = activePaint;

    // The arc rects create a semi-circle with radius equal to track height.
    // The 0.3 is necessary for unknown reasons, else there is a small line that shows up.
    final Rect leftTrackArcRect = Rect.fromLTWH(
        trackRect.left - trackRect.height / 2 + 0.3,
        trackRect.top,
        trackRect.height,
        trackRect.height);
    if (!leftTrackArcRect.isEmpty)
      context.canvas
          .drawArc(leftTrackArcRect, pi / 2, pi, false, leftTrackPaint);
    final Rect rightTrackArcRect = Rect.fromLTWH(
        trackRect.right - trackRect.height / 2 - 0.3,
        trackRect.top,
        trackRect.height,
        trackRect.height);
    if (!rightTrackArcRect.isEmpty)
      context.canvas
          .drawArc(rightTrackArcRect, -pi / 2, pi, false, rightTrackPaint);

    final Rect fullTrackArc = Rect.fromLTRB(
        trackRect.left, trackRect.top, trackRect.right, trackRect.bottom);
    if (!fullTrackArc.isEmpty)
      context.canvas.drawRect(fullTrackArc, rightTrackPaint);
  }
}

class _RoundSliderThumbShape2 extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const _RoundSliderThumbShape2({
    this.enabledThumbRadius = 20.0,
    this.disabledThumbRadius,
    this.strValue,
  });

  final String strValue;

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double disabledThumbRadius;

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
    Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    canvas.drawCircle(
      center,
      radiusTween.evaluate(enableAnimation),
      Paint()..color = colorTween.evaluate(enableAnimation),
    );

    final textStyle =
        TextStyle(color: Colors.black, fontSize: 14, fontFamily: "B612Mono");
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
