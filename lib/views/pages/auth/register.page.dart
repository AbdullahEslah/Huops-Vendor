import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_page_settings.dart';
import 'package:huops/models/address.dart';
import 'package:huops/services/custom_form_builder_validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/view_models/register.view_model.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/document_selection.view.dart';
import 'package:huops/widgets/states/custom_loading.state.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    //
    final inputDec = InputDecoration(
      border: OutlineInputBorder(),
    );

    //
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePageWithoutNavBar(
          // isLoading: vm.isBusy,
          resizeToAvoidBottomInset: true,
          body: FormBuilder(
            key: vm.formBuilderKey,
            child: VStack(
              [
                //appbar
                SafeArea(
                  child: HStack(
                    [
                      Icon(FlutterIcons.close_ant,
                              size: 24, color: Colors.white)
                          .p8()
                          .onInkTap(() {
                        context.pop();
                      }).p12(),
                    ],
                  ),
                ).box.color(AppColor.primaryColor).make().wFull(context),

                //
                VStack(
                  [
                    HStack([
                      FittedBox(
                          child: VStack(
                        [
                          "Become a partner"
                              .tr()
                              .text
                              .xl3
                              .color(Utils.textColorByTheme())
                              .bold
                              .make(),
                          "Fill form below to continue"
                              .tr()
                              .text
                              .light
                              .color(Utils.textColorByTheme())
                              .make(),
                        ],
                      ).p20().box.make()),
                      UiSpacer.hSpace(),
                      CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: Image.asset(
                                AppImages.appLogo,
                              ).wh(60, 60))
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                          .p12(),
                    ]).color(AppColor.primaryColor).wFull(context),

                    //form
                    Column(
                      children: [
                        Card(
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(children: [
                                "Business Information"
                                    .tr()
                                    .text
                                    .xl2
                                    .semiBold
                                    .make(),
                                UiSpacer.vSpace(10),
                                //
                                FormBuilderTextField(
                                  name: "vendor_name",
                                  validator:
                                      CustomFormBuilderValidator.required,
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Name".tr(),
                                  ),
                                ),

                                //
                                15.heightBox,
                                //address
                                TypeAheadFormField<Address>(
                                  hideOnLoading: false,
                                  hideOnEmpty: true,
                                  hideSuggestionsOnKeyboardHide: false,
                                  minCharsForSuggestions: 3,
                                  debounceDuration: const Duration(seconds: 1),
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    controller: vm.addressTEC,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: "Address".tr(),
                                      labelText: "Address".tr(),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: vm.searchAddress,
                                  itemBuilder: (context, Address? suggestion) {
                                    if (suggestion == null) {
                                      return Divider();
                                    }
                                    //
                                    return ListTile(
                                      title: "${suggestion.addressLine ?? ''}"
                                          .text
                                          .semiBold
                                          .lg
                                          .make()
                                          .px(12),
                                    );
                                  },
                                  onSuggestionSelected: vm.onAddressSelected,
                                ),
                                //
                                CustomLoadingStateView(
                                  loading: vm.busy(vm.vendorTypes),
                                  child: FormBuilderDropdown(
                                    borderRadius: BorderRadius.circular(8),
                                    name: 'vendor_type_id',
                                    decoration: inputDec.copyWith(
                                      labelText: "Vendor Type".tr(),
                                      hintText: 'Select Vendor Type'.tr(),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    initialValue: vm.selectedVendorTypeId,
                                    onChanged: vm.changeSelectedVendorType,
                                    validator:
                                        CustomFormBuilderValidator.required,
                                    items: vm.vendorTypes
                                        .map(
                                          (vendorType) => DropdownMenuItem(
                                            value: vendorType.id,
                                            child: '${vendorType.name}'
                                                .text
                                                .make(),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ).py(15),

                                FormBuilderTextField(
                                  name: "vendor_email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) =>
                                      CustomFormBuilderValidator.compose(
                                    [
                                      CustomFormBuilderValidator.required(
                                          value),
                                      CustomFormBuilderValidator.email(value),
                                    ],
                                  ),
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Email".tr(),
                                  ),
                                ),

                                FormBuilderTextField(
                                  name: "vendor_phone",
                                  keyboardType: TextInputType.phone,
                                  validator:
                                      CustomFormBuilderValidator.required,
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Phone".tr(),
                                    prefixIcon: HStack(
                                      [
                                        //icon/flag
                                        Flag.fromString(
                                          vm.selectedVendorCountry
                                                  ?.countryCode ??
                                              "us",
                                          width: 20,
                                          height: 20,
                                        ),
                                        UiSpacer.horizontalSpace(space: 5),
                                        //text
                                        ("+" +
                                                (vm.selectedVendorCountry
                                                        ?.phoneCode ??
                                                    "1"))
                                            .text
                                            .make(),
                                      ],
                                    ).px8().onInkTap(
                                        () => vm.showCountryDialPicker(true)),
                                  ),
                                ).py(15),

                                //business documents
                                DocumentSelectionView(
                                  title: "Documents".tr(),
                                  instruction: AppPageSettings
                                      .vendorDocumentInstructions,
                                  max: AppPageSettings.maxVendorDocumentCount,
                                  onSelected: vm.onDocumentsSelected,
                                ),
                              ]),
                            )),
                        UiSpacer.verticalSpace(space: 15),

                        Card(
                          surfaceTintColor: Colors.white,
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(children: [
                                "Personal Information"
                                    .tr()
                                    .text
                                    .xl2
                                    .semiBold
                                    .make(),
                                UiSpacer.vSpace(10),
                                FormBuilderTextField(
                                  name: "name",
                                  validator:
                                      CustomFormBuilderValidator.required,
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Name".tr(),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: "email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: CustomFormBuilderValidator.email,
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Email".tr(),
                                  ),
                                ).py(15),
                                FormBuilderTextField(
                                  name: "phone",
                                  keyboardType: TextInputType.phone,
                                  // validator: CustomFormBuilderValidator.required,
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Phone (Optional)".tr(),
                                    prefixIcon: HStack(
                                      [
                                        //icon/flag
                                        Flag.fromString(
                                          vm.selectedCountry?.countryCode ??
                                              "us",
                                          width: 20,
                                          height: 20,
                                        ),
                                        UiSpacer.horizontalSpace(space: 5),
                                        //text
                                        ("+" +
                                                (vm.selectedCountry
                                                        ?.phoneCode ??
                                                    "1"))
                                            .text
                                            .make(),
                                      ],
                                    ).px8().onInkTap(vm.showCountryDialPicker),
                                  ),
                                ),
                                FormBuilderTextField(
                                  name: "password",
                                  obscureText: vm.hidePassword,
                                  validator:
                                      CustomFormBuilderValidator.required,
                                  decoration: inputDec.copyWith(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    labelText: "Password".tr(),
                                    suffixIcon: Icon(
                                      vm.hidePassword
                                          ? FlutterIcons.ios_eye_ion
                                          : FlutterIcons.ios_eye_off_ion,
                                    ).onInkTap(() {
                                      vm.hidePassword = !vm.hidePassword;
                                      vm.notifyListeners();
                                    }),
                                  ),
                                ).pOnly(top: 15, bottom: 5),
                              ])),
                        ),
                        FormBuilderCheckbox(
                          name: "agreed",
                          title: "I agree with"
                              .tr()
                              .richText
                              .semiBold
                              .withTextSpanChildren(
                            [
                              " ".textSpan.make(),
                              "terms and conditions"
                                  .tr()
                                  .textSpan
                                  .underline
                                  .semiBold
                                  .tap(() {
                                    vm.openWebpageLink(Api.terms);
                                  })
                                  .color(AppColor.primaryColor)
                                  .make(),
                            ],
                          ).make(),
                          validator: (value) =>
                              CustomFormBuilderValidator.required(
                            value,
                            errorTitle:
                                "Please confirm you have accepted our terms and conditions"
                                    .tr(),
                          ),
                        ),
                        //
                        CustomButton(
                          title: "Sign Up".tr(),
                          loading: vm.isBusy,
                          onPressed: vm.processLogin,
                        ).cornerRadius(12).wFull(context),
                      ],
                    )
                        .px12()
                        .py20()
                        .color(Colors.grey.shade100)
                        .scrollVertical()
                        .box
                        .roundedSM
                        .make(),
                  ],
                )
                    .wFull(context)
                    .scrollVertical()
                    .box
                    .color(context.cardColor)
                    .make()
                    .expand(),
              ],
            ),
          ),
        );
      },
    );
  }
}
