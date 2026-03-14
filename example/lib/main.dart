import 'package:example/body.dart';
import 'package:example/bottom_bar.dart';
import 'package:example/collapsed_panel.dart';
import 'package:example/components/app_bar_panel_subtitle.dart';
import 'package:example/components/app_bar_title.dart';
import 'package:example/expanded_panel.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:panel_frame/panel_frame.dart';
import 'package:sid_base/sid_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static PanelFrameStyleCustomizations get defaultStyle =>
      const PanelFrameStyleCustomizations(
        collapsedPanelHeight: 64,
        expandedPanelMargin: EdgeInsets.zero,
        expandedPanelBorderRadius: 0,
        openPanelTopBarOverlap: 0,
        collapsedPanelBorderRadius: 32,
        alertsMargin: EdgeInsets.zero,
      );

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

extension OnStyleChanged on BuildContext {
  void changePanelStyle(PanelFrameStyleCustomizations value) =>
      provide<ValueChanged<PanelFrameStyleCustomizations>>()(value);
}

enum BodyPage { alerts, snackbars, theme, notes, settings }

enum PanelPage { theme, alerts, settings }

class _MyHomePageState extends State<MyHomePage> {
  PanelFrameStyleCustomizations customizations = MyHomePage.defaultStyle;

  void onStyleChanged(PanelFrameStyleCustomizations value) =>
      setState(() => customizations = value);

  Reactive<BodyPage> page = Reactive(BodyPage.alerts);
  Reactive<PanelPage> panelPage = Reactive(PanelPage.alerts);

  @override
  void dispose() {
    page.dispose();
    panelPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CleanProvider(
      data: onStyleChanged,
      child: CleanProvider(
        data: customizations,
        child: CleanProvider(
          data: panelPage,
          child: CleanProvider(
            data: page,
            child: PanelFrame(
              style: customizations,
              collapsedPanel: const CollapsedPanel(),
              expandedPanel: const ExpandedPanel(),
              body: const MyBody(),
              topBarChild: const AppBarTitle(),
              topBarBuilder: (context, child, openValue) => FrameAppBar(
                title: child!,
                openValue: openValue,
                panelSubtitle: const AppBarPanelSubtitle(),
              ),
              bottomBar: const MyBottomBar(),
            ),
          ),
        ),
      ),
    );
  }
}
