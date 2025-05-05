import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_dropdown_alert/alert_controller.dart';
// import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/delivery_address.dart';
import 'package:huops/services/toast.service.dart';
import 'package:huops/services/update.service.dart';
import 'package:huops/views/pages/shared/custom_webview.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBaseViewModel extends BaseViewModel with UpdateService {
  //
  late BuildContext viewContext;
  final formKey = GlobalKey<FormState>();
  final formBuilderKey = GlobalKey<FormBuilderState>();
  final currencySymbol = AppStrings.currencySymbol;
  GlobalKey pageKey = GlobalKey<FormState>();
  DeliveryAddress? deliveryaddress;
  String? firebaseVerificationId;

  void initialise() {
    //FirestoreRepository();
  }

  newPageKey() {
    pageKey = GlobalKey<FormState>();
    notifyListeners();
  }

  //show toast
  toastSuccessful(String msg, {String? title}) async {
    // AlertController.show(
    //   title ?? "Successful".tr(),
    //   msg,
    //   TypeAlert.success,
    // );
    await FlutterPlatformAlert.showAlert(
      windowTitle: title ?? "Successful".tr(),
      text: msg,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.information,
    );
  }

  toastError(String msg, {String? title}) async {
    // AlertController.show(
    //   title ?? "Error".tr(),
    //   msg,
    //   TypeAlert.error,
    // );

    await FlutterPlatformAlert.playAlertSound();

    await FlutterPlatformAlert.showAlert(
      windowTitle: title ?? "Error".tr(),
      text: msg,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.error,
    );
  }

  openWebpageLink(String url, {bool external = false}) async {
    if (Platform.isIOS || external) {
      await launchUrlString(url);
      return;
    }
    await viewContext.push(
      (context) => CustomWebviewPage(
        selectedUrl: url,
        pageTitle: "Privacy Policy".tr(),
      ),
    );
  }

  Future<dynamic> openExternalWebpageLink(String url) async {
    try {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      return;
    } catch (error) {
      ToastService.toastError("$error");
    }
  }
}
