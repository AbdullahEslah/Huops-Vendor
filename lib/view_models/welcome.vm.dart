import 'package:flutter/material.dart';
import 'package:huops/constants/app_routes.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';

class WelcomeViewModel extends MyBaseViewModel {
  //
  WelcomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  int selectedPage = 0;
  String pageTitle = "";

  pageSelected(int page, String title) {
    if (page == 1 && !AuthServices.authenticated()) {
      Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
    } else {
      selectedPage = page;
      pageTitle = title;
      notifyListeners();
    }
  }
}
