import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/product.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class GridViewProductListItem extends StatelessWidget {
  const GridViewProductListItem({
    required this.product,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function(Product) onPressed;
  final Product product;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Stack(
          children: [
            //product image
            Hero(
              tag: product.heroTag ?? product.id,
              child: CustomImage(
                imageUrl: product.photo,
                boxFit: BoxFit.cover,
                width: context.percentWidth * 100,
                height: Vx.dp64 * 1.5,
              ).card.make(),
            ),

            //price
            Positioned(
              bottom: 0,
              right: 0,
              child: HStack(
                [
                  AppStrings.currencySymbol.text.white.make(),
                  product.showDiscount
                      ? "${product.price}"
                          .text
                          .sm
                          .lineThrough
                          .white
                          .make()
                          .px2()
                      : "${product.price}".text.xl.white.make(),
                  // discount price
                  product.showDiscount
                      ? "${product.discountPrice}".text.xl.white.make()
                      : UiSpacer.emptySpace(),
                ],
              ).py4().box.px8.rounded.color(AppColor.primaryColor).make(),
            ),
          ],
        ),

        //
        product.name.text.medium.lg
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .make(),
        "${product.vendor?.name}"
            .text
            .sm
            .maxLines(1)
            .overflow(TextOverflow.ellipsis)
            .make(),
      ],
    ).centered().onInkTap(
          () => this.onPressed(this.product),
        );
  }
}
