import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

class VariantTile extends StatelessWidget {
  const VariantTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.provide<ThemeLogic>();

    return themeLogic.customScheme.build((context, customScheme) {
      final value = customScheme.dynamicSchemeVariant;
      void onChanged(DynamicSchemeVariant v) {
        themeLogic.customScheme.update(
          customScheme.copyWith(dynamicSchemeVariant: v),
        );
      }

      return ListTile(
        trailing: IconButton(
          onPressed: () => onChanged(DynamicSchemeVariant.tonalSpot),
          icon: const Icon(Icons.restart_alt),
        ),
        title: Text('Dynamic scheme variant'.todo),
        subtitle: Text(value.name.capitalizeFirst),
        onTap: () => context.panelFrame.showAlert(
          ThemeVariantPanelPicker(
            initialVariant: value,
            onPicked: onChanged,
            height: 500,
          ),
        ),
      );
    });
  }
}
