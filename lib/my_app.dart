import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'package:huops/services/app.service.dart';
import 'package:huops/views/pages/splash.page.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'constants/app_strings.dart';
import 'package:huops/services/router.service.dart' as router;

import 'constants/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return AdaptiveTheme(
      light: AppTheme().lightTheme(),
      dark: AppTheme().lightTheme(),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) {
        return MaterialApp(
          navigatorKey: AppService().navigatorKey,
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          onGenerateRoute: router.generateRoute,
          // initialRoute: _startRoute,
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          home: SplashPage(),
          builder: (context, child) => child!,
          // Stack(
          // ,
          // children: [
          //   child!,
          //   // DropdownAlert()
          //   // ,
          // ],
          // ),
          theme: theme,
        );
      },
    );
  }
}
