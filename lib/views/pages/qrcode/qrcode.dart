import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/view_models/QrCodeViewModel.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QRCodeViewModel>.reactive(
      viewModelBuilder: () => QRCodeViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "QR Code".tr(),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:RepaintBoundary(
                      key: model.qrKey,
                      child: QrImageView(
                        data: model.vendorId,
                        version: QrVersions.auto,
                        size: 200.0,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        embeddedImage: AssetImage("assets/images/app_icon-rounded.png"), // Use the pre-processed image
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(50, 50),
                        ),
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.circle,
                          color: AppColor.primaryColor
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color:Colors.black,
                        ),
                      ),
                    ),


                  ),
                  SizedBox(height: 15,),
                  Text("This QR code helps customers\n to view your menu".tr(),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                    ),
                    onPressed: model.captureAndSavePng,
                    child: Text("Save QR Code".tr(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ).w40(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
