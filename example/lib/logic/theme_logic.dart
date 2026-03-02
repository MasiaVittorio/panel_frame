import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

extension ThemeLogicFromContext on BuildContext {
  ThemeLogic get themeLogic => ThemeLogic.of(this);
}

extension ThemeModeIcons on ThemeMode {
  IconData get icon => switch (this) {
    ThemeMode.system => MdiIcons.android,
    ThemeMode.light => MdiIcons.weatherSunny,
    ThemeMode.dark => MdiIcons.weatherNight,
  };
}

class ThemeLogic extends ThemeLogicBase {
  static ThemeLogic of(BuildContext context) => context.provide<ThemeLogic>();

  @override
  CustomScheme get defaultCustomScheme => CustomScheme(
    dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
    contrastLevel: 0,
    seedColor: Colors.grey,
  );

  ThemeLogic({
    super.initialThemeMode = ThemeMode.dark,
    super.initialUseDynamic = true,
    super.initialCustomScheme,
  });

  @override
  ThemeData applyAppCustomizations(ThemeData theme) {
    final scaffoldBackgroundColor = theme.brightness.isLight
        ? Color(0xfff8f8f8)
        : theme.scaffoldBackgroundColor;
    final layout = Layout.defaultLayout;

    return theme.copyWith(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        border: const OutlineInputBorder(),
      ),
      sliderTheme: theme.sliderTheme.copyWith(year2023: false),
      appBarTheme: theme.appBarTheme.copyWith(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
      ),
      snackBarTheme: theme.snackBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surfaceContainerHigh,
        contentTextStyle:
            theme.snackBarTheme.contentTextStyle?.copyWith(
              color: theme.colorScheme.onSurface,
            ) ??
            TextStyle(color: theme.colorScheme.onSurface),
        closeIconColor: theme.colorScheme.onSurface,
        actionBackgroundColor: theme.colorScheme.primary,
        actionTextColor: theme.colorScheme.onPrimary,
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        titleTextStyle: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        subtitleTextStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
        ),
        minVerticalPadding: layout.margin.medium,
      ),
      extensions: [layout],
    );
  }
}

extension TextThemeFamilyChanger on TextTheme {
  TextTheme withFamiliesGoogle({
    TextStyle Function(TextStyle? textStyle)? display,
    TextStyle Function(TextStyle? textStyle)? headline,
    TextStyle Function(TextStyle? textStyle)? title,
    TextStyle Function(TextStyle? textStyle)? body,
    TextStyle Function(TextStyle? textStyle)? label,
  }) => copyWith(
    displayLarge: display?.call(displayLarge) ?? displayLarge,
    displayMedium: display?.call(displayMedium) ?? displayMedium,
    displaySmall: display?.call(displaySmall) ?? displaySmall,
    headlineLarge: headline?.call(headlineLarge) ?? headlineLarge,
    headlineMedium: headline?.call(headlineMedium) ?? headlineMedium,
    headlineSmall: headline?.call(headlineSmall) ?? headlineSmall,
    titleLarge: title?.call(titleLarge) ?? titleLarge,
    titleMedium: title?.call(titleMedium) ?? titleMedium,
    titleSmall: title?.call(titleSmall) ?? titleSmall,
    bodyLarge: body?.call(bodyLarge) ?? bodyLarge,
    bodyMedium: body?.call(bodyMedium) ?? bodyMedium,
    bodySmall: body?.call(bodySmall) ?? bodySmall,
    labelLarge: label?.call(labelLarge) ?? labelLarge,
    labelMedium: label?.call(labelMedium) ?? labelMedium,
    labelSmall: label?.call(labelSmall) ?? labelSmall,
  );
}
