import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/view_models/base.view_model.dart';

import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QRCodeViewModel extends MyBaseViewModel {
  QRCodeViewModel(BuildContext context) {
    this.viewContext = context;
  }
  String vendorId="";
  final GlobalKey qrKey = GlobalKey();
  bool dirExists = false;
  dynamic externalDir = '/storage/emulated/0/Download';


  @override
  void initialise() async {
    super.initialise();

    vendorId = (await AuthServices.getCurrentUser()).vendor_id.toString();
    vendorId==""?null:notifyListeners();
  }

  // Future<void> captureAndSavePng() async {
  //   try{
  //     RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     var image = await boundary.toImage(pixelRatio: 3.0);
  //
  //     final whitePaint = Paint()..color = Colors.white;
  //     final recorder = PictureRecorder();
  //     final canvas = Canvas(recorder,Rect.fromLTWH(0,0,image.width.toDouble(),image.height.toDouble()));
  //     canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), whitePaint);
  //     canvas.drawImage(image, Offset.zero, Paint());
  //     final picture = recorder.endRecording();
  //     final img = await picture.toImage(image.width, image.height);
  //     ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //
  //     //Check for duplicate file name to avoid Override
  //     String fileName = 'qr_code_${DateTime.now().millisecondsSinceEpoch}';
  //     // int i = 1;
  //     // while(await File('$externalDir/$fileName.png').exists()){
  //     //   fileName = 'qr_code_$i';
  //     //   i++;
  //     // }
  //
  //     // Check if Directory Path exists or not
  //     // dirExists = await File(externalDir).exists();
  //     // //if not then create the path
  //     // if(!dirExists){
  //     //   await Directory(externalDir).create(recursive: true);
  //     //   dirExists = true;
  //     // }
  //
  //     final file = await File('$externalDir/$fileName.png').create();
  //     await file.writeAsBytes(pngBytes);
  //
  //     Toast.show("QR Code Saved in Downloads Folder", viewContext, duration: Toast.lengthLong, gravity:  Toast.bottom);
  //     notifyListeners();
  //
  //   }catch(e){
  //     Toast.show(e.toString(), viewContext, duration: Toast.lengthLong, gravity:  Toast.bottom);
  //     notifyListeners();
  //   }
  // }


  Future<void> captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary =
      qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
          final img = await picture.toImage(image.width, image.height);
          ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check for duplicate file name to avoid Override
      String fileName = 'qr_code_${DateTime.now().millisecondsSinceEpoch}';
      // int i = 1;
      // while(await File('$externalDir/$fileName.png').exists()){
      //   fileName = 'qr_code_$i';
      //   i++;
      // }

      // Check if Directory Path exists or not
      // dirExists = await File(externalDir).exists();
      // //if not then create the path
      // if(!dirExists){
      //   await Directory(externalDir).create(recursive: true);
      //   dirExists = true;
      // }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      // Save image to the gallery
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
      print('Image saved to gallery: $result');

      Toast.show("QR Code Saved in Gallery", viewContext, duration: Toast.lengthLong, gravity:  Toast.bottom);
      notifyListeners();

    } catch (e) {
      Toast.show(e.toString(), viewContext, duration: Toast.lengthLong, gravity:  Toast.bottom);
      notifyListeners();
    }
  }

}