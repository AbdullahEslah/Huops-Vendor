import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({Key? key}) : super(key: key);

  //
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          //title
          "Camera Permission Request".tr().text.semiBold.xl.make().py12(),
          ("${AppStrings.appName} " +
                  "needs your permission to access your camera to take a photo for your profile picture, or take order picture has proof of delivery."
                      .tr() +
                  "\n" +
                  "You can change this permission in your device settings."
                      .tr())
              .text
              .make(),
          UiSpacer.verticalSpace(),
          CustomButton(
            title: "Request Permission".tr(),
            onPressed: () {
              AppService().navigatorKey.currentContext?.pop(true);
            },
          ).py12(),
          CustomButton(
            title: "Cancel".tr(),
            color: Colors.grey[400],
            onPressed: () {
              AppService().navigatorKey.currentContext?.pop(false);
            },
          ),
        ],
      ).p20().wFull(context).scrollVertical(), //.hTwoThird(context),
    );
  }
}
