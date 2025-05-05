import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/view_models/vendor_finance_report.vm.dart';
import 'package:huops/views/pages/finance/widgets/earnings_report.view.dart';
import 'package:huops/views/pages/finance/widgets/sales_report.view.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class VendorFinanceReportPage extends StatelessWidget {
  const VendorFinanceReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorFinanceReportViewModel>.reactive(
      viewModelBuilder: () => VendorFinanceReportViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return SafeArea(
          child: VStack(
            [
              //
              HStack(
                [
                  "Report".tr().text.xl3.semiBold.white.make().expand(),
                  //export button
                  IconButton(
                    onPressed: () {
                      vm.exportSalesReport(context);
                    },
                    icon: vm.busy(vm.exportSalesReport)
                        ? BusyIndicator().wh(16, 16)
                        : Icon(
                            Icons.file_download,
                            color: Colors.white,
                          ),
                  ),
                  //filter button
                  IconButton(
                    onPressed: () {
                      vm.showDateFilter(context);
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                  ),
                ],
              ).px20(),
              //contained_tab_bar_view
              ContainedTabBarView(
                onChange: (index) {
                  vm.activeTabIndex = index;
                },
                tabBarProperties: TabBarProperties(
                  indicatorColor: AppColor.primaryColor,
                  labelColor: AppColor.accentColor,
                  unselectedLabelColor: Colors.white,
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tabs: [
                  //sales
                  Tab(text: "Sales".tr(),),
                  //earning
                  Tab(text: "Earnings".tr()),
                ],
                views: [
                  SalesReportView(vm: vm),
                  EarningsReportView(vm: vm),
                ],
              ).expand(),
            ],
          ),
        );
      },
    );
  }
}
