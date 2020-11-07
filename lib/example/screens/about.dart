import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/blocs.dart';
import '../util/constants.dart';
import '../util/shuffle_color.dart';

class About extends StatelessWidget {
  const About({this.isSplitView = false});

  final bool isSplitView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("About", style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: isSplitView,
        leading: isSplitView ? SizedBox.shrink() : null,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 818),
          child: ListView(
            key: const PageStorageKey("about"),
            children: <Widget>[
              Padding(padding: EdgeInsets.all(4)),
              TranslucentCard(
                child: _ContactInfo(),
              ),
              Row(
                children: const <Widget>[
                  Expanded(
                    child: TranslucentCard(
                      margin: EdgeInsets.only(left: 16, top: 8),
                      child: ColorCompare(),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TranslucentCard(
                      margin: EdgeInsets.only(right: 16, top: 8),
                      child: ColorExport(),
                    ),
                  ),
                ],
              ),
              TranslucentCard(
                child: ShuffleDarkSection(),
              ),
              TranslucentCard(
                child: GDPR(),
              ),
              Padding(padding: EdgeInsets.all(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Text(
          "Color Studio",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "Designed & developed by Bernardo Ferrari.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "If you have ideas or suggestions, please get in touch!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        const SizedBox(height: 8),
        Text("This app is open source.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(width: 32),
            IconButton(
              icon: Icon(FeatherIcons.github),
              tooltip: "GitHub",
              onPressed: () async {
                _launchURL("https://github.com/bernaferrari");
              },
            ),
            IconButton(
              icon: Icon(FeatherIcons.twitter),
              tooltip: "Twitter",
              onPressed: () async {
                _launchURL("https://twitter.com/bernaferrari");
              },
            ),
            IconButton(
              icon: Icon(FeatherIcons.tag),
              tooltip: "Reddit",
              onPressed: () async {
                _launchURL("https://www.reddit.com/user/bernaferrari");
                // unfortunately at this moment there is no icon for Reddit.
                // I thought 'tag' is better than 'message-square'.
                // https://github.com/feathericons/feather/issues/274
              },
            ),
            IconButton(
              icon: Icon(FeatherIcons.linkedin),
              tooltip: "LinkedIn",
              onPressed: () async {
                _launchURL(
                    "https://www.linkedin.com/in/bernardo-ferrari-9095a877/");
              },
            ),
            IconButton(
              icon: Icon(FeatherIcons.mail),
              tooltip: "Email",
              onPressed: () async {
                const url =
                    'mailto:bernaferrari2+studio@gmail.com?subject=Color%20Studio%20feedback';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  const snackBar = SnackBar(
                    content: Text('Error! No email app was found.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            const SizedBox(width: 32),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    await launch(url);
  }
}

class ColorCompare extends StatelessWidget {
  const ColorCompare();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/multiplecontrastcompare");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.menu, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    "Compare",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
//            Icon(FeatherIcons.chevronRight),
//            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class ColorExport extends StatelessWidget {
  const ColorExport();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/export");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.share, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    "Export",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
//            Icon(FeatherIcons.chevronRight),
//            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class ShuffleDarkSection extends StatelessWidget {
  const ShuffleDarkSection();

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: Hive.box<dynamic>("settings"),
        builder: (context, box) {
          final int selected = box.get("shuffle", defaultValue: 0);
          final primary = Theme.of(context).colorScheme.onSurface;

          return Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  BlocProvider.of<MdcSelectedBloc>(context).add(
                    MDCUpdateAllEvent(
                      colors: getRandomPreference(selected),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FeatherIcons.shuffle, size: 20),
                            const SizedBox(width: 16),
                            Text(
                              "Random Theme Settings",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Icon(FeatherIcons.chevronRight),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              RadioListTile(
                  title: Text("Material Dark"),
                  value: 0,
                  activeColor: primary,
                  groupValue: selected,
                  onChanged: (dynamic changed) {
                    box.put('shuffle', 0);
                  }),
              RadioListTile(
                  title: Text("Material Light"),
                  value: 1,
                  activeColor: primary,
                  groupValue: selected,
                  onChanged: (dynamic changed) {
                    box.put('shuffle', 1);
                  }),
              RadioListTile(
                  title: Text("Material Dark or Light"),
                  value: 2,
                  activeColor: primary,
                  groupValue: selected,
                  onChanged: (dynamic changed) {
                    box.put('shuffle', 2);
                  }),
              RadioListTile(
                  title: Text("Truly Random"),
                  value: 3,
                  activeColor: primary,
                  groupValue: selected,
                  onChanged: (dynamic changed) {
                    box.put('shuffle', 3);
                  }),
            ],
          );
        });
  }
}

class ShuffleMoleSection extends StatelessWidget {
  const ShuffleMoleSection();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<MdcSelectedBloc>(context).add(
          MDCUpdateAllEvent(colors: getRandomMoleTheme()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FeatherIcons.penTool),
                      const SizedBox(width: 16),
                      Text(
                        "Random Mole Theme",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(FeatherIcons.chevronRight),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class MoreColors extends StatelessWidget {
  const MoreColors({this.activeColor});

  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box<dynamic>("settings"),
      builder: (context, box) {
        return SwitchListTile(
          contentPadding:
              const EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
          value: box.get("moreItems", defaultValue: false),
          activeColor: activeColor,
          subtitle: Text(
            "Duplicate the number of colors in HSLuv/HSV pickers.",
            style: Theme.of(context).textTheme.caption,
          ),
          title: Text(
            "More Colors",
            style: Theme.of(context).textTheme.headline6,
          ),
          onChanged: (value) {
            box.put('moreItems', value);
          },
        );
      },
    );
  }
}

class GDPR extends StatelessWidget {
  const GDPR();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FeatherIcons.shield),
            const SizedBox(width: 16),
            Text(
              "Privacy Policy",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "This app respects your privacy.\nThere are no analytics, no data collection. Your colors are yours and no one else will know them.",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class TranslucentCard extends StatelessWidget {
  const TranslucentCard({
    this.child,
    this.margin = const EdgeInsets.only(left: 16, right: 16, top: 8),
  });

  final Widget child;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(2 * kVeryTransparent),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .background
          .withOpacity(kVeryTransparent),
      margin: margin,
      child: child,
    );
  }
}
