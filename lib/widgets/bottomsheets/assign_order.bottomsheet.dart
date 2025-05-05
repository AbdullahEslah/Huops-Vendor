import 'package:flutter/material.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/assign_order.vm.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AssignOrderBottomSheet extends StatelessWidget {
  AssignOrderBottomSheet({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  final Function(int) onConfirm;

  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AssignOrderViewModel>.reactive(
      viewModelBuilder: () => AssignOrderViewModel(),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return SafeArea(
          child: VStack(
            [
              //
              "Assign Order To:".tr().text.semiBold.white.xl.make(),
              UiSpacer.verticalSpace(),
              CustomTextFormField(
                hintText: "Search Driver".tr(),
                onChanged: vm.filterDrivers,
              ).glassMorphic(),
              UiSpacer.verticalSpace(),
              //

              vm.isBusy
                  ? CircularProgressIndicator().centered().expand()
                  : CustomListView(
                      dataSet: vm.drivers,
                      itemBuilder: (context, index) {
                        //
                        final driver = vm.drivers[index];
                        return HStack(
                          [
                            //
                            Radio(
                              value: driver.id,
                              groupValue: vm.selectedDriverId,
                              onChanged: vm.changeSelectedDriver,
                            ),

                            //
                            "${driver.name}".text.lg.gray400.make().expand(),
                            //online/offline
                            "[${(driver.isOnline ? "Online".tr() : "Offline".tr())}]"
                                .text
                                .color(
                                    driver.isOnline ? Colors.green : Colors.red)
                                .make(),
                          ],
                        )
                            .onInkTap(() => vm.changeSelectedDriver(driver.id))
                            .wFull(context);
                      },
                      separatorBuilder: (p0, p1) => SizedBox(
                        height: 5,
                      ),
                    ).py4().expand(),

              //
              CustomButton(
                title: "Assign".tr(),
                onPressed: vm.selectedDriverId != null
                    ? () => onConfirm(vm.selectedDriverId!)
                    : null,
              ),
            ],
          ).p20().h(context.safePercentHeight * 65).glassMorphic(
              opacity: 0.1,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        );
      },
    );
  }
}
