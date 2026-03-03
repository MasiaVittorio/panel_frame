import 'package:example/components/color_picker_tile.dart';
import 'package:example/components/color_source_slider.dart';
import 'package:example/components/contrast_slider.dart';
import 'package:example/components/theme_mode_switch.dart';
import 'package:example/components/variant_tile.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionTitle(
          title: Text('Brightness'),
          leading: Icon(Icons.brightness_4_outlined),
        ),
        ThemeModeSwitch(),
        SectionTitle(
          title: Text('Color source'),
          leading: Icon(Icons.palette_outlined),
        ),
        ColorSourceSlider(),
        SectionTitle(title: Text('Style'), leading: Icon(Icons.style_outlined)),
        context.themeLogic.useDynamic.build((context, useDynamic) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedListed(
                listed: !useDynamic,
                child: GroupedCard(
                  isLast: false,
                  isFirst: true,
                  child: ColorPickerTile(),
                ),
              ),
              GroupedCard(
                isLast: false,
                isFirst: useDynamic,
                child: VariantTile(),
              ),
              GroupedCard(
                isLast: true,
                isFirst: false,
                child: ContrastSlider(),
              ),
            ],
          );
        }),
      ],
    );
  }
}
