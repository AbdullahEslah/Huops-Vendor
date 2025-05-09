import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/view_models/splash.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      backgroundColor: Colors.white,
      body: ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return VStack(
            [
              //
              Image.asset(AppImages.appLogo)
                  .wh(context.percentWidth * 35, context.percentWidth * 35)
                  .box
                  .clip(Clip.antiAlias)
                  .roundedSM
                  .makeCentered()
                  .py12(),
              // "Loading Please wait...".tr().text.makeCentered(),
            ],
          ).centered();
        },
      ),
    );
  }
}
