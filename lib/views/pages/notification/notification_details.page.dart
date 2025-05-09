import 'package:flutter/material.dart';
import 'package:huops/models/notification.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    required this.notification,
    Key? key,
  }) : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      title: "Notification Details",
      showAppBar: true,
      showLeadingAction: true,
      body: SafeArea(
        child: VStack(
          [
            //title
            "${notification.title}".text.white.bold.xl2.make(),
            //time
            notification.formattedTimeStamp.text.white.medium
                .color(Colors.grey)
                .make()
                .pOnly(bottom: 10),
            //image
            if (notification.image != null && notification.image!.isNotBlank)
              CustomImage(
                imageUrl: notification.image!,
                width: double.infinity,
                height: context.percentHeight * 30,
              ).py12(),

            //body
            "${notification.body}".text.white.lg.make(),
          ],
        ).p20().scrollVertical(),
      ),
    );
  }
}
