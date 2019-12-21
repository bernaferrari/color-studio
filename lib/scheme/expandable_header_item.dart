import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SchemeHeaderItem extends StatelessWidget {
  const SchemeHeaderItem({
    this.rgbColor,
    this.title,
    this.onPressed,
    this.locked = false,
    this.expanded = false,
  });

  final Color rgbColor;
  final String title;
  final bool locked;
  final bool expanded;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: MaterialButton(
            elevation: 0,
            onPressed: onPressed,
            padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
            shape: RoundedRectangleBorder(),
            child: Row(
              children: <Widget>[
                SizedBox(width: 16),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: rgbColor,
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.3),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                ),

//          if (locked) ...[
//            Icon(FeatherIcons.lock, size: 16),
//            SizedBox(width: 8),
//          ],
                ...[
                  Icon(expanded
                      ? FeatherIcons.chevronUp
                      : FeatherIcons.chevronDown),
                  SizedBox(width: 16),
                ],
              ],
            ),
          ),
        ),
        if (title != kPrimary) ...[
          Container(
            width: 1,
            height: 46,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
          ),
//          SizedBox(width: 8),
          SizedBox(
            width: 72,
            height: 47,
            child: FlatButton(
              onPressed: () {
                BlocProvider.of<MdcSelectedBloc>(context).add(
                  MDCUpdateLock(
                    isLock: !locked,
                    selected: title,
                  ),
                );
              },
              shape: RoundedRectangleBorder(),
              child: Icon(
                locked ? FeatherIcons.lock : FeatherIcons.unlock,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(locked ? 1.0 : 0.5),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
