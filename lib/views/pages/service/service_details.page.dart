import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/service_details.vm.dart';
import 'package:huops/views/pages/service/widgets/service_details.bottomsheet.dart';
import 'package:huops/views/pages/service/widgets/service_details_price.section.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:huops/widgets/custom_masonry_grid_view.dart';
import 'package:huops/widgets/html_text_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ServiceDetailsPage extends StatelessWidget {
  const ServiceDetailsPage(
    this.service, {
    Key? key,
  }) : super(key: key);

  //
  final Service service;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceDetailsViewModel>.reactive(
      viewModelBuilder: () => ServiceDetailsViewModel(context, service),
      builder: (context, vm, child) {
        return BasePageWithoutNavBar(
          extendBodyBehindAppBar: true,
          onBackPressed: () => vm.goBack(),
          body: Stack(
            alignment: Alignment.bottomCenter,

            children: [
              //
              Align(
                alignment: Alignment.topCenter,
                child: CustomImage(
                  imageUrl:
                      vm.service.photos.isNotEmpty ? vm.service.photos.first : '',
                  width: double.infinity,
                  height: context.percentHeight * 50,
                  canZoom: false,
                ),
              ),

              //service details section
              Stack(
                alignment: Alignment.topRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: context.percentHeight * 65,
                    decoration: BoxDecoration(
                      gradient: AppColor.LightBg,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: VStack(
                        [
                          //details
                          VStack(
                            [
                              //name
                              vm.service.name.text.medium.white.xl2.make(),
                              vm.service.vendor!.name.text.medium.white.xl2.make(),
                              //price
                              ServiceDetailsPriceSectionView(vm.service),

                              HStack([
                                "Description: ".text.medium.white.lg.make(),
                                vm.service.description!.text.medium.maxLines(3).white.lg.make(),
                              ]),

                              //rest details
                              UiSpacer.verticalSpace(),
                              VStack(
                                [
                                  //photos
                                  CustomMasonryGridView(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    items: vm.service.photos
                                        .map(
                                          (photo) => CustomImage(
                                            imageUrl: photo,
                                            width: double.infinity,
                                            height: 100,
                                          ).box.roundedSM.clip(Clip.antiAlias).make().centered(),
                                        )
                                        .toList(),
                                  ),

                                  //description
                                  // HtmlTextView(vm.service.description, padding: 0),
                                ],
                              )
                                  .box
                                  .p12
                                  .shadowXs
                                  .roundedSM
                                  .make().glassMorphic(opacity: .1),

                              //spaces
                              UiSpacer.verticalSpace(),
                              UiSpacer.verticalSpace(),
                              UiSpacer.verticalSpace(),
                            ],
                          )
                          //     .wFull(context)
                          // .hFull(context)
                          //     .p20()
                          //     .box
                          //     .topRounded(value: 30)
                          //     .make().glassMorphic(opacity: .1),
                        ],
                      ).pOnly(bottom: context.percentHeight * 3)
                          .box
                          .outerShadow3Xl
                          .clip(Clip.antiAlias)
                          .topRounded(value: 20)
                          .make().p20(),
                    ),
                  ),
                ],
              ),

              //appbar section
              Positioned(
                top: kToolbarHeight,
                left: !Utils.isArabic ? Vx.dp20 : null,
                right: Utils.isArabic ? Vx.dp20 : null,
                child: Icon(
                  !Utils.isArabic
                      ? FlutterIcons.arrow_left_fea
                      : FlutterIcons.arrow_right_fea,
                  color: Colors.white,
                )
                    .p12()
                    .box
                    .roundedSM
                    .make()
                    .onTap(
                      () => context.pop(),
                    ),
              ),
            ],
          ),
          //
          bottomNavigationBar: ServiceDetailsBottomSheet(vm),
        );
      },
    );
  }
}
