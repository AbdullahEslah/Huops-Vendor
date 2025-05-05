import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/login.view_model.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/custom_outline_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'login/scan_login.view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePageWithoutNavBar(
          isLoading: model.isBusy,
          body: SafeArea(
            top: true,
            bottom: false,
            child: VStack([
              UiSpacer.vSpace(5 * context.percentHeight),
              //
              HStack(
                [
                  VStack(
                    [
                      "Welcome Back".tr().text.xl2.white.semiBold.make(),
                      "Login to continue".tr().text.white.make(),
                    ],
                  ).expand(),
                  UiSpacer.hSpace(),
                  Image.asset(AppImages.appLogo)
                      .wh(60, 60)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()
                      .p12(),
                ],
                crossAlignment: CrossAxisAlignment.center,
                alignment: MainAxisAlignment.center,
              ),

              //form
              Form(
                key: model.formKey,
                child: VStack(
                  [
                    //
                    CustomTextFormField(
                      hintText: "Email".tr(),

                      keyboardType: TextInputType.emailAddress,
                      textEditingController: model.emailTEC,
                      validator: FormValidator.validateEmail,
                    ).glassMorphic().py12(),
                    CustomTextFormField(
                      hintText: "Password".tr(),
                      obscureText: true,
                      textEditingController: model.passwordTEC,
                      validator: FormValidator.validatePassword,
                    ).glassMorphic().py12(),

                    //
                    "Forgot Password ?".tr().text.underline.white.make().onInkTap(
                          model.openForgotPassword,
                        ),
                    //
                    CustomButton(
                      title: "Login".tr(),
                      loading: model.isBusy,
                      shapeRadius: 12,
                      onPressed: model.processLogin,
                    ).centered().py12(),

                    3.heightBox,
                    Text("or".tr(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),).centered(),
                    15.heightBox,
                    ScanLoginView(model),

                    //registration link
                    Visibility(
                      visible: AppStrings.partnersCanRegister,
                      child: CustomOutlineButton(
                        shapeRadius: 12,
                        title: "Become a partner".tr(),
                        onPressed: model.openRegistrationlink,
                        
                      ).wFull(context).centered(),
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
              ).py20(),
            ])
                .wFull(context)
                .p20()
                .scrollVertical()
          ),
        );
      },
    );
  }
}
