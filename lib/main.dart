import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xml_merger/providers/xml_provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 600),
      minimumSize: Size(1000, 600),
      center: true,
      title: "XML Merger",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
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

