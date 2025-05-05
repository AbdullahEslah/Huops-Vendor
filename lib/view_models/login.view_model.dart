import 'package:cool_alert/cool_alert.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/requests/auth.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/traits/qrcode_scanner.trait.dart';
import 'package:huops/views/pages/auth/register.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginViewModel extends MyBaseViewModel with QrcodeScannerTrait {
  //the textediting controllers
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  //
  AuthRequest _authRequest = AuthRequest();

  LoginViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() {
    //
    emailTEC.text = kReleaseMode ? "" : "manager@demo.com";
    passwordTEC.text = kReleaseMode ? "" : "password";
  }

  void processLogin(
      //   {
      // required Function(bool success) onSuccess}
      ) async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      //

      setBusy(true);

      final apiResponse = await _authRequest.loginRequest(
        email: emailTEC.text,
        password: passwordTEC.text,
      );
      await handleDeviceLogin(apiResponse);
      //onSuccess(true);
      setBusy(false);
    }
  }

  //QRCode login
  void initateQrcodeLogin() async {
    //
    final loginCode = await openScanner(viewContext);
    if (loginCode == null) {
      toastError("Operation failed/cancelled".tr());
    } else {
      setBusy(true);

      try {
        final apiResponse = await _authRequest.qrLoginRequest(
          code: loginCode,
        );
        //
        handleDeviceLogin(apiResponse);
      } catch (error) {
        print("QR Code login error ==> $error");
      }

      setBusy(false);
    }
  }

  ///
  ///
  ///
  handleDeviceLogin(ApiResponse apiResponse
      // ,
      // Function(bool success) onSuccess
      ) async {
    try {
      if (apiResponse.hasError()) {
        //there was an error

        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Login Failed".tr(),
          text: apiResponse.message,
        );
        print(apiResponse.message);
        // onSuccess(false);
        // Toast.show(apiResponse.message, viewContext);
      } else {
        //everything works well
        //firebase auth
        print("###########${apiResponse.body['vendor']['vendor_type_id']}");
        print("###########${apiResponse.data}");
        final fbToken = apiResponse.body["fb_token"];
        await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.saveVendor(apiResponse.body["vendor"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        // onSuccess(true);
        Navigator.of(viewContext).pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      // CoolAlert.show(
      //   context: viewContext,
      //   type: CoolAlertType.error,
      //   title: "Login Failed".tr(),
      //   text: "${error.message}",
      // );

      Toast.show(error.message ?? "", viewContext);
      // onSuccess(false);
    } catch (error) {
      // CoolAlert.show(
      //   context: viewContext,
      //   type: CoolAlertType.error,
      //   title: "Login Failed".tr(),
      //   text: "$error",
      // );
      Toast.show("${error.toString()}", viewContext);
      // onSuccess(false);
    }
  }

  void openForgotPassword() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.forgotPasswordRoute,
    );
  }

  void openRegistrationlink() async {
    viewContext.nextPage(RegisterPage());
    /*
    final url = Api.register;
    openExternalWebpageLink(url);
    */
  }
}
