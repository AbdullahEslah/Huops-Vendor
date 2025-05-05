import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class BackgroundPermissionBottomSheet extends StatelessWidget {
  const BackgroundPermissionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Image.asset(
          AppImages.overflowPermission,
          width: context.percentWidth * 50,
          // height: context.percentWidth * 50,
        ).centered().py4(),
        //description
        "Keep app running in background".tr().text.xl2.semiBold.make().py4(),
        "Please allow the app to run in background to enable the app to listen for new order when the app is in background."
            .tr()
            .text
            .make().py4(),
        20.heightBox,
        //button
        CustomButton(
          title: "Allow".tr(),
          onPressed: () => Navigator.pop(context, true),
        ).wFull(context).py4(),
        CustomTextButton(
          title: "Cancel".tr(),
          onPressed: () => Navigator.pop(context),
        ).wFull(context).py4(),

        20.heightBox,
      ],
      // spacing: 10,
    ).p20().py12().box.white.topRounded().make();
  }
}
