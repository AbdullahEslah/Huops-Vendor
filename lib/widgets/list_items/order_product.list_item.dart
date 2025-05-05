import 'package:flutter/material.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/models/order_product.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderProductListItem extends StatelessWidget {
  const OrderProductListItem({
    required this.orderProduct,
    Key? key,
  }) : super(key: key);

  final OrderProduct orderProduct;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        //qty
        "x ${orderProduct.quantity}".text.white.semiBold.make(),
        VStack(
          [
            //
            "${orderProduct.product?.name}".text.white.medium.make(),
            Visibility(
              visible: orderProduct.options != null &&
                  orderProduct.options!.isNotEmpty,
              child:
                  "${orderProduct.options ?? ''}".text.sm.gray500.medium.make(),
            ),
          ],
        ).px12().expand(),
        "${AppStrings.currencySymbol}${orderProduct.price}"
            .currencyFormat()
            .text.white
            .semiBold
            .make(),
        //
      ],
    );
  }
}
