import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/vendor_details.view_model.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OnlineStatusToggle extends StatelessWidget {
  const OnlineStatusToggle(
    this.vm, {
    super.key,
  });

  final VendorDetailsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        // HStack(
        //   [
        //     "Status".tr().text.medium.lg.make().expand(),
        //     ((vm.vendor!.isOpen) ? "Open".tr() : "Close".tr())
        //         .text
        //         .semiBold
        //         .xl
        //         .color((vm.vendor!.isOpen)
        //             ? AppColor.openColor
        //             : AppColor.closeColor)
        //         .make(),
        //   ],
        // ),
        //
        vm.busy(vm.vendor!.isOpen)?Center(child: CircularProgressIndicator()):GestureDetector(
          onTap: vm.toggleVendorAvailablity,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageIcon(AssetImage("assets/images/power.png"),color: (vm.vendor!.isOpen) ? Colors.green : Colors.red,),
                SizedBox(width: 10,),
                Text((vm.vendor!.isOpen) ? "You are online".tr() : "You are offline".tr(),style: TextStyle(color:(vm.vendor!.isOpen) ? Colors.green : Colors.red,fontWeight: FontWeight.bold),),
              ],
            ),
          ).glassMorphic(circularRadius: 30).centered(),
        ),

      ],
    );
  }
}
