import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:huops/utils/permission_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:huops/models/user.dart';
import 'package:huops/requests/auth.request.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfileViewModel extends MyBaseViewModel {
  User? currentUser;
  File? newPhoto;
  //the textediting controllers
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController phoneTEC = new TextEditingController();

  //
  AuthRequest _authRequest = AuthRequest();
  final picker = ImagePicker();

  EditProfileViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    currentUser = await AuthServices.getCurrentUser();
    nameTEC.text = currentUser!.name;
    emailTEC.text = currentUser!.email;
    phoneTEC.text = currentUser!.phone;
    notifyListeners();
  }

  //
  void changePhoto() async {
    //check for permission first
    final permission = await PermissionUtils.handleImagePermissionRequest(
      viewContext,
    );
    if (!permission) {
      return;
    }
    //End of permission check

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      newPhoto = File(pickedFile.path);
    } else {
      newPhoto = null;
    }

    notifyListeners();
  }

  //
  processUpdate({required onSuccess(bool completed)}) async {
    //
    if (formKey.currentState?.validate() ?? false) {
      //
      setBusy(true);

      //
      final apiResponse = await _authRequest.updateProfile(
        photo: newPhoto,
        name: nameTEC.text,
        email: emailTEC.text,
        phone: phoneTEC.text,
      );

      //
      setBusy(false);

      //update local data if all good
      if (apiResponse.allGood) {
        //everything works well
        await AuthServices.saveUser(apiResponse.body["user"]);
      }

      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Profile Update".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                onSuccess(true);
                //
                //viewContext.pop();
                //viewContext.pop(true);
              }
            : () {
                onSuccess(false);
              },
      );
    }
  }
}
