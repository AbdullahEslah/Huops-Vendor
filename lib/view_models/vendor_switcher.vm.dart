import 'package:huops/models/user.dart';
import 'package:huops/models/vendor.dart';
import 'package:huops/requests/vendor.request.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';

class VendorSwitcherBottomSheetViewModel extends MyBaseViewModel {
  List<Vendor> vendors = [];

  fetchMyVendors() async {
    setBusyForObject(vendors, true);

    try {
      vendors = await VendorRequest().myVendors();
    } catch (error) {
      print("VendorSwitcherBottomSheetViewModel.fetchMyVendors: $error");
      toastError("$error");
    }
    setBusyForObject(vendors, false);
  }

  switchVendor(Vendor vendor) async {
    setBusy(true);
    setBusyForObject(vendor.id, true);
    try {
      await VendorRequest().switchVendor(vendor);
      //set the new vendor
      User currentUser = await AuthServices.getCurrentUser(force: true);
      currentUser.vendor_id = vendor.id;
      await AuthServices.saveUser(currentUser.toJson());
      await AuthServices.saveVendor(vendor.toJson());
      await AuthServices.subscribeToFirebaseTopic(
        "v_${vendor.id}",
        clear: true,
      );
      await AuthServices.subscribeToFirebaseTopic(
        "${AuthServices.currentUser?.role}",
      );

      //reload app
      await AppService().reloadApp();
    } catch (error) {
      print("VendorSwitcherBottomSheetViewModel.switchVendor: $error");
      toastError("$error");
    }
    setBusy(false);
    setBusyForObject(vendor.id, false);
  }
}
