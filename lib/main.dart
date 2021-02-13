import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart';

import 'blocs/blocs.dart';
import 'navigator.dart';
import 'util/constants.dart';
import 'util/shuffle_color.dart';

Future<void> main() async {
  // this is needed so Hive can be initialised synchronously.
  // when the app runs, Hive should have a value already.
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle("Color Studio");
      setWindowMinSize(Size(300, 600));
    }
  }
  await openBox();
  Bloc.observer = SimpleBlocObserver();
  runApp(BoxedApp());
}

Future openBox() async {
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  return await Hive.openBox<dynamic>("settings");
}

class BoxedApp extends StatefulWidget {
  @override
  _BoxedAppState createState() => _BoxedAppState();
}

class _BoxedAppState extends State<BoxedApp> {
  ColorBlindnessCubit _colorBlindnessCubit;
  ContrastRatioCubit _contrastRatioCubit;
  ColorsCubit _colorsCubit;

  @override
  void initState() {
    super.initState();
    _colorBlindnessCubit = ColorBlindnessCubit();
    _colorsCubit = ColorsCubit(
      _colorBlindnessCubit,
      ColorsCubit.initialState(getRandomMaterialDark()),
    );
    _contrastRatioCubit = ContrastRatioCubit(_colorsCubit);
  }

  @override
  void dispose() {
    super.dispose();
    _colorBlindnessCubit.close();
    _colorsCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ColorsCubit>(
          create: (context) => _colorsCubit,
        ),
        BlocProvider<ContrastRatioCubit>(
          create: (context) => _contrastRatioCubit,
        ),
        BlocProvider<ColorBlindnessCubit>(
          create: (context) => _colorBlindnessCubit,
        )
      ],
      child: BlocBuilder<ColorsCubit, ColorsState>(builder: (_, state) {
        if (state.rgbColors.isEmpty) {
          return SizedBox.shrink();
        }

        final primary = state.rgbColorsWithBlindness[ColorType.Primary];
        final secondary = state.rgbColorsWithBlindness[ColorType.Secondary];
        final background = state.rgbColorsWithBlindness[ColorType.Background];
        final surface = state.rgbColorsWithBlindness[ColorType.Surface];

        final isLightSurface = state.hsluvColors[ColorType.Surface].lightness >=
            kLightnessThreshold;

        final onSurface = isLightSurface ? Colors.black : Colors.white;

        final onBackground =
            state.hsluvColors[ColorType.Background].lightness >=
                    kLightnessThreshold
                ? Colors.black
                : Colors.white;

        final onPrimary = state.hsluvColors[ColorType.Primary].lightness >=
                kLightnessThreshold
            ? Colors.black
            : Colors.white;

        final colorScheme = isLightSurface
            ? ColorScheme.light(
                primary: primary,
                onPrimary: onPrimary,
                secondary: secondary,
                background: background,
                onBackground: onBackground,
                surface: surface,
                onSurface: onSurface,
              )
            : ColorScheme.dark(
                primary: primary,
                onPrimary: onPrimary,
                secondary: secondary,
                background: background,
                onBackground: onBackground,
                surface: surface,
                onSurface: onSurface,
              );

        return Theme(
          data: ThemeData.from(
            colorScheme: colorScheme,
            textTheme: TextTheme(
              headline6: GoogleFonts.openSans(fontWeight: FontWeight.w700),
              subtitle1: GoogleFonts.openSans(fontWeight: FontWeight.w700),
              subtitle2: GoogleFonts.openSans(fontWeight: FontWeight.w400),
              bodyText2: GoogleFonts.lato(),
              caption: GoogleFonts.openSans(),
            ),
          ).copyWith(
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.30),
                  width: 1,
                ),
              ),
              elevation: 0,
              margin: EdgeInsets.zero,
            ),
          ),
          child: ColorStudioApp(),
        );
      }),
    );
  }
}
