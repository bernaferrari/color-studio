import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({this.title, this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
