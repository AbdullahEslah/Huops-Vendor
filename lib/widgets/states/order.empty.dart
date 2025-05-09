import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyOrder extends StatelessWidget {

  final String title;
  final String description;
  EmptyOrder({
    super.key,
    this.title="No Order",
    this.description="When you are assigned an order, they will appear here",
  });
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.emptyCart,
      title: title.tr(),
      description: description.tr(),
    ).p20().centered();
  }
}
