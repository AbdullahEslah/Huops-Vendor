import 'package:flutter/material.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/order_details.vm.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderAttachmentView extends StatelessWidget {
  const OrderAttachmentView(this.vm, {Key? key}) : super(key: key);

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    if (vm.order.attachments != null && vm.order.attachments!.isNotEmpty) {
      return 0.widthBox;
    }
    return VStack(
      [
        "Attachments".tr().text.xl.white.semiBold.make(),
        UiSpacer.vSpace(10),
        CustomGridView(
          dataSet: vm.order.attachments!,
          noScrollPhysics: true,
          itemBuilder: (ctx, index) {
            final attachment = vm.order.attachments![index];
            return Column(
              children: [
                CustomImage(
                  imageUrl: attachment.link ?? "",
                  canZoom: true,
                  width: double.infinity,
                  height: ctx.percentHeight * 14,
                ),
                //
                "${attachment.collectionName}".text.white.make().py2(),
              ],
            );
          },
        ),
      ],
    ).p8().p12();
  }
}
