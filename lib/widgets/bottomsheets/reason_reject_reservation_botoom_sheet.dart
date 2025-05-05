import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:huops/services/custom_form_builder_validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/payment_accounts.vm.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ReasonRejectReservationBottomSheet extends StatefulWidget {
  ReasonRejectReservationBottomSheet(this.vm, {Key? key}) : super(key: key);

  final ReservationViewModel vm;

  @override
  State<ReasonRejectReservationBottomSheet> createState() =>
      _ReasonRejectReservationBottomSheetState();
}

class _ReasonRejectReservationBottomSheetState
    extends State<ReasonRejectReservationBottomSheet> {
  GlobalKey<FormBuilderState> formBuilderKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    //
    return VStack(
      [
        //
        "Reason for Rejection".tr().text.semiBold.white.xl2.make(),
        //
        VStack(
          [

            UiSpacer.formVerticalSpace(),
            CustomTextFormField(
              textEditingController: widget.vm.reasonController,
              minLines: 4,
              maxLines: 5,
                hintText: 'Type here'.tr(),
            ).glassMorphic(),

            UiSpacer.formVerticalSpace(),
            isLoading? Center(child: CircularProgressIndicator(),):Row(
              children: [
                CustomButton(
                  title: "Send".tr(),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final result =
                    await widget.vm.changeStatusMethod("2");
                    setState(() {
                      isLoading = false;
                    });
                    context.pop();

                  },
                ).expand(),
                SizedBox(width: 10,),
                CustomButton(
                  title: "Undo".tr(),
                  onPressed: () async {
                   context.pop();
                  },
                ).expand(),

              ],
            ),
          ],
        ),
      ],
    ).p20().glassMorphic(opacity: 0.1,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),),);
  }
}
