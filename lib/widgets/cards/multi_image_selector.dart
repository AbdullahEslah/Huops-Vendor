import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart'
    hide CustomButton;
import 'package:huops/services/toast.service.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_grid_view.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

class MultiImageSelectorView extends StatefulWidget {
  const MultiImageSelectorView({
    this.links,
    required this.onImagesSelected,
    this.crossAxisCount = 2,
    this.itemHeight,
    Key? key,
  }) : super(key: key);

  final List<String>? links;
  final Function(List<File>) onImagesSelected;
  final int crossAxisCount;
  final double? itemHeight;

  @override
  _MultiImageSelectorViewState createState() => _MultiImageSelectorViewState();
}

class _MultiImageSelectorViewState extends State<MultiImageSelectorView> {
  //
  List<File>? selectedFiles = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        if (showImageUrl() && !showSelectedImage())
          CustomGridView(
            noScrollPhysics: true,
            dataSet: widget.links!,
            crossAxisCount: widget.crossAxisCount,
            itemBuilder: (ctx, index) {
              return CustomImage(
                imageUrl: widget.links![index],
              )
                  .h(widget.itemHeight ?? context.mq.size.height * 0.2)
                  // .h20(context)
                  .wFull(context);
            },
          ),

        //
        if (showSelectedImage())
          CustomGridView(
            noScrollPhysics: true,
            dataSet: selectedFiles ?? [],
            crossAxisCount: widget.crossAxisCount,
            itemBuilder: (ctx, index) {
              return Image.file(
                selectedFiles![index],
                fit: BoxFit.cover,
              )
                  .h(widget.itemHeight ?? context.mq.size.height * 0.2)
                  // .h20(context)
                  .wFull(context);
            },
          ),

        //
        Visibility(
          // visible: !showImageUrl() && !showSelectedImage(),
          visible: true,
          child: CustomButton(
            title: "Select photo(s)".tr(),
            onPressed: pickNewPhoto,
          ).centered(),
        ),
      ],
    )
        .wFull(context)
        .box
        .clip(Clip.antiAlias)
        .border(color: context.accentColor)
        .roundedSM
        .outerShadow
        .make()
        .onTap(pickNewPhoto);
  }

  bool showImageUrl() {
    return widget.links != null && widget.links!.isNotEmpty;
  }

  bool showSelectedImage() {
    return selectedFiles != null && selectedFiles!.isNotEmpty;
  }

  Future<bool> checkPhotosPermission() async {
    bool statusValue = false;
    PermissionStatus status = await Permission.photos.status;
    if (status.isGranted) {
      statusValue = true;
    } else {
      PermissionStatus currentStatus = await Permission.photos.request();
      statusValue = true;
      if (currentStatus.isGranted) {
        statusValue = true;
      } else if (currentStatus.isDenied) {
        await FlutterPlatformAlert.showAlert(
          windowTitle: 'App Need Access To Photos!',
          text:
              'App Need Access To Photos in Order To Be Able To Upload Product Images To Your Service',
          alertStyle: AlertButtonStyle.ok,
          iconStyle: IconStyle.information,
        );
        statusValue = false;
      } else {
        //Open app settings to manually enabling the permissions
        await openAppSettings();
        statusValue = false;
      }
    }
    return statusValue;
  }

  //
  pickNewPhoto() {
    //check for permission first
    // final permission =
    //     await PermissionUtils.handleImagePermissionRequest(context);
    // if (!permission) {
    //   return;
    // }
    checkPhotosPermission().then((permission) async {
      if (permission == true) {
        try {
          final pickedFiles = await picker.pickMultiImage();
          selectedFiles = [];

          for (var selectedFile in pickedFiles) {
            selectedFiles!.add(File(selectedFile.path));
          }
          //
          widget.onImagesSelected(selectedFiles ?? []);
          setState(() {
            selectedFiles = selectedFiles;
          });
        } catch (error) {
          ToastService.toastError("No Image/Photo selected".tr());
        }
      }
    });
  }
}
