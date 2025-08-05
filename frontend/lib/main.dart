import 'package:flutter/material.dart';

import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/router.dart';

import 'package:frontend/utils/providers/auth_provider.dart';
// auto-generated
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ka');
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      child: MaterialApp.router(
        locale: _locale,
        debugShowCheckedModeBanner: false,
        title: 'TEREFONI',
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],

        supportedLocales: const [Locale('en'), Locale('ka')],
        theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Inter'),
      ),
    );
  }
}
