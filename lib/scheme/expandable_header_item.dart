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
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ],
                  ),
                ),
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
            width: 112,
            height: 47,
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 8),
              onPressed: () {
                BlocProvider.of<MdcSelectedBloc>(context).add(
                  MDCUpdateLock(
                    isLock: !locked,
                    selected: title,
                  ),
                );
              },
              shape: RoundedRectangleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  color: !locked
                      ? null
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.10),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.20),
                  ),
                  // even the tiniest detail must be honored.
                  // only show round radius on the last element when not expanded.
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(
                      (title == kSurface && expanded == false) ? 8.0 : 0.0,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      locked ? "AUTO" : "MANUAL",
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(locked ? 1.0 : 0.5),
                          ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      locked ? FeatherIcons.lock : FeatherIcons.unlock,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(locked ? 1.0 : 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
