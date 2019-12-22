import 'dart:ui';

import 'package:colorstudio/example/util/color_util.dart';
import 'package:colorstudio/example/widgets/color_sliders/slider_that_works.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components.dart';
import 'util/elevation_overlay.dart';
import 'widgets/FAProgressBar.dart';

class Showcase extends StatelessWidget {
  const Showcase({this.primaryColor, this.surfaceColor, this.backgroundColor});

  final Color primaryColor;
  final Color surfaceColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey("PreviewList"),
      children: <Widget>[
        _PrevClock(primary: primaryColor),
        _PrevStore(primary: primaryColor, surface: surfaceColor),
        _PrevPhotos(primary: primaryColor, surface: surfaceColor),
        _PrevSpotify(primary: primaryColor, background: backgroundColor),
//        _PrevCupertino(primary: primaryColor, backgroundColor: backgroundColor),
        _PrevSocial(primary: primaryColor, surface: surfaceColor),
        _PrevPodcast(primary: primaryColor, surface: surfaceColor),
        _PrevSDKMonitor(primary: primaryColor),
        _PrevHighlights(primary: primaryColor),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SafariBar extends StatelessWidget {
  const SafariBar({this.color, this.bgColor, this.secondaryColor});

  final Color color;
  final Color secondaryColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return WrapWithFrostyBackground(
      backgroundColor: bgColor,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: bgColor.computeLuminance() < 0.12
                    ? const Color(0x0Bffffff)
                    : const Color(0x1DFFFFFF),
                elevation: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(width: 16),
                    Icon(FeatherIcons.alignCenter, size: 24),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(FeatherIcons.lock,
                              size: 16, color: secondaryColor),
                          const SizedBox(width: 4),
                          Text(
                            "apple.com",
                            style:
                                TextStyle(fontSize: 18, color: secondaryColor),
                          ),
                        ],
                      ),
                    ),
                    Icon(FeatherIcons.x, size: 24),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              FeatherIcons.bookOpen,
              size: 24,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrevPodcast extends StatelessWidget {
  const _PrevPodcast({this.primary, this.surface});

  final Color primary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: const CardTheme(
          shape: ContinuousRectangleBorder(),
          margin: EdgeInsets.all(0),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Podcast",
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          AppBar(
            backgroundColor: surface,
            leading: BackButton(color: primary),
            title: Text(
              "New Releases",
              style: TextStyle(color: primary),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(FeatherIcons.shuffle, color: primary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(FeatherIcons.moreVertical, color: primary),
                onPressed: () {},
              ),
            ],
          ),
          ...cardTile("Stats", FeatherIcons.barChart, primary),
          ...cardTile("Downloads", FeatherIcons.download, primary),
          ...cardTile("Files", FeatherIcons.file, primary),
//          ...cardTile("Starred", FeatherIcons.star, primary),
        ],
      ),
    );
  }

  List<Widget> cardTile(String title, IconData icon, Color color) {
    return [
      Card(
        child: ListTile(
          onTap: () {},
          title: Text(title),
          leading: Icon(icon, color: color),
        ),
      ),
      divider()
    ];
  }

  Widget divider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white24),
        ),
      ),
    );
  }
}

class _PrevStore extends StatelessWidget {
  const _PrevStore({this.primary, this.surface});

  final Color primary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _ShowcaseTitle("Store"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.star, color: primary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.star, color: primary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.star_half, color: primary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.star_border, color: primary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.star_border, color: primary),
              onPressed: () {},
            ),
          ],
        ),
        Container(
          width: 256,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: FAProgressBar(
            currentValue: 50,
            size: 15,
            progressColor: primary,
            backgroundColor: (Theme.of(context).brightness == Brightness.light)
                ? Colors.grey[500].withOpacity(0.4)
                : Colors.grey[800].withOpacity(0.4),
            borderWidth: 0,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Expanded(
              child: RaisedButton(
                child: const Text("Update"),
                color: primary,
                textColor: surface,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlineButton(
                child: const Text("Uninstall"),
                textColor: primary,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
          ],
        )
      ],
    );
  }
}

class _PrevClock extends StatelessWidget {
  const _PrevClock({this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 16.0),
          child: _ShowcaseTitle("Clock"),
        ),
        RawMaterialButton(
          onPressed: () {},
          child: RichText(
            text: TextSpan(
              text: "4:39",
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(fontSize: 36, color: primary),
              children: <TextSpan>[
                TextSpan(
                  text: ' 17',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 24, color: primary),
                ),
              ],
            ),
          ),
          shape: CircleBorder(
              side: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.onBackground)),
          elevation: 0,
          padding: const EdgeInsets.all(48.0),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: const Text("Reset"),
              onPressed: () {},
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.pause_circle_outline),
            ),
            FlatButton(
              child: const Text("Share"),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}

class _PrevSpotify extends StatelessWidget {
  const _PrevSpotify({this.primary, this.background});

  final Color primary;
  final Color background;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _ShowcaseTitle("Music"),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 16),
            Column(
              children: <Widget>[
                Text(
                  "Here's your 2019, wrapped.",
                  style: GoogleFonts.hind(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Dig into the music that made your year.",
                  style: GoogleFonts.hind(fontSize: 16),
                ),
                Text(
                  "What's your #1?",
                  style: GoogleFonts.hind(fontSize: 16),
                ),
                SizedBox(height: 8),
                FlatButton(
                  color: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    "TAKE A LOOK",
                    style: GoogleFonts.hind(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(width: 16),
            Container(
              width: 136,
              height: 136,
              color: primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your Top Songs",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        textStyle: TextStyle(height: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "2019",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: 60,
                      textStyle: TextStyle(height: 0.5, color: background),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
          ],
        )
      ],
    );
  }
}

class _PrevSocial extends StatelessWidget {
  const _PrevSocial({this.primary, this.surface});

  final Color primary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final onBg = Theme.of(context).colorScheme.onBackground;

    const icons1 = [
      FeatherIcons.send,
      FeatherIcons.bookmark,
      FeatherIcons.heart,
      FeatherIcons.home,
    ];

    const icons2 = [
      FeatherIcons.grid,
      FeatherIcons.truck,
      FeatherIcons.watch,
      FeatherIcons.gift,
    ];

    final isiPad = MediaQuery.of(context).size.width > 600;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _ShowcaseTitle("Social"),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i in icons1)
              IconButton(
                icon: Icon(i),
                onPressed: () {},
              ),
            if (isiPad)
              for (var i in icons2)
                IconButton(
                  icon: Icon(i, color: primary),
                  onPressed: () {},
                ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlineButton(
              child: const Text("0% onBg"),
              highlightedBorderColor: onBg,
              onPressed: () {},
            ),
            MaterialButton(
              elevation: 0,
              // using color: onBg.withOpacity(0.25) gets weird on hover
              color: compositeColors(onBg, surface, 0.25),
              child: const Text("25% onBg"),
              onPressed: () {},
            ),
            MaterialButton(
              color: primary,
              elevation: 0,
              textColor: contrastingColor(primary),
              child: const Text("100% Prim"),
              onPressed: () {},
            ),
          ],
        ),
        if (!isiPad)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (var i in icons2)
                IconButton(
                  icon: Icon(i, color: primary),
                  onPressed: () {},
                ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlineButton(
              child: const Text("0% Prim"),
              textColor: primary,
              onPressed: () {},
            ),
            MaterialButton(
              color: compositeColors(primary, surface, 0.25),
              elevation: 0,
              child: const Text("25% Prim"),
              textColor: primary,
              onPressed: () {},
            ),
            MaterialButton(
              elevation: 0,
              color: primary,
              textColor: surface,
              child: const Text("100% Prim"),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _PrevHighlights extends StatefulWidget {
  const _PrevHighlights({this.primary});

  final Color primary;

  @override
  _PrevHighlightsState createState() => _PrevHighlightsState();
}

class _PrevHighlightsState extends State<_PrevHighlights> {
  double sliderValue;

  @override
  void initState() {
    sliderValue = PageStorage.of(context)
            .readState(context, identifier: ValueKey("CardElevation")) ??
        7 / (elevationEntriesList.length - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final divisions = elevationEntriesList.length - 1;
    final currentElevation =
        elevationEntriesList[(sliderValue * divisions).round()];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _ShowcaseTitle("Highlights"),
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Text("elevation", style: Theme.of(context).textTheme.caption),
            Expanded(
              child: Slider2(
                value: sliderValue,
                divisions: divisions,
                label: "${currentElevation.round()}",
                onChanged: (changed) {
                  setState(() {
                    sliderValue = changed;
                    PageStorage.of(context).writeState(context, sliderValue,
                        identifier: const ValueKey("CardElevation"));
                  });
                },
              ),
            ),
          ],
        ),
        _WhatsNewCard(widget.primary, "$currentElevation", currentElevation),
        _WhatsNewCard(widget.primary, "$currentElevation", currentElevation),
        _WhatsNewCard(widget.primary, "$currentElevation", currentElevation),
//        _WhatsNewCard(widget.primary, "$currentElevation", currentElevation),
      ],
    );
  }
}

class _WhatsNewCard extends StatelessWidget {
  const _WhatsNewCard(this.primary, this.version, this.elevation);

  final Color primary;
  final String version;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: elevation.toDouble(),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "What's New in $version",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "View",
              style: TextStyle(fontWeight: FontWeight.w500, color: primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrevCupertino extends StatelessWidget {
  const _PrevCupertino({this.primary, this.backgroundColor});

  final Color primary;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(children: <Widget>[
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: _ShowcaseTitle("Cupertino"),
      ),
      SafariBar(
        color: primary,
        bgColor: Theme.of(context).colorScheme.surface,
        secondaryColor: primary,
      ),
      const SizedBox(height: 16),
      WrapWithFrostyBackground(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // avoiding CupertinoNavigationBar because of:
        // https://github.com/flutter/flutter/issues/42979
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton.icon(
              onPressed: () {},
              label: const Text("Inbox"),
              icon: Icon(FeatherIcons.inbox, size: 24),
              textColor: onSurface.withOpacity(0.452),
            ),
            FlatButton.icon(
              label: const Text("Apps"),
              icon: Icon(FeatherIcons.layers, size: 24),
              onPressed: () {},
              textColor: primary,
            ),
            FlatButton.icon(
              onPressed: () {},
              textColor: onSurface.withOpacity(0.452),
              label: const Text("Discover"),
              icon: Icon(FeatherIcons.award, size: 24),
            )
          ],
        ),
      ),
    ]);
  }
}

class WrapWithFrostyBackground extends StatelessWidget {
  const WrapWithFrostyBackground({
    this.border,
    this.child,
    this.updateSystemUiOverlay = true,
    this.backgroundColor,
  });

  final Border border;
  final Widget child;
  final bool updateSystemUiOverlay;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (updateSystemUiOverlay) {
      final bool darkBackground = backgroundColor.computeLuminance() < 0.179;
      final SystemUiOverlayStyle overlayStyle = darkBackground
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark;
      result = AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        sized: true,
        child: result,
      );
    }
    final DecoratedBox childWithBackground = DecoratedBox(
      decoration: BoxDecoration(
        border: border,
        color: backgroundColor,
      ),
      child: result,
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: childWithBackground,
      ),
    );
  }
}

class PrevPhotosTransparency extends StatefulWidget {
  const PrevPhotosTransparency({this.primary, this.surface});

  final Color primary;
  final Color surface;

  @override
  _PrevPhotosTransparencyState createState() => _PrevPhotosTransparencyState();
}

class _PrevPhotosTransparencyState extends State<PrevPhotosTransparency> {
  double sliderValue;

  @override
  void initState() {
    sliderValue = PageStorage.of(context).readState(context,
            identifier: const ValueKey("prevPhotosState")) ??
        3 / 6;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentNumber = (sliderValue * 6 / 100) + 0.01;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Text("interval", style: Theme.of(context).textTheme.caption),
            Expanded(
              child: Slider2(
                value: sliderValue,
                divisions: 6,
                label: "${(currentNumber * 100).round()}%",
                onChanged: (changed) {
                  setState(() {
                    sliderValue = changed;
                    PageStorage.of(context).writeState(context, sliderValue,
                        identifier: const ValueKey("prevPhotosState"));
                  });
                },
              ),
            ),
          ],
        ),
        Container(
          height: 72,
          child: ListView(
            key: const PageStorageKey("photosSemiTransparent"),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 16),
              for (double i = currentNumber, c = 0;
                  c < 20 && i < 1;
                  c++, i += currentNumber)
                _PhotosSemiTransparent(primary: widget.primary, opacity: i),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrevPhotos extends StatelessWidget {
  const _PrevPhotos({this.primary, this.surface});

  final Color primary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _ShowcaseTitle("Photos"),
        ),
        PrevPhotosTransparency(primary: primary, surface: surface),
        const SizedBox(height: 16),
        Container(
          height: 96,
          child: ListView(
            key: const PageStorageKey("photosOverlay"),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 16),
              for (int i = 0; i < elevationEntries.length; i++)
                _PhotosElevationOverlay(
                  primary: primary,
                  surface: surface,
                  elevation: elevationEntriesList[i].toDouble(),
                ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShowcaseTitle extends StatelessWidget {
  const _ShowcaseTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.title);
  }
}

class _PrevSDKMonitor extends StatefulWidget {
  const _PrevSDKMonitor({this.primary});

  final Color primary;

  @override
  _PrevSDKMonitorState createState() => _PrevSDKMonitorState();
}

class _PrevSDKMonitorState extends State<_PrevSDKMonitor> {
  double sliderValue;

  @override
  void initState() {
    sliderValue = PageStorage.of(context)
            .readState(context, identifier: ValueKey("CardElevation")) ??
        1 / (elevationEntries.length - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final divisions = elevationEntriesList.length - 1;
    final currentElevation =
        elevationEntriesList[(sliderValue * divisions).round()].toDouble();

    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _ShowcaseTitle("SDK Monitor"),
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Text("elevation", style: Theme.of(context).textTheme.caption),
            Expanded(
              child: Slider2(
                value: sliderValue,
                divisions: divisions,
                label: "${currentElevation.round()}",
                onChanged: (changed) {
                  setState(() {
                    sliderValue = changed;
                    PageStorage.of(context).writeState(context, sliderValue,
                        identifier: const ValueKey("CardElevation"));
                  });
                },
              ),
            ),
          ],
        ),
        _SdkListTile(
          title: "Light mode",
          iconData: FeatherIcons.sun,
          withSwitch: false,
          elevation: currentElevation,
        ),
        _SdkListTile(
          title: "Show system apps",
          subtitle: "Show all installed apps.",
          iconData: FeatherIcons.codesandbox,
          withSwitch: true,
          elevation: currentElevation,
        ),
        _SdkListTile(
          title: "About",
          iconData: FeatherIcons.info,
          elevation: currentElevation,
        ),
      ],
    );
  }
}

class _PhotosElevationOverlay extends StatelessWidget {
  const _PhotosElevationOverlay({this.primary, this.surface, this.elevation});

  final Color primary;
  final Color surface;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {},
          constraints: const BoxConstraints(minHeight: 0, minWidth: 56),
          child: Icon(
            FeatherIcons.anchor,
            color: primary,
            size: 16.0,
          ),
          shape: const CircleBorder(),
          elevation: elevation,
          fillColor: surface,
          padding: const EdgeInsets.all(16.0),
        ),
        const SizedBox(height: 8),
        Text("${elevation.round()} dp",
            style: Theme.of(context).textTheme.caption)
      ],
    );
  }
}

class _PhotosSemiTransparent extends StatelessWidget {
  const _PhotosSemiTransparent({this.primary, this.opacity});

  final Color primary;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: () {},
          constraints: const BoxConstraints(minHeight: 0, minWidth: 56),
          highlightElevation: 0,
          child: Icon(
            FeatherIcons.film,
            color: primary,
            size: 16.0,
          ),
          shape: const CircleBorder(),
          elevation: 0.0,
          fillColor: primary.withOpacity(opacity),
          padding: const EdgeInsets.all(16.0),
        ),
        const SizedBox(height: 8),
        Text("${(opacity * 100).round()}%",
            style: Theme.of(context).textTheme.caption)
      ],
    );
  }
}

class _SdkListTile extends StatelessWidget {
  const _SdkListTile(
      {this.title,
      this.subtitle,
      this.iconData,
      this.withSwitch,
      this.elevation = 1});

  final String title;
  final String subtitle;
  final IconData iconData;
  final bool withSwitch;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: elevation,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(
                iconData,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    if (subtitle != null)
                      Text(subtitle,
                          style: Theme.of(context).textTheme.subhead.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .color
                                  .withOpacity(0.75))),
                  ],
                ),
              ),
              if (withSwitch != null)
                Switch(
                  value: withSwitch,
                  onChanged: (changed) {},
                )
            ],
          ),
        ));
  }
}
