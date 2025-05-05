import 'dart:io';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_upgrade_settings.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/views/pages/finance/vendor_finance_report.page.dart';
import 'package:huops/views/pages/profile/profile.page.dart';
import 'package:huops/view_models/home.vm.dart';
import 'package:huops/views/pages/vendor/vendor_details.page.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'order/orders.page.dart';
import 'reservation/reservation.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //
    bool canViewReport = AuthServices.currentUser?.allPermissions
            .contains("view_report_on_app") ??
        true;
    //
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePageWithoutNavBar(
            customAppbar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
              child: AppBar(
                elevation: 0,
                toolbarHeight: MediaQuery.of(context).size.height * 0.12,
                title: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  color: AppColor.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome back".tr(),
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "${model.currentVendor?.name}" ?? "",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: model.openQRCode,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    CupertinoIcons.qrcode,
                                    color: AppColor.primaryColor,
                                    size: 27,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: model.openNotification,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    CupertinoIcons.bell,
                                    color: AppColor.primaryColor,
                                    size: 27,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ).p0(),
                ),
              ),
            ),
            body: UpgradeAlert(
              upgrader: Upgrader(
                showIgnore: !AppUpgradeSettings.forceUpgrade(),
                shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: PageView(
                  controller: model.pageViewController,
                  onPageChanged: model.onPageChanged,
                  children: [
                    OrdersPage(),
                    TableReservation(),
                    //
                    Utils.vendorSectionPage(model.currentVendor),
                    VendorDetailsPage(),

                    //  removed report page from bottomNavBar

                    // if (canViewReport)
                    //   // show report page
                    //   VendorFinanceReportPage(),

                    //
                    ProfilePage(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 20, left: 20),
              child: BottomNavigationBar(
                iconSize: 24,
                backgroundColor: Colors.transparent,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                unselectedItemColor: Colors.grey,
                fixedColor: AppColor.primaryColor,
                type: BottomNavigationBarType.fixed,
                currentIndex: model.currentIndex,
                onTap: model.onTabChange,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(FlutterIcons.inbox_ant), label: 'Orders'.tr()),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.calendar_today),
                      label: 'Bookings'.tr()),
                  BottomNavigationBarItem(
                      icon:
                          Icon(Utils.vendorIconIndicator(model.currentVendor)),
                      label:
                          Utils.vendorTypeIndicator(model.currentVendor).tr()),
                  BottomNavigationBarItem(
                    icon: Icon(
                      FlutterIcons.briefcase_fea,
                    ),
                    label: 'Vendor'.tr(),
                  ),

                  //  removed report page from bottomNavBar

                  // if (canViewReport)
                  // BottomNavigationBarItem(
                  //     icon: Icon(
                  //       FlutterIcons.dollar_sign_fea,
                  //     ),
                  //     label: 'Report'.tr()),
                  BottomNavigationBarItem(
                      icon: Icon(FlutterIcons.menu_ent), label: 'Menu'.tr()),
                ],
              ).glassMorphic(opacity: .1),
            ),
          );
        },
      ),
    );
  }
}
