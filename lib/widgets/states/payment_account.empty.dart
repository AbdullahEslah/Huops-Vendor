import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyPaymentAccount extends StatelessWidget {
  const EmptyPaymentAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Image.asset(
          AppImages.noPaymentAccount,
          width: context.percentWidth * 45,
          height: context.percentWidth * 45,
        ).py8(),
        VStack(
          [
            "No Payment Account".tr().text.xl2.bold.white.center.make().py8(),
            ("When you add a payment account, it will appear here. You can add multiple payment accounts."
                        .tr() +
                    "\n\n" +
                    "Click the + button to add a payment account.".tr())
                .text
                .center.white
                .make().py8(),
            10.heightBox,

          ],
          // spacing: 10,
          crossAlignment: CrossAxisAlignment.center,
        ).py8(),
        15.heightBox,
      ],
      // spacing: 15,
      crossAlignment: CrossAxisAlignment.center,
    ).p20().centered();
  }
}
