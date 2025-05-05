import 'package:flutter/material.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../constants/app_colors.dart';

class OrderEditStatusBottomSheet extends StatefulWidget {
  OrderEditStatusBottomSheet(
    this.selectedStatus, {
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  final Function(String) onConfirm;
  final String selectedStatus;
  @override
  _OrderEditStatusBottomSheetState createState() =>
      _OrderEditStatusBottomSheetState();
}

class _OrderEditStatusBottomSheetState
    extends State<OrderEditStatusBottomSheet> {
  //
  List<String> statues = [
    'pending',
    'preparing',
    'ready',
    'pickup',
    'failed',
    'cancelled',
    'delivered'
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    //
    setState(() {
      selectedStatus = widget.selectedStatus;
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Change Order Status".tr().text.semiBold.white.xl.make(),
        //
        ...statues.map((e) {
          //
          return HStack(
            [
              //
              Radio(
                value: e,
                groupValue: selectedStatus,activeColor: AppColor.primaryColor,
                onChanged: _changeSelectedStatus,
              ),

              //
              e.tr().allWordsCapitilize().text.lg.gray400.make(),
            ],
          ).onInkTap(() => _changeSelectedStatus(e)).wFull(context);
        }).toList(),

        //
        UiSpacer.verticalSpace(),
        //
        CustomButton(
          title: "Change".tr(),
          onPressed: selectedStatus != null
              ? () => widget.onConfirm(selectedStatus!)
              : null,
        ),
      ],
    ).p20().scrollVertical().hTwoThird(context).glassMorphic(opacity: 0.1,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)));
  }

  void _changeSelectedStatus(value) {
    setState(() {
      selectedStatus = value;
    });
  }
}
