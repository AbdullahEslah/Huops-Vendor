import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/login.view_model.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ScanLoginView extends StatelessWidget {
  const ScanLoginView(
    this.model, {
    this.bottomPadding = Vx.dp48,
    Key? key,
  }) : super(key: key);

  final LoginViewModel model;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: AppStrings.qrcodeLogin,
      child: CustomButton(
        shapeRadius: 12,
        onPressed: model.initateQrcodeLogin,
        child: HStack(
          [
            "Scan to login".tr().text.lg.bold.make(),
            UiSpacer.horizontalSpace(space: 10),
            Icon(
              FlutterIcons.qrcode_ant,
            ),
          ],
        )
      ).pOnly(bottom: bottomPadding).wFull(context).centered()
    );
  }
}
