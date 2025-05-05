import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/models/event_ticket_model/event_ticket.dart';
import 'package:huops/services/custom_form_builder_validator.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/new_service.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/cards/multiple_image_selector.dart';
import 'package:huops/widgets/html_text_view.dart';
import 'package:huops/widgets/states/loading_indicator.view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewServicePage extends StatelessWidget {
  const NewServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewServiceViewModel>.reactive(
      viewModelBuilder: () => NewServiceViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        return BasePageWithoutNavBar(
          showAppBar: true,
          showLeadingAction: true,
          title: "New Service".tr(),
          body: FormBuilder(
            key: vm.formBuilderKey,
            child: VStack(
              [
                //categories
                LoadingIndicator(
                  loading: vm.busy(vm.categories),
                  child: VStack(
                    [
                      "Category".tr().text.white.make(),
                      FormBuilderDropdown<int>(
                        name: "category_id",
                        items: vm.categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.id,
                                child: Text(
                                  '${category.name}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                            .toList(),
                        validator: CustomFormBuilderValidator.required,
                        initialValue: vm.selectedCategoryId,
                        onChanged: vm.fetchSubCategories,
                      ),
                    ],
                  ),
                ),
                UiSpacer.verticalSpace(),
                //sub categories
                Visibility(
                  visible: (vm.categories.first.vendorType?.id != 17),
                  child: LoadingIndicator(
                    loading: vm.busy(vm.subcategories),
                    child: VStack(
                      [
                        "Sub Category".tr().text.white.make(),
                        FormBuilderDropdown<int>(
                          name: "subcategory_id",
                          decoration: InputDecoration(
                            hintText: "",
                          ),
                          initialValue: vm.selectedSubCategoryId,
                          onChanged: (value) {
                            vm.selectedSubCategoryId = value;
                            vm.notifyListeners();
                          },
                          items: vm.subcategories
                              .map(
                                (subcategory) => DropdownMenuItem(
                                  value: subcategory.id,
                                  child: Text(
                                    '${subcategory.name}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                UiSpacer.verticalSpace(),

                //name
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(
                      labelText: 'Name'.tr(),
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {},
                  validator: CustomFormBuilderValidator.required,
                ),
                Visibility(
                    visible: (vm.categories.first.vendorType?.id == 17),
                    child: FormBuilderTextField(
                      name: 'tickets_available',
                      decoration: InputDecoration(
                          labelText: 'Available Tickets'.tr(),
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {},
                      validator: CustomFormBuilderValidator.required,
                    )),
                UiSpacer.verticalSpace(),
                Visibility(
                  visible: (vm.categories.first.vendorType?.id == 17),
                  child: FormBuilderTextField(
                    name: 'event_type',
                    decoration: InputDecoration(
                        labelText: 'Event Type'.tr(),
                        labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {},
                    validator: CustomFormBuilderValidator.required,
                  ),
                ),

                Visibility(
                  visible: (vm.categories.first.vendorType?.id == 17),
                  child: FormBuilderTextField(
                    name: 'end_reservation',
                    decoration: InputDecoration(
                        labelText: 'End Reservation'.tr(),
                        labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {},
                    validator: CustomFormBuilderValidator.required,
                  ),
                ),

                Visibility(
                  visible: (vm.categories.first.vendorType?.id == 17),
                  child: FormBuilderTextField(
                    name: 'event_location',
                    decoration: InputDecoration(
                        labelText: 'Event Location'.tr(),
                        labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {},
                    validator: CustomFormBuilderValidator.required,
                  ),
                ),
                UiSpacer.verticalSpace(),
                LoadingIndicator(
                  loading: vm.busy(vm.serviceDurations),
                  child: VStack(
                    [
                      "Duration Type".tr().text.white.make(),
                      FormBuilderDropdown<String>(
                        name: "duration",
                        validator: CustomFormBuilderValidator.required,
                        decoration: InputDecoration(
                          hintText: "",
                        ),
                        initialValue: vm.selectedServiceDuration,
                        onChanged: (value) {
                          vm.selectedServiceDuration = value;
                          vm.notifyListeners();
                        },
                        items: vm.serviceDurations
                            .map(
                              (serviceDuration) => DropdownMenuItem(
                                value: '$serviceDuration',
                                child: Text(
                                  '${serviceDuration}'.tr(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                UiSpacer.verticalSpace(),
                Visibility(
                  visible: (vm.categories.first.vendorType?.id == 17),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                            'Service Time'),
                        SizedBox(
                          height: screenHeight * 0.05,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22.0,
                            ),
                            iconAlignment: IconAlignment.start,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () => vm.selectTime(context),
                            label: Text(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                                'Choose Service Time'),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: vm.selectedTimes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final timeItem = vm.selectedTimes[index];
                        return ListTile(
                          title: Text(
                            vm.formatTime(timeItem),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => vm.editTime(index, context),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  vm.removeTime(index);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),
                ),
                Visibility(
                  visible: (vm.categories.first.vendorType?.id == 17),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                              'Ticket Type'),
                          SizedBox(
                            height: screenHeight * 0.05,
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 22.0,
                              ),
                              iconAlignment: IconAlignment.start,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () =>
                                  vm.showAddTicketDialog(context: context),
                              label: Text(
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                  'Add Ticket Type'),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: vm.eventTickets.length,
                        itemBuilder: (context, index) {
                          EventTicket product = vm.eventTickets[index];
                          return ListTile(
                            title: Text(
                              product.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            subtitle: Text(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                                'Price: ${product.price.toStringAsFixed(2)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => vm.showAddTicketDialog(
                                    product: product,
                                    index: index,
                                    context: context,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    vm.removeTicketType(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                VStack(
                  [
                    //hstack with Description text expanded and edit button
                    HStack(
                      [
                        "Description".tr().text.white.make().expand(),
                        CustomButton(
                          title:
                              vm.description == null ? "Add".tr() : "Edit".tr(),
                          onPressed: vm.handleDescriptionEdit,
                          icon: vm.description == null
                              ? FlutterIcons.add_mdi
                              : FlutterIcons.edit_mdi,
                        ).h(30),
                      ],
                    ),
                    UiSpacer.vSpace(10),
                    //preview description
                    HtmlTextView(vm.description ?? "", padding: 0),
                  ],
                ).p(10).box.border().roundedSM.make(),
                UiSpacer.verticalSpace(),
                //image
                MultipleImageSelectorView(
                  onImagesSelected: vm.onImagesSelected,
                ),
                UiSpacer.verticalSpace(),
                //durations

                //pricing
                HStack(
                  [
                    //price
                    FormBuilderTextField(
                      name: 'price',
                      decoration: InputDecoration(
                          labelText: 'Price'.tr(),
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {},
                      validator: (value) => CustomFormBuilderValidator.compose([
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
                      initialValue: "0",
                      decoration: InputDecoration(
                          labelText: 'Discount Price'.tr(),
                          labelStyle: TextStyle(color: Colors.white)),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {},
                      validator: (value) => CustomFormBuilderValidator.compose([
                        CustomFormBuilderValidator.required(value),
                        CustomFormBuilderValidator.numeric(value),
                      ]),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                    ).expand(),
                  ],
                ),

                //checkbox
                HStack(
                  [
                    //Location Required

                    (vm.categories.first.vendorType?.id == 17)
                        ? SizedBox()
                        : FormBuilderCheckbox(
                            initialValue: false,
                            name: 'location',
                            onChanged: (value) {
                              // print("${vm.categories.first.vendorType?.id}");
                            },
                            valueTransformer: (value) =>
                                (value ?? false) ? 1 : 0,
                            title: "Location Required".tr().text.white.make(),
                          ).expand(),
                    UiSpacer.horizontalSpace(),
                    //Active
                    FormBuilderCheckbox(
                      initialValue: true,
                      name: 'is_active',
                      onChanged: (value) {},
                      valueTransformer: (value) => (value ?? false) ? 1 : 0,
                      title: "Active".tr().text.white.make(),
                    ).expand(),
                  ],
                ),
                //

                //
                CustomButton(
                  title: "Save".tr(),
                  icon: FlutterIcons.save_fea,
                  loading: vm.isBusy,
                  onPressed: vm.processNewService,
                ).wFull(context).py12(),
                UiSpacer.verticalSpace(),
                UiSpacer.verticalSpace(),
              ],
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
