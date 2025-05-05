import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:huops/services/custom_form_builder_validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/payment_accounts.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewPaymentAccountBottomSheet extends StatefulWidget {
  NewPaymentAccountBottomSheet(this.vm, {Key? key}) : super(key: key);

  final PaymentAccountsViewModel vm;

  @override
  State<NewPaymentAccountBottomSheet> createState() =>
      _NewPaymentAccountBottomSheetState();
}

class _NewPaymentAccountBottomSheetState
    extends State<NewPaymentAccountBottomSheet> {
  GlobalKey<FormBuilderState> formBuilderKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    //
    return VStack(
      [
        //
        UiSpacer.formVerticalSpace(),
        "New Payment Account".tr().text.semiBold.white.xl2.make(),
        UiSpacer.formVerticalSpace(),
        //
        FormBuilder(
          key: formBuilderKey,
          child: VStack(
            [
              //
              FormBuilderTextField(
                name: 'name',
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "   Payment Account Name".tr(),
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  border: InputBorder.none,
                ),
                onChanged: (value) {},
                validator: CustomFormBuilderValidator.required,
                textInputAction: TextInputAction.next,
              ).glassMorphic(),
              UiSpacer.formVerticalSpace(),
              FormBuilderTextField(
                name: 'number',
                style: TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  hintText: '   Account Number'.tr(),
                  hintStyle: TextStyle(color: Colors.grey.shade300),

                  border: InputBorder.none,
                ),
                onChanged: (value) {},
                validator: CustomFormBuilderValidator.required,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ).glassMorphic(),
              UiSpacer.formVerticalSpace(),
              FormBuilderTextField(
                name: 'instructions',
                minLines: 4,
                maxLines: 5,
                style: TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  hintText: '   Instructions'.tr(),
                  hintStyle: TextStyle(color: Colors.grey.shade300),

                  border: InputBorder.none,
                ),
                onChanged: (value) {},
                textInputAction: TextInputAction.next,
              ).glassMorphic(),
              UiSpacer.formVerticalSpace(space: 2),
              FormBuilderCheckbox(
                name: 'is_active',
                title: "Active".tr().text.white.make(),
                onChanged: (value) {},
              ),
              UiSpacer.formVerticalSpace(space: 2),
              CustomButton(
                loading: isLoading,
                title: "Save".tr(),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final result =
                      await widget.vm.saveNewPaymentAccount(formBuilderKey);
                  setState(() {
                    isLoading = false;
                  });

                  //
                  if (result) {
                    context.pop();
                  }
                },
              ).wFull(context),
            ],
          ),
        ),
      ],
    ).p20().glassMorphic(opacity: 0.1,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)));
  }
}
