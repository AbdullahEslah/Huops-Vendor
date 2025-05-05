import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/view_models/edit_profile.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePageWithoutNavBar(
          showLeadingAction: true,
          showAppBar: true,
          title: "Edit Profile".tr(),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //
                  Stack(
                    children: [
                      //
                      model.currentUser == null
                          ? BusyIndicator()
                          : model.newPhoto == null
                              ? CachedNetworkImage(
                                  imageUrl: model.currentUser?.photo ?? "",
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return BusyIndicator();
                                  },
                                  errorWidget: (context, imageUrl, progress) {
                                    return Image.asset(
                                      AppImages.user,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.6,
                                    Vx.dp64 * 1.6,
                                  )
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make()
                              : Image.file(
                                  model.newPhoto!,
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.6,
                                    Vx.dp64 * 1.6,
                                  )
                                  .box
                                  .roundedFull
                                  .clip(Clip.antiAlias)
                                  .make(),

                      //
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  context.theme.colorScheme.background,
                            ),
                            Icon(
                              FlutterIcons.camera_ant,
                              size: 16,
                              color: Colors.white,
                            )
                                .p(9)
                                .box
                                .color(AppColor.primaryColor)
                                .roundedFull
                                .shadow
                                .make()
                                .onInkTap(model.changePhoto),
                          ],
                        ),
                      )
                    ],
                  ).box.makeCentered(),

                  //form
                  Form(
                    key: model.formKey,
                    child: VStack(
                      [
                        //
                        Text(
                          "Full Name".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        CustomTextFormField(
                          textEditingController: model.nameTEC,
                          validator: FormValidator.validateName,
                        ).glassMorphic().py2(),
                        //
                        SizedBox(
                          height: 15,
                        ),

                        Text(
                          "Email".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        CustomTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: model.emailTEC,
                          validator: FormValidator.validateEmail,
                        ).glassMorphic().py2(),
                        //
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Phone".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        CustomTextFormField(
                          keyboardType: TextInputType.phone,
                          textEditingController: model.phoneTEC,
                          validator: FormValidator.validatePhone,
                        ).glassMorphic().py2(),

                        //
                        CustomButton(
                          title: "Update Profile".tr(),
                          loading: model.isBusy,
                          onPressed: () {
                            model.processUpdate(
                              onSuccess: (completed) {
                                if (completed == true) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                          shapeRadius: 12,
                        ).centered().py20(),
                      ],
                    ),
                  ).py20().px12(),
                ],
              ).px12().py20().scrollVertical()),
        );
      },
    );
  }
}
