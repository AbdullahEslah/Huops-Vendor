import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/order_details.vm.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderStatusView extends StatelessWidget {
  const OrderStatusView(this.vm, {Key? key}) : super(key: key);

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HStack(
          [
            VStack(
              [
                "Status".tr().text.gray300.medium.sm.make(),
                vm.order.status
                    .allWordsCapitilize()
                    .text
                    .color(AppColor.getStausColor(vm.order.status))
                    .medium
                    .xl
                    .make(),
              ],
            ).expand(),
            //Payment status
            VStack(
              crossAlignment: CrossAxisAlignment.start,
              [
                //
                "Payment Status".tr().text.gray300.medium.sm.make(),
                //
                "${vm.order.paymentStatus}"
                    .tr()
                    .capitalized
                    .text
                    .color(AppColor.getStausColor(vm.order.paymentStatus))
                    .medium
                    .xl
                    .make(),
                //
              ],
            ),
          ],
        ),

        vm.order.reason == null ? SizedBox() : 10.heightBox,
        vm.order.reason == null ? SizedBox() :
        "Reason of Cancellation".tr().text.gray300.medium.make(),
        vm.order.reason == null ? SizedBox() :
        "${vm.order.reason}".text.lg.white.make(),

        //payment method
        Visibility(
          visible: vm.order.paymentMethod != null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UiSpacer.verticalSpace(),
              "Payment Method".tr().text.gray300.medium.sm.make(),
              "${vm.order.paymentMethod?.name ?? ''}".text.white.medium.xl.make(),
            ],
          ),
        ),

        //scheduled order info
        vm.order.isScheduled
            ? HStack(
                [
                  //date
                  VStack(
                    [
                      //
                      "Scheduled Date".tr().text.gray300.medium.sm.make(),
                      "${vm.order.pickupDate}"
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ).expand(),
                  //time
                  if (vm.order.pickupTime != null)
                    VStack(
                      [
                        //
                        "Scheduled Time".tr().text.gray300.medium.sm.make(),
                        "${Jiffy.parse(vm.order.pickupTime!).format(pattern: "hh:mm a")}"
                            .text
                            .color(AppColor.getStausColor(vm.order.status))
                            .medium
                            .xl
                            .make()
                            .pOnly(bottom: Vx.dp20),
                      ],
                    ),
                ],
              )
            : UiSpacer.emptySpace(),
      ],
    );
  }
}
