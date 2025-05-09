import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/views/pages/shared/full_image_preview.page.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomImage extends StatefulWidget {
  CustomImage({
    required this.imageUrl,
    this.height = Vx.dp40,
    this.width,
    this.boxFit,
    this.canZoom = false,
    Key? key,
  }) : super(key: key);

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final bool canZoom;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CachedNetworkImage(
      imageUrl: this.widget.imageUrl,
      fit: this.widget.boxFit ?? BoxFit.cover,
      errorWidget: (context, imageUrl, _) => Image.asset(
        AppImages.noImage,
        fit: this.widget.boxFit ?? BoxFit.cover,
      ),
      progressIndicatorBuilder: (context, imageURL, progress) {
        return Image.asset(AppImages.placeholder);
      },
      height: this.widget.height,
      width: this.widget.width ?? context.percentWidth,
    ).onInkTap(this.widget.canZoom
        ? () {
            //if zooming is allowed
            if (this.widget.canZoom) {
              context.push(
                (context) => FullImagePreviewPage(
                  this.widget.imageUrl,
                  boxFit: this.widget.boxFit ?? BoxFit.cover,
                ),
              );
            }
          }
        : null);
  }

  @override
  bool get wantKeepAlive => true;
}
