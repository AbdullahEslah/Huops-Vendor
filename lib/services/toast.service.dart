// import 'package:flutter_dropdown_alert/alert_controller.dart';
// import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ToastService {
  //
  //show toast
  static toastSuccessful(String msg, {String? title}) async {
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

  static toastError(String msg, {String? title}) async {
    // AlertController.show(
    //   title ?? "Error".tr(),
    //   msg,
    //   TypeAlert.error,
    // );
    await FlutterPlatformAlert.showAlert(
      windowTitle: title ?? "Error".tr(),
      text: msg,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.error,
    );
  }
}
