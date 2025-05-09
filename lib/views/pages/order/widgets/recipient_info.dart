import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/models/order.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

class RecipientInfo extends StatelessWidget {
  const RecipientInfo({
    required this.callRecipient,
    required this.order,
    Key? key,
  }) : super(key: key);

  final Function callRecipient;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return order.recipientName != null && order.recipientName!.isNotBlank
        ? HStack(
            [
              //
              VStack(
                [
                  "Recipient Name".tr().text.gray500.medium.sm.make(),
                  order.recipientName!.text.medium.xl
                      .make()
                      .pOnly(bottom: Vx.dp20),
                ],
              ).expand(),
              //call
              CustomButton(
                icon: FlutterIcons.phone_call_fea,
                iconColor: Colors.white,
                title: "",
                color: Colors.green,
                shapeRadius: Vx.dp24,
                onPressed: callRecipient,
              ).wh(Vx.dp64, Vx.dp40).p12(),
            ],
          )
        : UiSpacer.emptySpace();
  }
}
