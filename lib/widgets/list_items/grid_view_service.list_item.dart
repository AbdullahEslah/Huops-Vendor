import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class GridViewServiceListItem extends StatelessWidget {
  const GridViewServiceListItem({
    required this.service,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function(Service) onPressed;
  final Service service;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //service image
        Stack(
          children: [
            Hero(
              tag: service.heroTag ?? service.id,
              child: CustomImage(
                imageUrl:
                "${service.photos.isNotEmpty ? service.photos.first : ''}",
                boxFit: BoxFit.cover,
                width: double.infinity,
                height: Vx.dp64 * 2,
              ),
            ),
          ],
        ),

        //
        VStack(
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              service.name.text.white.medium.xl.make(),
              service.showDiscount
                  ? "${AppStrings.currencySymbol}${service.price -
                  service.discountPrice} ${'Off'.tr()}"
                  .text
                  .white
                  .semiBold
                  .make()
                  .p2()
                  .px4()
                  .box
                  .color(AppColor.primaryColor)
                  .topRightRounded(value: !Utils.isArabic ? 0 : 10)
                  .topLeftRounded(value: Utils.isArabic ? 0 : 10)
                  .make() : SizedBox(),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ("${service.duration}".tr()).text.white.medium.xl.make(),
                HStack([
                  "${AppStrings.currencySymbol}"
                      .text
                      .lg
                      .light
                      .color(AppColor.primaryColor)
                      .make(),
                  service.price.text.semiBold
                      .color(AppColor.primaryColor)
                      .xl
                      .make(),
                ]),
              ],
            ),
          ],
        ).p12(),
      ],
    )
        .box
        .withRounded(value: 10)
        .outerShadow
        .clip(Clip.antiAlias)
        .makeCentered()
        .onInkTap(
          () => this.onPressed(this.service),
    ).glassMorphic(opacity: .1);
  }
}
