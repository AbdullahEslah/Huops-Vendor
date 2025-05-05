import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';

import 'package:huops/view_models/forgot_password.view_model.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePageWithoutNavBar(
          showLeadingAction: true,
          showAppBar: true,
          title: "Forgot Password".tr(),
          body: SafeArea(
            top: true,
            bottom: false,
            child: VStack(
              [
                Image.asset(
                  AppImages.forgotPasswordImage,
                ).hOneForth(context).py12().centered(),
                //
                VStack(
                  [
                    //
                    "Forgot Password".tr().text.xl2.white.semiBold.make(),

                    //form
                    Form(
                      key: model.formKey,
                      child: VStack(
                        [
                          //
                          CustomTextFormField(
                            prefixIcon: HStack(
                              [
                                //icon/flag
                                Flag.fromString(
                                  model.selectedCountry.countryCode,
                                  width: 20,
                                  height: 20,
                                ),
                                UiSpacer.horizontalSpace(space: 5),
                                //text
                                ("+" + model.selectedCountry.phoneCode)
                                    .text
                                    .make(),
                              ],
                            ).px8().onInkTap(model.showCountryDialPicker),
                            hintText: "Phone Number".tr(),
                            // hintText: "",
                            keyboardType: TextInputType.phone,
                            textEditingController: model.phoneTEC,
                            validator: FormValidator.validatePhone,
                          ).glassMorphic().py12(),
                          //
                          CustomButton(
                            title: "Send OTP".tr(),
                            loading: model.isBusy,
                            onPressed: model.processForgotPassword,
                          ).h(Vx.dp48).centered().py12(),
                        ],
                        crossAlignment: CrossAxisAlignment.end,
                      ),
                    ).py20(),
                  ],
                )
                    .wFull(context)
                    .p20()
                    .scrollVertical()
                    .box
                    // .color(context.cardColor)
                    .make()
                    .expand(),

                //
              ],
            ),
          ),
        );
      },
    );
  }
}
