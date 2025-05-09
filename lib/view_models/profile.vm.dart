import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:custom_faqs/custom_faqs.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/views/pages/profile/account_delete.page.dart';
import 'package:huops/views/pages/profile/contact_us.page.dart';
import 'package:huops/views/pages/splash.page.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/user.dart';
import 'package:huops/requests/auth.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/widgets/cards/language_selector.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';

import '../views/pages/profile/images/faqs_page.dart';

class ProfileViewModel extends MyBaseViewModel {
  //
  String appVersionInfo = "";
  User? currentUser;

  //
  AuthRequest _authRequest = AuthRequest();

  ProfileViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    setBusy(true);
    currentUser = await AuthServices.getCurrentUser(force: true);
    setBusy(false);
  }

  /**
   * Edit Profile
   */

  openEditProfile() async {
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.editProfileRoute,
    );

    if (result != null && result is bool && result) {
      initialise();
    }
  }

  /**
   * Change Password
   */

  openChangePassword() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.changePasswordRoute,
    );
  }

  /**
   * Logout
   */
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      confirmBtnTextStyle: TextStyle(color: Colors.black),
      onConfirmBtnTap: () {
        //  error came here
        //viewContext.pop();
        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    // CoolAlert.show(
    //   context: viewContext,
    //   type: CoolAlertType.loading,
    //   title: "Logout".tr(),
    //   text: "Logging out Please wait...".tr(),
    //   barrierDismissible: false,
    // );
    //Toast.show("Logging out please wait...", viewContext);

    //
    final apiResponse = await _authRequest.logoutRequest();

    //
    //viewContext.pop();

    if (!apiResponse.allGood) {
      //
      // CoolAlert.show(
      //   context: viewContext,
      //   type: CoolAlertType.error,
      //   title: "Logout",
      //   text: apiResponse.message,
      // );
      Toast.show(apiResponse.message, viewContext);
    } else {
      //
      await AuthServices.logout();
      Navigator.of(viewContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openNotification() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.notificationsRoute,
    );
  }

  /**
   * App Rating & Review
   */
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (Platform.isAndroid) {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    } else if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  openFaqs() {
    viewContext.nextPage(
      FaqPage(
        title: 'Faqs'.tr(),
        link: Api.baseUrl + Api.faqs,
      ),
    );
  }

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    openWebpageLink(url);
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  //
  openContactUs() async {
    final url = Api.contactUs;
    // openWebpageLink(url);
    Navigator.of(viewContext).push(
      MaterialPageRoute(
        builder: (context) => ContactUs(),
      ),
    );
  }

  openLivesupport() async {
    final url = Api.inappSupport;
    openWebpageLink(url);
  }

  //
  changeLanguage() async {
    showModalBottomSheet(
      context: viewContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return AppLanguageSelector();
      },
    );
  }

  deleteAccount() {
    viewContext.nextPage(AccountDeletePage());
  }
}
