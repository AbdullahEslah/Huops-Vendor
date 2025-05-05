import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/order_details.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/list_items/parcel_order_stop.list_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderAddressView extends StatelessWidget {
  const OrderAddressView(this.vm, {Key? key}) : super(key: key);
  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //show package delivery addresses
        vm.order.isPackageDelivery
            ? VStack(
                [
                  //pickup location routing
                  ParcelOrderStopListView(
                    "Pickup Location".tr(),
                    vm.order.orderStops!.first,
                    canCall: vm.order.canChatCustomer,
                    routeToLocation: vm.routeToLocation,
                  ),

                  //stops
                  ...(vm.order.orderStops!.sublist(1).mapIndexed((stop, index) {
                    return ParcelOrderStopListView(
                      "Stop".tr() + " ${index + 1}",
                      stop,
                      canCall: vm.order.canChatCustomer,
                      routeToLocation: vm.routeToLocation,
                    );
                  }).toList()),
                ],
              )
            : UiSpacer.emptySpace(),

        //regular delivery address
        Visibility(
          visible: !vm.order.isPackageDelivery,
          child: VStack(
            [
              "Delivery details".tr().text.xl.white.semiBold.make(),
              //vendor address
              HStack(
                [
                  //
                  Image.asset(
                    AppImages.pickupLocation,
                    width: 15,
                    height: 15,
                  ),
                  UiSpacer.horizontalSpace(space: 5),
                  //
                  VStack(
                    [
                      vm.order.vendor?.address != null
                          ? Container(
                        width: MediaQuery.of(context).size.width *.7,
                        child: "${vm.order.vendor?.address}".text.maxLines(2).white.make(),
                      )
                          : UiSpacer.emptySpace(),
                    ],
                  ),
                ],
                crossAlignment: CrossAxisAlignment.start,
              ).py12(),
              //delivery address
              HStack(
                [
                  //
                  Image.asset(
                    AppImages.dropoffLocation,
                    width: 15,
                    height: 15,
                  ),
                  UiSpacer.horizontalSpace(space: 5),
                  //
                  VStack(
                    [
                      vm.order.deliveryAddress != null
                          ? Container(
                        width: MediaQuery.of(context).size.width *.7,
                        child: "${vm.order.deliveryAddress?.address}".text.white.make(),
                      )
                          : UiSpacer.emptySpace(),
                      vm.order.deliveryAddress != null
                          ? Container(
                        width: MediaQuery.of(context).size.width *.7,
                        child: "${vm.order.deliveryAddress?.name}".text.color(Vx.gray300).sm.light.make(),
                      )
                          : UiSpacer.emptySpace(),
                    ],
                  ),
                ],
                crossAlignment: CrossAxisAlignment.start,
              ),
              //delivery address route
              if (!vm.order.canChatCustomer && vm.order.deliveryAddress != null)
                CustomButton(
                  icon: FlutterIcons.navigation_fea,
                  iconSize: 16,
                  iconColor: Colors.white,
                  color: AppColor.primaryColor,
                  shapeRadius: Vx.dp20,
                  onPressed: () =>
                      vm.routeToLocation(vm.order.deliveryAddress!),
                ).wh(Vx.dp64, Vx.dp40).p12(),
            ],
          ),
        ),
        //regular delivery address
        // HStack(
        //   [
        //     VStack(
        //       [
        //         "Deliver To".tr().text.gray500.medium.sm.make(),
        //         vm.order.deliveryAddress != null
        //             ? vm.order.deliveryAddress.name.text.xl.medium.make()
        //             : UiSpacer.emptySpace(),
        //         vm.order.deliveryAddress != null
        //             ? vm.order.deliveryAddress.address.text
        //                 .make()
        //                 .pOnly(bottom: Vx.dp20)
        //             : UiSpacer.emptySpace(),
        //       ],
        //     ).expand(),
        //     //route
        //     vm.order.canChatCustomer && vm.order.deliveryAddress != null
        //         ? CustomButton(
        //             icon: FlutterIcons.navigation_fea,
        //             iconColor: Colors.white,
        //             color: AppColor.primaryColor,
        //             shapeRadius: Vx.dp20,
        //             onPressed: () =>
        //                 vm.routeToLocation(vm.order.deliveryAddress),
        //           ).wh(Vx.dp64, Vx.dp40).p12()
        //         : UiSpacer.emptySpace(),
        //   ],
        // ),

        //
        (!vm.order.isPackageDelivery && vm.order.deliveryAddress == null)
            ? "Customer Order Pickup"
                .tr()
                .text
                .xl.white
                .semiBold
                .make()
                .pOnly(bottom: Vx.dp20)
            : UiSpacer.emptySpace(),
      ],
    );
  }
}
