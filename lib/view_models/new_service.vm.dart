import 'dart:collection';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/models/event_ticket_model/event_ticket.dart';
import 'package:huops/models/product_category.dart';
import 'package:huops/requests/product.request.dart';
import 'package:huops/requests/service.request.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:huops/views/pages/shared/text_editor.page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewServiceViewModel extends MyBaseViewModel {
  //
  NewServiceViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  ServiceRequest serviceRequest = ServiceRequest();
  ProductRequest productRequest = ProductRequest();
  VendorRequest vendorRequest = VendorRequest();
  String? description;
  //
  int? selectedCategoryId;
  int? selectedSubCategoryId;
  String? selectedServiceDuration;
  //
  List<ProductCategory> categories = [];
  List<ProductCategory> subcategories = [];
  List<String> serviceDurations = [];
  List<File>? selectedPhotos = [];

  /// for adding and listing times
  TimeOfDay? _selectedTime;
  TimeOfDay? get selectedTime => _selectedTime;

  List<TimeOfDay> _selectedTimes = [];
  UnmodifiableListView<TimeOfDay> get selectedTimes {
    return UnmodifiableListView(_selectedTimes);
  }

  /// Event ticketsTypes
  List<EventTicket> _eventTickets = [];
  UnmodifiableListView<EventTicket> get eventTickets {
    return UnmodifiableListView(_eventTickets);
  }

  TextEditingController ticketTypeController = TextEditingController();
  TextEditingController ticketPriceController = TextEditingController();

  ///
  @override
  void dispose() {
    ticketPriceController.dispose();
    ticketTypeController.dispose();
    super.dispose();
  }

  void initialise() async {
    //print((await AuthServices.getCurrentVendor(force: true)).id);
    fetchVendorTypeCategories();
    fetchServiceDurations();
  }

  void showAddTicketDialog(
      {required BuildContext context, EventTicket? product, int? index}) {
    bool isEditing = product != null;

    if (isEditing) {
      ticketTypeController.text = product.name;
      ticketPriceController.text = product.price.toString();
    }

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text(isEditing ? 'ِEdit Ticket' : 'Add New Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ticketTypeController,
                decoration: InputDecoration(
                  labelText: 'Ticket Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ticketPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'price',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Save Changes' : 'Add'),
              onPressed: () {
                if (ticketTypeController.text.isEmpty ||
                    ticketPriceController.text.isEmpty) {
                  return;
                }

                double? price = double.tryParse(ticketPriceController.text);
                if (price == null) return;

                EventTicket newTicket = EventTicket(
                  name: ticketTypeController.text,
                  price: price,
                );

                if (isEditing && index != null) {
                  _eventTickets[index] = newTicket;
                  notifyListeners();
                } else {
                  _eventTickets.add(newTicket);
                  notifyListeners();
                }
                ticketTypeController.clear();
                ticketPriceController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeTicketType(int ticketTypeIndex) {
    _eventTickets.removeAt(ticketTypeIndex);
    notifyListeners();
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      _selectedTime = picked;
      _selectedTimes.add(picked);
      notifyListeners();
    }
  }

  void editTime(int index, BuildContext context) async {
    final TimeOfDay? editedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[index],
    );

    if (editedTime != null) {
      _selectedTimes[index] = editedTime;
      notifyListeners();
    }
  }

  void removeTime(int currentTimeIndex) {
    _selectedTimes.removeAt(currentTimeIndex);
    notifyListeners();
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  //
  fetchVendorTypeCategories() async {
    setBusyForObject(categories, true);

    try {
      categories = await productRequest.getProductCategories(
        vendorTypeId:
            (await AuthServices.getCurrentVendor(force: true)).vendorType?.id,
      );

      clearErrors();
    } catch (error) {
      print("Categories Error ==> $error");
      setError(error);
    }

    setBusyForObject(categories, false);
  }

  fetchSubCategories(int? categoryId) async {
    selectedCategoryId = categoryId;
    setBusyForObject(subcategories, true);

    try {
      subcategories = await productRequest.fetchSubCategories(
        categoryId: categoryId,
      );
      clearErrors();
    } catch (error) {
      print("Categories Error ==> $error");
      setError(error);
    }

    setBusyForObject(subcategories, false);
  }

  fetchServiceDurations() async {
    setBusyForObject(serviceDurations, true);

    try {
      serviceDurations = await serviceRequest.getServiceDurations();
      clearErrors();
    } catch (error) {
      print("serviceDurations Error ==> $error");
      setError(error);
    }

    setBusyForObject(serviceDurations, false);
  }

  //
  onImagesSelected(List<File> files) {
    selectedPhotos = files;
    notifyListeners();
  }

  //
  processNewService() async {
    if (formBuilderKey.currentState!.saveAndValidate() &&
        validateSelectedPhotos()) {
      //
      setBusy(true);

      try {
        final apiResponse = await serviceRequest.newService(
            data: {
              ...formBuilderKey.currentState!.value,
              "description": description,
            },
            photos: selectedPhotos,
            selectedTimes: _selectedTimes,
            eventsTickets: _eventTickets);

        //show dialog to present state
        CoolAlert.show(
            context: viewContext,
            type: apiResponse.allGood
                ? CoolAlertType.success
                : CoolAlertType.error,
            title: "New Service".tr(),
            text: apiResponse.message,
            onConfirmBtnTap: () {
              viewContext.pop();
              if (apiResponse.allGood) {
                viewContext.pop(true);
              }
            });
        clearErrors();
      } catch (error) {
        print("new service Error ==> $error");
        setError(error);
      }

      setBusy(false);
    }
  }

  bool validateSelectedPhotos() {
    if (selectedPhotos == null || selectedPhotos!.isEmpty) {
      // CoolAlert.show(
      //   context: viewContext,
      //   type: CoolAlertType.warning,
      //   title: "Update Service".tr(),
      //   text: "Please select at least one photo for service".tr(),
      // );
      Toast.show(
          "Please select at least one photo for service".tr(), viewContext);

      return false;
    }
    return true;
  }

  handleDescriptionEdit() async {
    //get the description
    final result = await viewContext.push(
      (context) => CustomTextEditorPage(
        title: "Service Description".tr(),
        content: description ?? "",
      ),
    );
    //
    if (result != null) {
      description = result;
      notifyListeners();
    }
  }
}
