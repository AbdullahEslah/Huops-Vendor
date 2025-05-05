import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/profile.vm.dart';
import 'package:huops/views/pages/profile/images/images_page.dart';
import 'package:huops/views/pages/profile/paymet_accounts.page.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/cards/profile.card.dart';
import 'package:huops/widgets/menu_item.dart';
import 'package:line_icons/line_icon.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../services/auth.service.dart';
import '../storage_bags_price/storage_bags_price_page.dart';
import 'images/add_images_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {

  bool isStorageBagsReservation = false;

  @override
  void initState() {
    getIsStorageBagsReservation();
    super.initState();
  }

  getIsStorageBagsReservation()async{
    if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
      setState(() {
        isStorageBagsReservation = true;
      });
    }else{
      setState(() {
        isStorageBagsReservation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePageWithoutNavBar(
            body: VStack(
              [
                //
                // "Settings".tr().text.xl2.semiBold.make().py0(),
                // "Profile & App Settings".tr().text.lg.light.make(),
                //
                Column(
                  children: [
                    (model.isBusy || model.currentUser == null)
                        ? BusyIndicator().centered().p20(): Row(
                      children: [
                       CachedNetworkImage(
                          imageUrl: model.currentUser!.photo,
                          progressIndicatorBuilder:
                              (context, imageUrl, progress) {
                            return BusyIndicator();
                          },
                          errorWidget: (context, imageUrl, progress) {
                            return Image.asset(
                              AppImages.user,
                            );
                          },
                        )
                            .wh(Vx.dp64, Vx.dp64)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.currentUser!.name.text.xl.white.maxLines(2).semiBold.make(),
                            // model.currentUser!.name.text.xl.white.maxLines(2).semiBold.make().expand(),
                            //email
                            model.currentUser!.email.text.maxLines(2).white.make(),
                          ],
                        ).expand(),
                        // Spacer(),
                        IconButton(
                          onPressed: model.openEditProfile,
                          icon: Icon(
                            FlutterIcons.edit_faw,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ).pOnly(bottom: 8),
                    Visibility(visible: !Platform.isIOS,child: SizedBox(height: 8,)),
                    Visibility(
                      visible: !Platform.isIOS,
                      child: GestureDetector(
                        onTap: () async{
                          try {
                            final url = await Api.redirectAuth(Api.backendUrl);
                            model.openExternalWebpageLink(url);
                          } catch (error) {
                            model.toastError("$error");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // color: AppColor.primaryColor.withOpacity(0.1),
                          ),
                          child: Row(
                              children: [
                            Icon(Icons.dashboard_outlined,
                                color: AppColor.primaryColor),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Dashboard".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                            ),
                          ]),
                        ),
                      ).glassMorphic(),
                    ),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: () {
                        context.push((ctx) => ImagesPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(Icons.image_outlined,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Photos".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),

                    isStorageBagsReservation ? SizedBox(height: 8,) : SizedBox(),

                    isStorageBagsReservation ? GestureDetector(
                      onTap: () {
                        context.push((ctx) => StorageBagsPricePage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(Icons.shopping_bag_sharp,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Storage bags price".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic() : SizedBox(),

                    SizedBox(height: 8,),
                    GestureDetector(
                      onTap: model.openContactUs,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                            children: [
                          Icon(SimpleLineIcons.support,
                              color: AppColor.primaryColor),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Support".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                          ),
                        ]),
                      ),
                    ).glassMorphic(),

                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: () {
                        context.push((ctx) => PaymentAccountsPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                          Icon(Icons.payment_outlined,
                              color: AppColor.primaryColor),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Payment Accounts".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                          ),
                        ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: model.openChangePassword,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(Icons.password_outlined,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Change Password".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: model.openReviewApp,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(Icons.rate_review_outlined,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Rate App".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: model.openFaqs,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(FlutterIcons.frequently_asked_questions_mco,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("FAQs".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: model.openPrivacyPolicy,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(Icons.privacy_tip_outlined,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Privacy Policy".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: model.changeLanguage,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(FontAwesome.language,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Language".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),

                    GestureDetector(
                      onTap: model.logoutPressed,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: AppColor.primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                            children: [
                              Icon(AntDesign.logout,
                                  color: AppColor.primaryColor),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Logout".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey.shade300),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: AppColor.primaryColor,
                              ),
                            ]),
                      ),
                    ).glassMorphic(),
                    SizedBox(height: 8,),
                    GestureDetector(
                      onTap: model.deleteAccount,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red,
                        ),
                        child: Row(
                            children: [
                              Icon(CupertinoIcons.delete,
                                  color: Colors.white),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Delete Account".tr(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),).text.make(),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,color: Colors.white,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ).px(2),

                //menu
                // VxBox(
                //   child: VStack(
                //     [
                //       //
                //       MenuItem(
                //         title: "Notifications".tr(),
                //         onPressed: model.openNotification,
                //       ),
                //
                //       //
                //       MenuItem(
                //         title: "Rate & Review".tr(),
                //         onPressed: model.openReviewApp,
                //       ),
                //       MenuItem(
                //         title: "Faqs".tr(),
                //         onPressed: model.openFaqs,
                //       ),
                //       //
                //       MenuItem(
                //         title: "Verison".tr(),
                //         suffix: model.appVersionInfo.text.make(),
                //       ),
                //
                //       //
                //       MenuItem(
                //         title: "Privacy Policy".tr(),
                //         onPressed: model.openPrivacyPolicy,
                //       ),
                //       //
                //       MenuItem(
                //         title: "Contact Us".tr(),
                //         onPressed: model.openContactUs,
                //       ),
                //       MenuItem(
                //         title: "Live support".tr(),
                //         onPressed: model.openLivesupport,
                //       ),
                //       //
                //       MenuItem(
                //         title: "Language".tr(),
                //         divider: false,
                //         suffix: Icon(
                //           FlutterIcons.language_ent,
                //         ),
                //         onPressed: model.changeLanguage,
                //       ),
                //     ],
                //   ),
                // )
                //     // .border(color: Theme.of(context).cardColor)
                //     // .color(Theme.of(context).cardColor)
                //     .color(Theme.of(context).colorScheme.background)
                //     .outerShadow
                //     .withRounded(value: 5)
                //     .make(),

                //
                "Copyright ©%s %s all right reserved"
                    .tr()
                    .fill([
                      "${DateTime.now().year}",
                      AppStrings.companyName,
                    ])
                    .text
                    .center
                    .sm
                    .makeCentered()
                    .py20(),
              ],
            ).px20().scrollVertical(physics: BouncingScrollPhysics()),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
