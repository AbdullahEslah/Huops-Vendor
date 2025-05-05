import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Flutter material package

class BluetoothPrinterService {
  static const MethodChannel _channel = MethodChannel('bluetooth_printer');

  // Function to convert text to an image
  Future<Uint8List> textToImage(String text, {double fontSize = 24.0}) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
    );

    // Create a TextSpan with the provided text
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(); // Layout the text
    textPainter.paint(canvas, Offset.zero); // Draw text on canvas

    // Capture the canvas as an image
    final picture = recorder.endRecording();
    final img = await picture.toImage(
        textPainter.width.toInt(), textPainter.height.toInt());
    final byteData = await img.toByteData(format: ImageByteFormat.png);

    return byteData!.buffer.asUint8List(); // Return image as byte array
  }

  // Function to send the text as an image to the printer
  Future<void> printTextAsImage(String text) async {
    Uint8List imageData = await textToImage(text);

    // Send the image data to the printer
    try {
      await _channel.invokeMethod('printImage', {'data': imageData});
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'.");
    }
  }

  Future<void> printReceipt(String data) async {
    try {
      await _channel.invokeMethod('printReceipt', {'data': data});
    } on PlatformException catch (e) {
      print("Failed to print: '${e.message}'.");
    }
  }
}
