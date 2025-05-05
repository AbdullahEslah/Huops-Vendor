import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DocumentPermissionDialog extends StatelessWidget {
  const DocumentPermissionDialog({Key? key}) : super(key: key);

  //
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: VStack(
        [
          //title
          "Storage Permission Request".tr().text.semiBold.xl.make().py12(),
          ("${AppStrings.appName} " +
                  "needs your permission to access your storage to select a document. We understand that your privacy is important, and we will not use your documents for any other purpose."
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
