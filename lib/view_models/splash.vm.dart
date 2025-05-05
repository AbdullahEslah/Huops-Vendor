import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/constants/app_theme.dart';
import 'package:huops/requests/settings.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/firebase.service.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/cards/language_selector.view.dart';
import 'base.view_model.dart';

class SplashViewModel extends MyBaseViewModel {
  SplashViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  SettingsRequest settingsRequest = SettingsRequest();

  //
  initialise() async {
    super.initialise();
    await loadAppSettings();
  }

  //

  //
  loadAppSettings() async {
    setBusy(true);
    try {
      final appSettingsObject = await settingsRequest.appSettings();
      //app settings
      await updateAppVariables(appSettingsObject.body["strings"]);
      //colors
      await updateAppTheme(appSettingsObject.body["colors"]);
      loadNextPage();
    } catch (error) {
      setError(error);
      print("Error loading app settings ==> $error");
    }
    setBusy(false);
  }

  //
  Future<void> updateAppVariables(dynamic json) async {
    //
    await AppStrings.saveAppSettingsToLocalStorage(jsonEncode(json));
  }

  //theme change
  updateAppTheme(dynamic colorJson) async {
    //
    await AppColor.saveColorsToLocalStorage(jsonEncode(colorJson));
    //change theme
    // await AdaptiveTheme.of(viewContext).reset();
    AdaptiveTheme.of(viewContext).setTheme(
      light: AppTheme().lightTheme(),
      // dark: AppTheme().darkTheme(),
      notify: true,
    );
    await AdaptiveTheme.of(viewContext).persist();
  }

  //
  loadNextPage() async {
    //
    await Utils.setJiffyLocale();
    //
    if (AuthServices.firstTimeOnApp()) {
      //choose language
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: viewContext,
        isScrollControlled: true,
        builder: (context) {
          return AppLanguageSelector();
        },
      );
    }

    //
    if (AuthServices.firstTimeOnApp()) {
      Navigator.of(viewContext).pushNamedAndRemoveUntil(
        AppRoutes.welcomeRoute,
        (route) => false,
      );
    } else if (!AuthServices.authenticated()) {
      Navigator.of(viewContext).pushNamedAndRemoveUntil(
        AppRoutes.loginRoute,
        (route) => false,
      );
    } else {
      await AuthServices.getCurrentUser(force: true);
      Navigator.of(viewContext).pushNamedAndRemoveUntil(
        AppRoutes.homeRoute,
        (route) => false,
      );
    }

    //
    RemoteMessage? initialMessage =
        await FirebaseService().firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      //
      FirebaseService().saveNewNotification(initialMessage);
      FirebaseService().selectNotification('');
    }
  }
}
