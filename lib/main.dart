import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xml_merger/providers/xml_provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

import 'screens/home_screen.dart';

import 'dart:async';

class WindowObserver extends WindowListener {
  Timer? _debounce;

  void _saveSettings() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      final prefs = await SharedPreferences.getInstance();

      final size = await windowManager.getSize();
      final pos = await windowManager.getPosition();

      await prefs.setDouble('window_width', size.width);
      await prefs.setDouble('window_height', size.height);
      await prefs.setDouble('window_x', pos.dx);
      await prefs.setDouble('window_y', pos.dy);
    });
  }

  @override
  void onWindowResized() => _saveSettings();

  @override
  void onWindowMoved() => _saveSettings();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  double width = prefs.getDouble('window_width') ?? 1000;
  double height = prefs.getDouble('window_height') ?? 600;
  double? posX = prefs.getDouble('window_x');
  double? posY = prefs.getDouble('window_y');

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions = WindowOptions(
      size: Size(width, height),
      minimumSize: Size(1000, 600),
      center: posX == null,
      title: "XML Merger",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (posX != null && posY != null) {
        await windowManager.setPosition(Offset(posX, posY));
      }
      await windowManager.show();
      await windowManager.focus();
    });

    windowManager.addListener(WindowObserver());
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(create: (_) => XmlProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      onGenerateTitle: (context) {
        final title = AppLocalizations.of(context)!.appTitle;
        windowManager.setTitle(title);
        return title;
      },
      debugShowCheckedModeBanner: false,

      locale: localeProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      themeMode: themeProvider.themeMode,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,

      home: const HomeScreen(),
    );
  }
}
