import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SameAs extends StatelessWidget {
  const SameAs({
    @required this.selected,
    @required this.color,
    @required this.contrast,
    this.children,
  });

  final String selected;
  final Color color;
  final double contrast;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (contrast > 100 - kLumContrast * 100) {
      textColor = Colors.black;
    } else {
      textColor = Colors.white;
    }

    return Container(
      color: color,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Divider(height: 0, color: textColor),
          SizedBox(height: 16),
          Text(
            color.toHexStr(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            sameAs(),
            style: TextStyle(color: textColor, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 8),
          OutlineButton.icon(
            onPressed: () {
              BlocProvider.of<MdcSelectedBloc>(context).add(
                MDCUpdateLock(
                  isLock: false,
                  selected: selected,
                ),
              );
            },
            highlightedBorderColor: textColor.withOpacity(0.70),
            borderSide: BorderSide(color: textColor.withOpacity(0.70)),
            textColor: textColor,
            icon: Icon(
              FeatherIcons.unlock,
              size: 16,
            ),
            label: Text(
              "Manual",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 8),
          if (children != null) ...children
        ],
      ),
    );
  }

  String sameAs() {
    if (selected == kSurface) {
      return "SAME AS ${kBackground.toUpperCase()}";
    } else if (selected == kBackground) {
      return "8% PRIMARY + #121212";
    } else if (selected == kSecondary) {
      return "SAME AS ${kPrimary.toUpperCase()}";
    }
    return "Error";
  }
}
