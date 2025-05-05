import 'package:flutter/material.dart';
import 'package:huops/services/validator.service.dart';
import 'package:huops/view_models/change_password.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
      viewModelBuilder: () => ChangePasswordViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePageWithoutNavBar(
          showLeadingAction: true,
          showAppBar: true,
          title: "Change Password".tr(),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //form
                  Form(
                    key: model.formKey,
                    child: VStack(
                      [
                        //
                        Text(
                          "Current Password".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        CustomTextFormField(
                          obscureText: true,
                          textEditingController: model.currentPasswordTEC,
                          validator: FormValidator.validatePassword,
                        ).glassMorphic().py2(),
                        //
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "New Password".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        CustomTextFormField(
                          obscureText: true,
                          textEditingController: model.newPasswordTEC,
                          validator: FormValidator.validatePassword,
                        ).glassMorphic().py2(),
                        //
                        SizedBox(
                          height: 15,
                        ),

                        Text(
                          "Confirm New Password".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        CustomTextFormField(
                          obscureText: true,
                          textEditingController: model.confirmNewPasswordTEC,
                          validator: FormValidator.validatePassword,
                        ).glassMorphic().py2(),

                        //
                        SizedBox(
                          height: 15,
                        ),

                        CustomButton(
                          title: "Save Changes".tr(),
                          loading: model.isBusy,
                          shapeRadius: 12,
                          onPressed: () {
                            model.processUpdate(
                              completed: (success) {
                                if (success == true) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          },
                        ).centered().py16()
                      ],
                    ),
                  ),
                ],
              ).py20().px24().scrollVertical()),
        );
      },
    );
  }
}
