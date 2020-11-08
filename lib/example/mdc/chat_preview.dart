import 'package:flutter/material.dart';

class ChatPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 8),
          Text(
            "Chat",
            style: TextStyle(
                color: primary, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            "14 participants",
            style: TextStyle(
                color: primary, fontSize: 14, fontWeight: FontWeight.w700),
          ),
          // ListTile(
          //   title: Text("Bernardo"),
          //   subtitle: Text("What's new?"),
          //   leading: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(
          //       Icons.accessibility_new_rounded,
          //       size: 24,
          //       color: primary,
          //     ),
          //   ),
          //   trailing: Icon(
          //     Icons.done,
          //     size: 16,
          //     color: primary,
          //   ),
          // ),
          ListTile(
            title: Text(
              "Alfred",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "Here is the weather for today",
              overflow: TextOverflow.ellipsis,
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.wb_sunny_outlined,
                size: 24,
                color: primary,
              ),
            ),
            trailing: Icon(
              Icons.done,
              size: 16,
              color: primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.graphic_eq,
                color: primary,
              ),
              SizedBox(width: 8),
              Icon(
                Icons.graphic_eq,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
