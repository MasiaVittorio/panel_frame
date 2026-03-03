import 'package:example/body.dart';
import 'package:example/bottom_bar.dart';
import 'package:example/collapsed_panel.dart';
import 'package:example/components/app_bar_title.dart';
import 'package:example/expanded_panel.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeLogicProvider(
      createThemeLogic: () => ThemeLogic(),
      builder: (context, lightTheme, darkTheme, themeMode, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

extension OnStyleChanged on BuildContext {
  void changePanelStyle(PanelFrameStyle value) =>
      provide<ValueChanged<PanelFrameStyle>>()(value);

  void changeBodyPage(BodyPage value) =>
      provide<ValueChanged<BodyPage>>()(value);
}

enum BodyPage {
  alerts,
  snackbars,
  theme,
  settings;

  IconData get icon => switch (this) {
    BodyPage.alerts => Icons.warning_outlined,
    BodyPage.snackbars => Icons.notifications_outlined,
    BodyPage.theme => Icons.palette_outlined,
    BodyPage.settings => Icons.settings_outlined,
  };
}

class _MyHomePageState extends State<MyHomePage> {
  PanelFrameStyle style = PanelFrameStyle(
    collapsedPanelHeight: 56,
    fullScreenExpandedPanel: true,
    expandedPanelMargin: (_) => EdgeInsets.zero,
    expandedPanelBorderRadius: (_) => 0,
    computeOpenPanelTopBarOverlap: (_) => 0,
    collapsedPanelBorderRadius: (_) => 28,
    collapsedPanelBorderSide: (context) =>
        BorderSide(color: context.theme.colorScheme.outlineVariant, width: 1),
    collapsedPanelBackgroundColor: (context) =>
        context.theme.colorScheme.surface,
  );

  void onStyleChanged(PanelFrameStyle value) {
    setState(() {
      style = value;
    });
  }

  BodyPage page = BodyPage.alerts;

  void onPageChanged(BodyPage value) {
    setState(() {
      page = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CleanProvider(
      data: onPageChanged,
      child: CleanProvider(
        data: onStyleChanged,
        child: PanelFrame(
          style: style,
          collapsedPanel: const CollapsedPanel(),
          expandedPanel: const ExpandedPanel(),
          body: MyBody(page: page),
          topBarChild: const AppBarTitle(),
          topBarBuilder: (_, child, openValue) {
            return FrameAppBar(
              title: child!,
              openValue: openValue,
              panelSubtitle: Text("Panel subtitle"),
            );
          },
          bottomBar: MyBottomBar(page: page, onPageChanged: onPageChanged),
        ),
      ),
    );
  }
}
