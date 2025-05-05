import 'package:flutter/material.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/vendor_switcher.vm.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/states/loading_indicator.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorSwitcherBottomSheetView extends StatefulWidget {
  const VendorSwitcherBottomSheetView({Key? key}) : super(key: key);
  @override
  _VendorSwitcherBottomSheetViewState createState() =>
      _VendorSwitcherBottomSheetViewState();
}

class _VendorSwitcherBottomSheetViewState
    extends State<VendorSwitcherBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorSwitcherBottomSheetViewModel>.reactive(
      viewModelBuilder: () => VendorSwitcherBottomSheetViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchMyVendors(),
      builder: (
        BuildContext context,
        VendorSwitcherBottomSheetViewModel model,
        Widget? child,
      ) {
        return BasePageWithoutNavBar(
          // backgroundColor: Colors.transparent,
          body: VStack(
            [
              //
              VStack(
                [
                  "List of vendors".tr().text.xl2.white.semiBold.make(),
                  "Please select a vendor to switch to".tr().text.white.make(),
                ],
              ).p(12),
              UiSpacer.divider(),
              CustomListView(
                dataSet: model.vendors,
                isLoading: model.busy(model.vendors),
                itemBuilder: (context, index) {
                  final vendor = model.vendors[index];
                  return AbsorbPointer(
                    absorbing: model.isBusy,
                    child: LoadingIndicator(
                      loading: model.busy(vendor.id),
                      child: ListTile(
                        onTap: () {
                          model.switchVendor(vendor);
                        },
                        leading: CustomImage(
                          imageUrl: vendor.logo,
                          width: 30,
                          height: 30,
                        ),
                        title: "${vendor.name}".text.white.make(),
                        subtitle: "${vendor.address}"
                            .text
                            .ellipsis.white
                            .maxLines(1)
                            .make(),
                        trailing: Icon(
                          Utils.isArabic
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ).expand(),
            ],
          ).glassMorphic(opacity: .1),
        );
      },
    );
  }
}
