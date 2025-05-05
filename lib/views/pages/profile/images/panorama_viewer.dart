import 'dart:io';

import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

import '../../../../models/images_model/vendor_images.dart';

class Panorama360 extends StatelessWidget {
  const Panorama360({super.key,required this.panorama});
  final String panorama;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PanoramaViewer(
          child: Image.network("${panorama}"),
        ),
      ),
    );
  }
}
class Panorama360File extends StatelessWidget {
  const Panorama360File({super.key,required this.panorama});
  final File panorama;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PanoramaViewer(
          child: Image.file(panorama),
        ),
      ),
    );
  }
}
