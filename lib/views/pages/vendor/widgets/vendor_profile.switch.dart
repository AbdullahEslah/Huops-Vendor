import 'package:flutter/material.dart';
import 'package:huops/view_models/vendor_details.view_model.dart';
import 'package:huops/widgets/states/loading_indicator.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorProfileSwitcher extends StatelessWidget {
  const VendorProfileSwitcher(
    this.vm, {
    super.key,
  });

  final VendorDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      loading: vm.isBusy,
      child: HStack(
        [
          // VStack(
          //   [
          //     "${vm.vendor?.name}".text.semiBold.lg.make(),
          //     "${vm.vendor?.address ?? ''}".text.sm.maxLines(1).ellipsis.make(),
          //   ],
          // ).expand(),
          // 20.widthBox,
          Visibility(
            visible: vm.user?.hasMultipleVendors ?? false,
            child: HStack(
              [
                "Tap to switch".tr().text.sm.white.make(),
                Icon(
                  Icons.swap_vert,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ).py(2).px(4).box.roundedSM.border(color: Colors.white).make().onTap(() {
              vm.openVendorProfileSwitcher();
            }),
          ),
        ],
        crossAlignment: CrossAxisAlignment.start,
        alignment: MainAxisAlignment.start,
      ).py12(),
    );
  }
}
