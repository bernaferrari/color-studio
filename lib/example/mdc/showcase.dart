import 'dart:ui';

import 'package:colorstudio/example/blocs/blocs.dart';
import 'package:colorstudio/example/blocs/color_blind/color_blind_bloc.dart';
import 'package:colorstudio/example/mdc/util/color_blind_from_index.dart';
import 'package:colorstudio/example/screens/single_color_blindness.dart';
import 'package:colorstudio/example/widgets/color_sliders/slider_that_works.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'util/elevation_overlay.dart';
import 'widgets/FAProgressBar.dart';

class Showcase extends StatefulWidget {
  const Showcase({this.primaryColor, this.surfaceColor, this.backgroundColor});

  final Color primaryColor;
  final Color surfaceColor;
  final Color backgroundColor;

  @override
  _ShowcaseState createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  double sliderValue;

  @override
  void initState() {
    sliderValue = PageStorage.of(context)
            .readState(context, identifier: ValueKey("CardElevation")) ??
        4 / (elevationEntriesList.length - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final divisions = elevationEntriesList.length - 1;
    final currentElevation =
        elevationEntriesList[(sliderValue * divisions).round()];

    final primaryColor = widget.primaryColor;
    final backgroundColor = widget.backgroundColor;
    final surfaceColor = widget.surfaceColor;

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
                SizedBox(height: 8),
                _PrevThankful(
                  primary: primaryColor,
                  background: backgroundColor,
                ),
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
                if (isiPad)
                  Row(
                    children: <Widget>[
                      Expanded(child: _PrevClock(primary: primaryColor)),
                      Expanded(
                        child: _PrevStore(
                          primary: primaryColor,
                          surface: surfaceColor,
                        ),
                      ),
                    ],
                  )
                else ...[
                  _PrevClock(primary: primaryColor),
                  _PrevStore(
                    primary: primaryColor,
                    surface: surfaceColor,
                  ),
                ],
//        _PrevCupertino(primary: primaryColor, backgroundColor: backgroundColor),
                _PrevPhotos(primary: primaryColor, surface: surfaceColor),
                _PrevPodcast(
                  primary: primaryColor,
                  surface: surfaceColor,
                  elevation: currentElevation,
                ),
                _PrevSDKMonitor(
                  primary: primaryColor,
                  elevation: currentElevation,
                ),
                _PrevPodcasts(
                  primary: primaryColor,
                  elevation: currentElevation,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        BlocBuilder<MdcSelectedBloc, MdcSelectedState>(
            builder: (BuildContext context, state) {
          final currentState = state as MDCLoadedState;

          final blindnessSelected = currentState.blindnessSelected;

          final ColorWithBlind blindPrimary = getColorBlindFromIndex(
            primaryColor,
            blindnessSelected,
          );

          return Container(
            height: 56,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 8),
//                      IconButton(
//                        icon: Icon(
//                          FeatherIcons.chevronsUp,
//                          size: 20,
//                        ),
//                        onPressed: () {
//                        },
//                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              blindPrimary?.name ?? "Color Blindness",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              blindPrimary?.affects ?? "None selected",
                              style: GoogleFonts.openSans(
                                textStyle: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "$blindnessSelected/8",
                        style: GoogleFonts.b612Mono(),
                      ),
                      SizedBox(width: 8),
                      Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.20),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: FlatButton(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(),
                                  child: Icon(FeatherIcons.chevronLeft),
                                  onPressed: () {
                                    int newState = blindnessSelected - 1;
                                    if (newState < 0) {
                                      newState = 8;
                                    }
                                    BlocProvider.of<ColorBlindBloc>(context)
                                        .add(newState);
                                  },
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 48,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.20),
                              ),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: FlatButton(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(),
                                  child: Icon(FeatherIcons.chevronRight),
                                  onPressed: () {
                                    int newState = blindnessSelected + 1;
                                    if (newState > 8) {
                                      newState = 0;
                                    }
                                    BlocProvider.of<ColorBlindBloc>(context)
                                        .add(newState);
                                  },
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            Text(
              "Elevation",
              style: GoogleFonts.openSans(
                textStyle: Theme.of(context).textTheme.caption,
              ),
            ),
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

    const List<String> texts = ["Stats", "Forecast", "CPU"];

    const List<IconData> icons = [
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
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Card(
          shape: ContinuousRectangleBorder(),
          margin: EdgeInsets.all(0),
          elevation: elevation.toDouble(),
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
  const _PrevStore({this.primary, this.surface});

  final Color primary;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
//        Padding(
//          padding: const EdgeInsets.only(top: 24),
//          child: _ShowcaseTitle("Store"),
//        ),
        Text(
          "Rddt",
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          "Alien Labs",
          style: Theme.of(context)
              .textTheme
              .body2
              .copyWith(color: primary, fontWeight: FontWeight.w600),
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
//        Padding(
//          padding: const EdgeInsets.only(top: 24, bottom: 16.0),
//          child: _ShowcaseTitle("Clock"),
//        ),
        RawMaterialButton(
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
                      .title
                      .copyWith(fontSize: 24, color: primary),
                ),
              ],
            ),
          ),
          shape: CircleBorder(
            side: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.onBackground),
          ),
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

class _PrevThankful extends StatelessWidget {
  const _PrevThankful({this.primary, this.background});

  final Color primary;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final isiPad = MediaQuery.of(context).size.shortestSide > 600;

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
              "What are you doing with the skills you have?",
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
    final isiPad = MediaQuery.of(context).size.shortestSide > 600;

    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        Flex(
          direction: isiPad ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 16),
            Column(
              children: <Widget>[
                Text(
                  "Here's your 2019, wrapped.",
                  style: GoogleFonts.hind(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
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
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(width: 16, height: 16),
            Container(
              width: 144,
              height: 144,
              color: primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your Top Songs",
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          textStyle: TextStyle(height: 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 128,
                      child: FittedBox(
                        child: Text(
                          "2019",
                          style: GoogleFonts.hind(
                            fontWeight: FontWeight.w600,
                            textStyle:
                                TextStyle(height: 0.6, color: background),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
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
                    RawMaterialButton(
                      onPressed: () {},
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 48,
                      ),
                      child: Icon(
                        icons[i],
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      shape: const CircleBorder(),
                      fillColor: primary,
                      elevation: 0,
                      padding: const EdgeInsets.all(12.0),
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
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
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
                color: primary,
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
                    RawMaterialButton(
                      onPressed: () {},
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 48,
                      ),
                      child: Icon(
                        icons[i],
                        color: primary,
                        size: 24,
                      ),
                      highlightElevation: 0,
                      shape: const CircleBorder(),
                      fillColor: primary.withOpacity(0.20),
                      elevation: 0,
                      padding: const EdgeInsets.all(24.0),
                    ),
                    SizedBox(height: 8),
                    Text(
                      messages[i],
                      style: GoogleFonts.oxygen(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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

    final isiPad = MediaQuery.of(context).size.shortestSide > 600;

    return Column(
      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.only(top: 24),
//          child: _ShowcaseTitle("Social"),
//        ),
//        const SizedBox(height: 8),
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
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            OutlineButton(
//              child: const Text("0% onBg"),
//              highlightedBorderColor: onBg,
//              onPressed: () {},
//            ),
//            MaterialButton(
//              elevation: 0,
//              // using color: onBg.withOpacity(0.25) gets weird on hover
//              color: compositeColors(onBg, surface, 0.25),
//              child: const Text("25% onBg"),
//              onPressed: () {},
//            ),
//            MaterialButton(
//              color: primary,
//              elevation: 0,
//              textColor: contrastingColor(primary),
//              child: const Text("100% Prim"),
//              onPressed: () {},
//            ),
//          ],
//        ),
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
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            OutlineButton(
//              child: const Text("0% Prim"),
//              textColor: primary,
//              onPressed: () {},
//            ),
//            MaterialButton(
//              color: compositeColors(primary, surface, 0.25),
//              elevation: 0,
//              child: const Text("25% Prim"),
//              textColor: primary,
//              onPressed: () {},
//            ),
//            MaterialButton(
//              elevation: 0,
//              color: primary,
//              textColor: surface,
//              child: const Text("100% Prim"),
//              onPressed: () {},
//            ),
//          ],
//        ),
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
          title: "Slavery, police, a bear and chocolate festival full of secrets - S03 E02",
          description:
              "278 years of Alcatraz's history. From Silicon Valley's luxury condominium to a prison no one can escape.",
          subdescription: "Yesterday • 34 MINS",
        ),
        SizedBox(height: 24),
        _PodcastCard(
          elevation: elevation,
          primaryColor: Theme.of(context).colorScheme.onSurface,
          textColor: primary,
          title: "Hyenas, planes, reindeers, robots and an old friend - S05 E17",
          description:
              "Things have changed. Nothing is what you expect. And nothing will ever be the same again. Be careful with the maze.",
          subdescription: "Today • 22 MINS",
        ),
        SizedBox(height: 48),
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

  final margin = 12.0;

  @override
  Widget build(BuildContext context) {
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
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
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
                    FeatherIcons.moreVertical,
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
          width: 1.0,
        ),
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

//class _WhatsNewCard extends StatelessWidget {
//  const _WhatsNewCard(this.primary, this.version, this.elevation);
//
//  final Color primary;
//  final String version;
//  final int elevation;
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//      elevation: elevation.toDouble(),
//      shape: RoundedRectangleBorder(
//        side: BorderSide(
//            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
//            width: 1.0),
//        borderRadius: BorderRadius.circular(8.0),
//      ),
//      child: Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(
//              "What's New in $version",
//              style: TextStyle(fontWeight: FontWeight.w500),
//            ),
//            Text(
//              "View",
//              style: TextStyle(fontWeight: FontWeight.w500, color: primary),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

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
        Text(
          "Transparency",
          style: GoogleFonts.heebo(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        PrevPhotosTransparency(primary: primary, surface: surface),
        const SizedBox(height: 24),
        Text(
          "Material Elevation",
          style: GoogleFonts.heebo(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 72,
          child: Center(
            child: ListView(
              key: const PageStorageKey("photosOverlay"),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
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
        ),
        SizedBox(height: 24),
        Text(
          "Icons",
          style: GoogleFonts.heebo(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        _PrevSocial(primary: primary, surface: surface),
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

class _PrevSDKMonitor extends StatelessWidget {
  const _PrevSDKMonitor({this.primary, this.elevation});

  final Color primary;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 24),
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
        SizedBox(height: 24),
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
                  onChanged: (changed) {},
                ),
              )
          ],
        ),
      ),
    );
  }
}
