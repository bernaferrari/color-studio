import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsluv/hsluvcolor.dart';

import '../blocs/blocs.dart';
import '../example/mdc/components.dart';
import '../example/screens/color_library.dart';
import '../example/widgets/loading_indicator.dart';
import '../example/widgets/update_color_dialog.dart';
import '../screen_home/contrast_ratio/contrast_circle_group.dart';
import '../screen_home/scheme/widgets/expanded_section.dart';
import '../util/constants.dart';
import 'templates/templates_screen.dart';
import 'vertical_picker/vertical_picker_main.dart';

class ScreenSingle extends StatelessWidget {
  const ScreenSingle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorsCubit, ColorsState>(builder: (_, state) {
      final Color selectedRgbColor = state.rgbColors[state.selected]!;
      final HSLuvColor selectedHsluvColor = state.hsluvColors[state.selected]!;

      final colorScheme = (selectedHsluvColor.lightness > kLightnessThreshold)
          ? ColorScheme.light(
              primary: selectedRgbColor,
              secondary: selectedRgbColor,
              surface: selectedRgbColor,
            )
          : ColorScheme.dark(
              primary: selectedRgbColor,
              secondary: selectedRgbColor,
              surface: selectedRgbColor,
            );

      return Theme(
        data: ThemeData.from(
          colorScheme: colorScheme,
          textTheme: TextTheme(labelLarge: GoogleFonts.b612Mono()),
        ).copyWith(
          cardTheme: Theme.of(context).cardTheme,
          buttonTheme: Theme.of(context).buttonTheme.copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
        ),
        child: Scaffold(
          backgroundColor: selectedRgbColor,
          body: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    children: [
                      // DynamicTemplatesScreen(
                      //   backgroundColor: selectedRgbColor,
                      //   state: state,
                      // ),
                      HSVerticalPicker(
                        color: selectedRgbColor,
                        hsLuvColor: selectedHsluvColor,
                      ),
                      // SingleColorBlindness(
                      //   color: selectedRgbColor,
                      //   isSplitView: isSplitView,
                      // ),
                      // AboutScreen(isSplitView: isSplitView),
                      TemplatesScreen(backgroundColor: selectedRgbColor),
                      ColorLibrary(backgroundColor: selectedRgbColor),
                    ],
                  ),
                ),
                _BottomHome(
                  selected: state.selected,
                  selectedColor: selectedRgbColor,
                  locked: state.locked,
                  rgbColors: state.rgbColors,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget cardPicker(String title, Widget picker) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: picker,
          ),
        ],
      ),
    );
  }
}

class _BottomHome extends StatefulWidget {
  const _BottomHome({
    required this.selected,
    required this.selectedColor,
    required this.rgbColors,
    required this.locked,
  });

  final ColorType selected;
  final Color selectedColor;
  final Map<ColorType, Color> rgbColors;
  final Map<ColorType, bool> locked;

  @override
  __BottomHomeState createState() => __BottomHomeState();
}

class __BottomHomeState extends State<_BottomHome> {
  bool isContrastExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contrastedColor =
        (widget.selectedColor.computeLuminance() > kLumContrast)
            ? Colors.black
            : Colors.white;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.background.withOpacity(kVeryTransparent),
        border: Border(
          top: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.40),
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        left: false,
        right: false,
        child: Column(
          children: <Widget>[
            ExpandedSection(
              expand: isContrastExpanded,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _ColorContrastRow(
                  areValuesLocked: false,
                  rgbColors: widget.rgbColors,
                ),
              ),
            ),
            ThemeBar(
              selected: widget.selected,
              rgbColors: widget.rgbColors,
              locked: widget.locked,
              isExpanded: isContrastExpanded,
              onExpanded: () {
                setState(() {
                  isContrastExpanded = !isContrastExpanded;
                });
              },
            ),
            TabBar(
              labelColor: contrastedColor,
              indicatorColor: contrastedColor,
              isScrollable: true,
              indicator: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.10),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.onSurface,
                    width: 2.0,
                  ),
                ),
              ),
              tabs: const [
//                            Tab(
//                              icon: Transform.rotate(
//                                angle: 0.5 * math.pi,
//                                child: const Icon(FeatherIcons.sliders),
//                              ),
//                            ),
//                 Tab(icon: Icon(FeatherIcons.map)),
                Tab(icon: Icon(FeatherIcons.barChart2)),
                // Tab(icon: Icon(Icons.invert_colors)),
                // Tab(icon: Icon(FeatherIcons.info)),
                Tab(icon: Icon(FeatherIcons.briefcase)),
                Tab(icon: Icon(FeatherIcons.bookOpen)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorContrastRow extends StatelessWidget {
  const _ColorContrastRow({
    this.areValuesLocked,
    this.rgbColors,
  });

  final bool? areValuesLocked;
  final Map<ColorType, Color>? rgbColors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContrastRatioCubit, ContrastRatioState>(
        builder: (context, state) {
      if (state.contrastValues.isEmpty) {
        return const LoadingIndicator();
      }

      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ContrastCircleGroup(
            state: state,
            rgbColorsWithBlindness: rgbColors,
            isInCard: false,
          ),
        ),
      );
    });
  }
}

class ThemeBar extends StatelessWidget {
  const ThemeBar({
    super.key,
    this.selected,
    this.rgbColors,
    this.locked,
    this.isExpanded,
    this.onExpanded,
    this.leading,
  });

  final ColorType? selected;
  final Map<ColorType, Color>? rgbColors;
  final Map<ColorType, bool>? locked;
  final bool? isExpanded;
  final Function? onExpanded;
  final Widget? leading;

  void colorSelected(
    BuildContext context,
    ColorType selected,
    Color color,
  ) {
    context
        .read<ColorsCubit>()
        .updateRgbColor(rgbColor: color, selected: selected);
  }

  @override
  Widget build(BuildContext context) {
    final Map<ColorType, Color> colorsList = Map.from(rgbColors!);

    // remove from the bar items that were locked in the previous screen.
    colorsList.removeWhere((var a, var b) => locked![a] == true);

    final mappedList = colorsList.values.toList();
    final keysList = colorsList.keys.toList();

    final contrastedColors = [
      for (int i = 0; i < mappedList.length; i++)
        contrastingRGBColor(mappedList[i])
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: LayoutBuilder(builder: (context, builder) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // this is necessary to counter-balance the chevronUp icon at the other side.
              if (isExpanded != null)
                IconButton(
                  tooltip: "undo",
                  icon: const Icon(Icons.undo_rounded),
                  onPressed: () => context.read<ColorsCubit>().undo(),
                ),
              if (leading != null) leading!,
              Flexible(
                child: SizedBox(
                  height: 36,
                  child: ListView(
                    shrinkWrap: true,
                    // in a previous iteration, shrinkWrap
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      const SizedBox(width: 16),
                      for (int i = 0; i < mappedList.length; i++) ...[
                        SizedBox(
                          height: 32,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              elevation: 0.0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: mappedList[i],
                              side: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                            onPressed: () {
                              colorSelected(
                                context,
                                keysList[i],
                                mappedList[i],
                              );
                            },
                            onLongPress: () {
                              showSlidersDialog(context, mappedList[i]);
                            },
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 8),
                                if (selected == keysList[i])
                                  Icon(
                                    FeatherIcons.checkCircle,
                                    size: 16,
                                    color: contrastedColors[i],
                                  )
                                else
                                  Icon(
                                    FeatherIcons.circle,
                                    size: 16,
                                    color: contrastedColors[i],
                                  ),
                                const SizedBox(width: 4),
                                Text(
                                  describeEnum(keysList[i]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: contrastedColors[i],
                                        fontWeight: (selected == keysList[i])
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                      ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              if (isExpanded != null)
                IconButton(
                  tooltip: isExpanded! ? "hide contrast" : "show contrast",
                  icon: Icon(
                    isExpanded!
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                  ),
                  onPressed: onExpanded as void Function()?,
                ),
            ]);
      }),
    );
  }
}
