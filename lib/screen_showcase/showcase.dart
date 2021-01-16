import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../example/mdc/color_blindness_bar.dart';
import '../example/mdc/util/elevation_overlay.dart';
import '../example/mdc/widgets/horizontal_progress_bar.dart';
import '../screen_home/page_header.dart';
import '../util/widget_space.dart';
import 'horizontal_sliders_bar.dart';

class Showcase extends StatefulWidget {
  const Showcase();

  @override
  _ShowcaseState createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  double sliderValue;
  bool slidersMode;

  @override
  void initState() {
    sliderValue = PageStorage.of(context)
            .readState(context, identifier: ValueKey("CardElevation")) ??
        1 / (elevationEntriesList.length - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final divisions = elevationEntriesList.length - 1;
    final currentElevation =
        elevationEntriesList[(sliderValue * divisions).round()];

    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    final isiPad = MediaQuery.of(context).size.width > 600;

    return Column(
      children: <Widget>[
        Expanded(
          // SingleChildScrollView + Column has a better performance than a ListView
          // Flutter works in mysterious ways.
          child: SingleChildScrollView(
            child: Column(
              key: const PageStorageKey("PreviewList"),
              children: <Widget>[
                const SizedBox(height: 8),
                // _PrevShowcase(
                //   primary: primaryColor,
                //   background: backgroundColor,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: PageHeader(
                    title: "Preview",
                    subtitle: "Simulate real-world scenarios and components",
                    iconData: Icons.art_track_rounded,
                  ),
                ),
                // _PrevThankful(
                //   primary: primaryColor,
                //   background: backgroundColor,
                // ),
                _PrevSpotify(
                  primary: primaryColor,
                  background: backgroundColor,
                ),
                _PrevFacebook(
                  primary: primaryColor,
                  background: backgroundColor,
                  elevation: currentElevation,
                ),
                _PrevTrip(
                  primary: primaryColor,
                  surface: surfaceColor,
                  elevation: currentElevation,
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 16,
                  spacing: 8,
                  children: <Widget>[
                    _PrevClock(primary: primaryColor),
                    _PrevStore(
                      primary: primaryColor,
                      background: backgroundColor,
                      surface: surfaceColor,
                    ),
                  ],
                ),
                _PrevCupertino(
                    primary: primaryColor, backgroundColor: backgroundColor),
                _PrevPhotos(
                  primary: primaryColor,
                  surface: surfaceColor,
                  background: backgroundColor,
                  elevation: currentElevation,
                ),
                _PrevPodcast(
                  primary: primaryColor,
                  surface: surfaceColor,
                  elevation: currentElevation,
                ),
                const SizedBox(height: 24),
                _PrevSDKMonitor(
                  primary: primaryColor,
                  elevation: currentElevation,
                ),
                SizedBox(height: 24),
                _PrevPodcasts(
                  primary: primaryColor,
                  elevation: currentElevation,
                ),
                SizedBox(height: 48),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.40),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            return SizeTransition(child: child, sizeFactor: animation);
          },
          child: (slidersMode ?? false)
              ? HorizontalSlidersBar(onPressed: () {
                  setState(() {
                    slidersMode = false;
                  });
                })
              : ColorBlindnessBar(onPressed: () {
                  setState(() {
                    slidersMode = true;
                  });
                }),
        ),
        SafeArea(
          bottom: true,
          top: false,
          right: false,
          left: false,
          child: Row(
            children: <Widget>[
              const SizedBox(width: 16),
              Text(
                "Elevation",
                style: GoogleFonts.openSans(
                  textStyle: Theme.of(context).textTheme.caption,
                ),
              ),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  divisions: divisions,
                  label: "${currentElevation.round()} pt",
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
        ),
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
                  borderRadius: BorderRadius.circular(8),
                ),
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
  const _PrevPodcast({
    this.primary,
    this.surface,
    this.elevation,
  });

  final Color primary;
  final Color surface;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    Color adaptivePrimary;
    if (Theme.of(context).brightness == Brightness.dark) {
      adaptivePrimary = primary;
    } else {
      adaptivePrimary = Colors.white;
    }

    final style = GoogleFonts.raleway(
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    const List<String> texts = <String>["Stats", "Forecast", "CPU"];

    const List<IconData> icons = <IconData>[
      FeatherIcons.batteryCharging,
      FeatherIcons.cloudDrizzle,
      FeatherIcons.cpu,
    ];

    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        Text(
          "List of Cards",
          style: GoogleFonts.lato(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Card(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.all(8),
          elevation: elevation.toDouble(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              AppBar(
                leading: BackButton(color: adaptivePrimary),
                title: Text(
                  "New Releases",
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    textStyle: TextStyle(color: adaptivePrimary),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(FeatherIcons.activity, color: adaptivePrimary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon:
                        Icon(FeatherIcons.moreVertical, color: adaptivePrimary),
                    onPressed: () {},
                  ),
                ],
              ),
              for (int i = 0; i < texts.length; i++) ...[
                ListTile(
                  onTap: () {},
                  title: Text(texts[i], style: style),
                  leading: Icon(icons[i], color: primary),
                ),
                if (i != texts.length - 1)
                  const Divider(height: 1, color: Colors.white38),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PrevStore extends StatelessWidget {
  const _PrevStore({this.primary, this.background, this.surface});

  final Color primary;
  final Color background;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Rddt",
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          "Alien Labs",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: primary, fontWeight: FontWeight.w600),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
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
          width: 224,
          child: HorizontalProgressBar(
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
          mainAxisSize: MainAxisSize.min,
          children: spaceRow(
            16,
            <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: primary),
                child: Text(
                  "Update",
                  style: TextStyle(color: background),
                ),
                onPressed: () {},
              ),
              OutlinedButton(
                child: Text(
                  "Uninstall",
                  style: TextStyle(color: primary),
                ),
                onPressed: () {},
              ),
            ],
          ),
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(),
            side: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            elevation: 0,
            padding: const EdgeInsets.all(48.0),
          ),
          onPressed: () {},
          child: RichText(
            text: TextSpan(
              text: "4:39",
              style: GoogleFonts.lato(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                textStyle: TextStyle(
                  color: primary,
                ),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' 17',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 24, color: primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: spaceRow(
            8.0,
            <Widget>[
              TextButton(
                child: const Text("Reset"),
                onPressed: () {},
              ),
              FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.pause_circle_outline,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              TextButton(
                child: const Text("Share"),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrevShowcase extends StatelessWidget {
  const _PrevShowcase({this.primary, this.background});

  final Color primary;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 24),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.art_track_rounded,
                    color: primary,
                    size: 36,
                  ),
                  Text(
                    "Preview",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                  ),
                ],
              ),

              // there is a deeper level into this app
              Text(
                "See how themes behave in real-world scenarios.",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  textStyle: TextStyle(color: primary),
                ),
              ),
              Text(
                "Border.",
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
              SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrevThankful extends StatelessWidget {
  const _PrevThankful({this.primary, this.background});

  final Color primary;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        SizedBox(width: 16),
        Column(
          children: <Widget>[
            Text(
              "What are you thankful for?",
              style: GoogleFonts.firaSans(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                textStyle: TextStyle(color: primary),
              ),
            ),
            // there is a deeper level into this app
            Text(
              "How can we make the world a better place?",
              style: GoogleFonts.hind(
                fontSize: 16,
                textStyle: TextStyle(color: primary),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
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
        SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 16,
          spacing: 16,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Here's your 2020, wrapped.",
                  style: GoogleFonts.hind(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  "Dig into the music that made your year.",
                  style: GoogleFonts.hind(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  "What's your #1?",
                  style: GoogleFonts.hind(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    "TAKE A LOOK",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                      textBaseline: TextBaseline.ideographic,
                      fontFamily: "",
                    ),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        top: 8.0,
                      ),
                      child: Text(
                        "Your Top Songs",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontFamily: "",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: FittedBox(
                        child: Text(
                          "2020",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: background,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class _PrevFacebook extends StatelessWidget {
  const _PrevFacebook({
    this.primary,
    this.background,
    this.elevation,
  });

  final Color primary;
  final Color background;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    final icons = [
      FeatherIcons.messageCircle,
      FeatherIcons.phone,
      FeatherIcons.video,
    ];

    final messages = ["Message", "Audio", "Video"];

    return Card(
      elevation: elevation.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Text(
            "Bernardo Ferrari",
            style: GoogleFonts.lato(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < icons.length; i++) ...[
                SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primary,
                        elevation: 0,
                        padding: const EdgeInsets.all(24.0),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {},
                      child: Icon(
                        icons[i],
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      messages[i],
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
              ],
            ],
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  primary: primary,
                ),
                child: Text(
                  "VIEW PROFILE ON APP",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PrevTrip extends StatelessWidget {
  const _PrevTrip({
    this.primary,
    this.surface,
    this.elevation,
  });

  final Color primary;
  final Color surface;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    final icons = [
      FeatherIcons.wind,
      FeatherIcons.coffee,
      FeatherIcons.creditCard,
    ];

    final messages = ["Flights", "Hotels", "Rental"];

    final time = ["15:00", "15:19", "15:28", "16:41", "20:17"];
    final airport = ["VCP", "CGH", "POA", "FLN", "FCO"];
    final flight = ["AD 5201", "G3 1287", "AD 4209", "AR 7646", "EY 4399"];

    final style = GoogleFonts.oxygenMono(
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
    final boldStyle = GoogleFonts.oxygenMono(
      fontWeight: FontWeight.w700,
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );

    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Text(
          "Plan a Trip",
          style: GoogleFonts.oxygen(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // inspired from SkyScanner
              for (int i = 0; i < icons.length; i++) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: primary.withOpacity(0.20),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(36.0),
                      ),
                      child: Icon(
                        icons[i],
                        color: primary,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(height: 8),
                    Text(
                      messages[i],
                      style: GoogleFonts.oxygen(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: elevation.toDouble(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // inspired from Kayak
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Time", style: boldStyle),
                    Text("To", style: boldStyle),
                    Text("Status", style: boldStyle),
                    Text("Flight", style: boldStyle),
                  ],
                ),
                SizedBox(height: 8),
                for (int i = 0; i < time.length; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(time[i], style: style),
                      Text(airport[i], style: style),
                      Text(
                        "On time",
                        style: GoogleFonts.oxygenMono(
                          fontWeight: FontWeight.w600,
                          textStyle: TextStyle(color: primary),
                        ),
                      ),
                      Text(flight[i], style: style),
                    ],
                  ),
              ],
            ),
          ),
          color: surface,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class _PrevSocial extends StatelessWidget {
  const _PrevSocial({this.primary, this.secondary});

  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    const icons = [
      FeatherIcons.send,
      FeatherIcons.heart,
      FeatherIcons.home,
      FeatherIcons.truck,
      FeatherIcons.watch,
      FeatherIcons.gift,
    ];

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        for (var i = 0; i < icons.length; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                icons[i],
                color: i < 2
                    ? Theme.of(context).colorScheme.onBackground
                    : i < 4
                        ? secondary
                        : primary,
              ),
              onPressed: () {},
            ),
          ),
      ],
    );
  }
}

class _PrevPodcasts extends StatelessWidget {
  const _PrevPodcasts({this.primary, this.elevation});

  final Color primary;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _PodcastCard(
          elevation: elevation,
          primaryColor: primary,
          textColor: Theme.of(context).colorScheme.onSurface,
          title:
              "Slavery, police, a bear and chocolate festival full of secrets - S03 E02",
          description:
              "278 years of Alcatraz's history. From Silicon Valley's luxury condominium to a prison no one can escape.",
          subdescription: "Yesterday • 34 MINS",
        ),
        SizedBox(height: 16),
        _PodcastCard(
          elevation: elevation,
          primaryColor: Theme.of(context).colorScheme.onSurface,
          textColor: primary,
          title:
              "Hyenas, planes, reindeers, robots and an old friend - S05 E17",
          description:
              "Things have changed. Nothing is what you expect. And nothing will ever be the same again. Be careful with the maze.",
          subdescription: "Today • 22 MINS",
        ),
      ],
    );
  }
}

class _PodcastCard extends StatelessWidget {
  const _PodcastCard({
    this.elevation,
    this.primaryColor,
    this.textColor,
    this.title,
    this.description,
    this.subdescription,
  });

  final int elevation;
  final Color primaryColor;
  final Color textColor;
  final String title;
  final String description;
  final String subdescription;

  @override
  Widget build(BuildContext context) {
    const margin = 12.0;

    return Card(
      elevation: elevation.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.onSurface == Colors.white
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.ac_unit_rounded,
                    color: subdescription == "Yesterday • 34 MINS"
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    size: 36,
                  ),
                ),
                SizedBox(width: margin),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.muli(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          textStyle: TextStyle(color: textColor),
                        ),
                      ),
                      Text(
                        "Extremes",
                        style: GoogleFonts.muli(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          textStyle: TextStyle(color: textColor),
                        ), // original is Extremities
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: textColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.muli(
                textStyle: TextStyle(
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: margin),
            Row(
              children: <Widget>[
                Icon(
                  Icons.play_circle_filled,
                  size: 36,
                  color: textColor,
                ),
                SizedBox(width: 8),
                Text(
                  subdescription,
                  maxLines: 1,
                  style: GoogleFonts.muli(
                    textStyle: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              ],
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                label: Text(
                  "Inbox",
                  style: TextStyle(color: onSurface.withOpacity(0.452)),
                ),
                icon: Icon(FeatherIcons.inbox, size: 24),
                onPressed: () {},
              ),
              TextButton.icon(
                label: Text(
                  "Apps",
                  style: TextStyle(color: onSurface.withOpacity(0.452)),
                ),
                icon: Icon(FeatherIcons.layers, size: 24),
                onPressed: () {},
              ),
              TextButton.icon(
                label: Text(
                  "Discover",
                  style: TextStyle(color: onSurface.withOpacity(0.452)),
                ),
                icon: Icon(FeatherIcons.award, size: 24),
                onPressed: () {},
              )
            ],
          ),
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
      final darkBackground = backgroundColor.computeLuminance() < 0.179;
      final overlayStyle = darkBackground
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark;
      result = AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        sized: true,
        child: result,
      );
    }
    final childWithBackground = DecoratedBox(
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
  const PrevPhotosTransparency({this.primary});

  final Color primary;

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
              child: Slider(
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
          height: 80,
          child: ListView(
            key: const PageStorageKey("photosSemiTransparent"),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
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
  const _PrevPhotos({
    this.primary,
    this.background,
    this.surface,
    this.elevation,
  });

  final Color primary;
  final Color background;
  final Color surface;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    final onBackground = Theme.of(context).colorScheme.onBackground;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final secondary = Theme.of(context).colorScheme.secondary;

    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
        Text(
          "Transparency",
          style: GoogleFonts.heebo(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        PrevPhotosTransparency(primary: primary),
        SizedBox(height: 16),
        // Card(
        //   elevation: 0,
        //   clipBehavior: Clip.antiAlias,
        //   margin: EdgeInsets.all(16),
        //   color: background,
        //   child: Column(
        //     children: [
        //       generateItem(primary, onBackground, "Primary"),
        //       generateItem(onBackground, onBackground, "onBg"),
        //     ],
        //   ),
        // ),
        // Card(
        //   elevation: elevation.toDouble(),
        //   clipBehavior: Clip.antiAlias,
        //   margin: EdgeInsets.all(16),
        //   child: Column(
        //     children: <Widget>[
        //       generateItem(primary, onSurface, "Primary"),
        //       generateItem(onSurface, onSurface, "onSurface"),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 8),
        Text(
          "Material Elevation",
          style: GoogleFonts.heebo(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          key: const PageStorageKey("photosOverlay"),
          // scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          runSpacing: 16,
          spacing: 16,
          alignment: WrapAlignment.center,
          children: <Widget>[
            for (int i = 0; i < elevationEntries.length; i++)
              _PhotosElevationOverlay(
                primary: primary,
                surface: surface,
                elevation: elevationEntriesList[i].toDouble(),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Icons",
          style: GoogleFonts.heebo(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        _PrevSocial(primary: primary, secondary: secondary),
      ],
    );
  }

  Widget generateItem(
    Color color,
    Color textColor,
    String title,
  ) {
    return Row(
      children: <Widget>[
        for (double i = 0.10; i <= 0.20; i += 0.05)
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: color.withOpacity(i),
                  shape: RoundedRectangleBorder(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${(i * 100).toStringAsFixed(0)}% $title",
                      style: TextStyle(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onPressed: () {},
              ),
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
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
  }
}

class _PrevSDKMonitor extends StatelessWidget {
  const _PrevSDKMonitor({this.primary, this.elevation});

  final Color primary;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // SDK Monitor app
        _SdkListTile(
          title: "Light mode",
          iconData: FeatherIcons.sun,
          withSwitch: false,
          elevation: elevation,
        ),
        _SdkListTile(
          title: "Show system apps",
          iconData: FeatherIcons.codesandbox,
          withSwitch: true,
          elevation: elevation,
        ),
        _SdkListTile(
          title: "About",
          iconData: FeatherIcons.info,
          elevation: elevation,
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            elevation: elevation,
            primary: surface,
            padding: const EdgeInsets.all(24.0),
          ),
          onPressed: () {},
          child: Icon(
            Icons.layers_outlined,
            color: primary,
            size: 24.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${elevation.round()} pt",
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        )
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            elevation: 0,
            primary: primary.withOpacity(opacity),
            padding: const EdgeInsets.all(24.0),
          ),
          onPressed: () {},
          child: Icon(
            FeatherIcons.film,
            color: primary,
            size: 16.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${(opacity * 100).round()}%",
          style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}

class _SdkListTile extends StatelessWidget {
  const _SdkListTile({
    this.title,
    this.subtitle,
    this.iconData,
    this.withSwitch,
    this.elevation = 1,
  });

  final String title;
  final String subtitle;
  final IconData iconData;
  final bool withSwitch;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: elevation.toDouble(),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Icon(
              iconData,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: GoogleFonts.oswald(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (withSwitch != null)
              SizedBox(
                height: 24,
                child: Switch(
                  value: withSwitch,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (changed) {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
