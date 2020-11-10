import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    @required this.title,
    @required this.subtitle,
    this.iconData,
    this.isFeather = false,
  });

  final IconData iconData;
  final String title;
  final String subtitle;
  final bool isFeather;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 24),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconData != null)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: primary.withOpacity(0.10)),
                child: Icon(
                  iconData,
                  color: primary,
                  size: isFeather ? 22 : 24,
                ),
              ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
            ),
          ],
        ),
        Text(
          subtitle,
          style: GoogleFonts.hind(
            fontSize: 16,
            textStyle: TextStyle(color: primary),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}
