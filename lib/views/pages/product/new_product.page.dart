import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/services/custom_form_builder_validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/new_products.vm.dart';
import 'package:huops/views/pages/product/widgets/product_variation.section.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/multi_image_selector.dart';
import 'package:huops/widgets/html_text_view.dart';
import 'package:huops/widgets/states/loading_indicator.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewProductPage extends StatelessWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    );

    //
    return ViewModelBuilder<NewProductViewModel>.reactive(
      viewModelBuilder: () => NewProductViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "New Product".tr(),
          body: SafeArea(
            top: true,
            bottom: false,
            child: FormBuilder(
              key: vm.formBuilderKey,
              child: VStack(
                [
                  //name
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                      labelText: 'Name'.tr(),
                      border: inputBorder,
                    ),
                    onChanged: (value) {},
                    validator: CustomFormBuilderValidator.required,
                  ).py12(),

                  //image
                  MultiImageSelectorView(
                    onImagesSelected: vm.onImagesSelected,
                    crossAxisCount: 4,
                  ).py12(),

                  VStack(
                    [
                      //hstack with Description text expanded and edit button
                      HStack(
                        [
                          "Description".tr().text.make().expand(),
                          CustomButton(
                            title: vm.productDescription == null
                                ? "Add".tr()
                                : "Edit".tr(),
                            onPressed: vm.handleDescriptionEdit,
                            icon: vm.productDescription == null
                                ? FlutterIcons.add_mdi
                                : FlutterIcons.edit_mdi,
                          ).h(30),
                        ],
                      ),

                      //preview description
                      HtmlTextView(vm.productDescription ?? "", padding: 0),
                      12.heightBox,
                    ],
                    // spacing: 12,
                  ).p(10).box.border().roundedSM.make().py12(),

                  //pricing
                  HStack(
                    [
                      //price
                      FormBuilderTextField(
                        name: 'price',
                        decoration: InputDecoration(
                          labelText: 'Price'.tr(),
                          border: inputBorder,
                        ),
                        onChanged: (value) {},
                        validator: (value) =>
                            CustomFormBuilderValidator.compose([
                          CustomFormBuilderValidator.required(value),
                          CustomFormBuilderValidator.numeric(value),
                        ]),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //Discount price
                      FormBuilderTextField(
                        name: 'discount_price',
                        decoration: InputDecoration(
                          labelText: 'Discount Price'.tr(),
                          border: inputBorder,
                        ),
                        onChanged: (value) {},
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ).expand(),
                    ],
                  ).py12(),
                  //

                  //packaging
                  HStack(
                    [
                      //Capacity
                      FormBuilderTextField(
                        name: 'capacity',
                        decoration: InputDecoration(
                          labelText: 'Capacity'.tr(),
                          border: inputBorder,
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //unit
                      FormBuilderTextField(
                        name: 'unit',
                        decoration: InputDecoration(
                          labelText: 'Unit'.tr(),
                          border: inputBorder,
                        ),
                        onChanged: (value) {},
                      ).expand(),
                    ],
                  ).py12(),
                  //

                  //pricing
                  HStack(
                    [
                      //package_count
                      FormBuilderTextField(
                        name: 'package_count',
                        decoration: InputDecoration(
                          labelText: 'Package Count'.tr(),
                          border: inputBorder,
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //available_qty
                      FormBuilderTextField(
                        name: 'available_qty',
                        decoration: InputDecoration(
                          labelText: 'Available Qty'.tr(),
                          border: inputBorder,
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ).expand(),
                    ],
                  ).py12(),
                  //

                  HStack(
                    [
                      //deliverable
                      FormBuilderCheckbox(
                        initialValue: false,
                        name: 'deliverable',
                        onChanged: (value) {},
                        valueTransformer: (value) => (value ?? false) ? 1 : 0,
                        title: "Can be delivered".tr().text.make(),
                      ).expand(),
                      20.widthBox,
                      //Active
                      FormBuilderCheckbox(
                        initialValue: false,
                        name: 'is_active',
                        onChanged: (value) {},
                        valueTransformer: (value) => (value ?? false) ? 1 : 0,
                        title: "Active".tr().text.make(),
                      ).expand(),
                    ],
                  ),
                  //
//
                  //tags
                  LoadingIndicator(
                    loading: vm.busy(vm.tags),
                    child: FormBuilderFilterChip<String>(
                      name: 'tag_ids',
                      decoration: InputDecoration(
                        labelText: 'Tag'.tr(),
                        border: inputBorder,
                      ),
                      spacing: 5,
                      checkmarkColor: AppColor.primaryColor,
                      options: vm.tags
                          .map(
                            (tag) => FormBuilderChipOption<String>(
                              value: '${tag.id}',
                              child: '${tag.name}'.text.make(),
                            ),
                          )
                          .toList(),
                    ),
                  ).py12(),
                  //categories
                  LoadingIndicator(
                    loading: vm.busy(vm.categories),
                    child: FormBuilderFilterChip<String>(
                      name: 'category_ids',
                      decoration: InputDecoration(
                        labelText: 'Category'.tr(),
                        border: inputBorder,
                      ),
                      spacing: 5,
                      selectedColor: AppColor.primaryColor,
                      options: vm.categories
                          .map(
                            (category) => FormBuilderChipOption<String>(
                              value: '${category.id}',
                              child: '${category.name}'.text.make(),
                            ),
                          )
                          .toList(),
                      onChanged: vm.filterSubcategories,
                    ),
                  ).py12(),

                  //subcategories
                  LoadingIndicator(
                    loading: vm.busy(vm.subCategories),
                    child: FormBuilderFilterChip<String>(
                      name: 'sub_category_ids',
                      decoration: InputDecoration(
                        labelText: 'Sub-Category'.tr(),
                        border: inputBorder,
                      ),
                      spacing: 5,
                      checkmarkColor: AppColor.primaryColor,
                      options: vm.subCategories
                          .map(
                            (category) => FormBuilderChipOption<String>(
                              value: '${category.id}',
                              child: '${category.name}'.text.make(),
                            ),
                          )
                          .toList(),
                    ),
                  ).py12(),
                  //menus
                  LoadingIndicator(
                    loading: vm.busy(vm.menus),
                    child: FormBuilderFilterChip<String>(
                      name: 'menu_ids',
                      decoration: InputDecoration(
                        labelText: 'Menus'.tr(),
                        border: inputBorder,
                      ),
                      spacing: 5,
                      selectedColor: AppColor.primaryColor,
                      options: vm.menus
                          .map(
                            (menu) => FormBuilderChipOption<String>(
                              value: '${menu.id}',
                              child: '${menu.name}'.text.make(),
                            ),
                          )
                          .toList(),
                    ),
                  ).py12(),

                  //options
                  ProductVariationSection(
                    optionGroups: vm.productOptionGroups,
                    vm: vm,
                    onAddOptionGroup: vm.onAddOptionGroup,
                    onAddOption: vm.onAddOption,
                  ).py12(),
                  //
                  CustomButton(
                      title: "Save Product".tr(),
                      loading: vm.isBusy,
                      onPressed: () {
                        vm.processNewProduct(
                          onSuccess: (value) {
                            if (value == true) {
                              Navigator.pop(context);
                            }
                          },
                        );
                      }).py12().centered(),
                  30.heightBox,
                ],

                // spacing: 30,
              ),
            )
                .p20()
                .scrollVertical()
                .pOnly(bottom: context.mq.viewInsets.bottom),
          ),
        );
      },
    );
  }
}
