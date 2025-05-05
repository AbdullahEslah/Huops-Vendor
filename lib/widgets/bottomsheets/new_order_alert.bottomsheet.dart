import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_images.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/extensions/dynamic.dart';
import 'package:huops/models/order.dart';
import 'package:huops/requests/order.request.dart';
import 'package:huops/views/pages/order/orders_details.page.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/audio_player_singleton.dart';

class NewOrderAlertBottomsheet extends StatefulWidget {
  const NewOrderAlertBottomsheet({
    required this.orderId,
    Key? key,
  }) : super(key: key);
  final int orderId;

  @override
  State<NewOrderAlertBottomsheet> createState() =>
      _NewOrderAlertBottomsheetState();
}

class _NewOrderAlertBottomsheetState extends State<NewOrderAlertBottomsheet> {
  //
  //AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    //play after finish loading
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      playNotificationSound();
    });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    //assetsAudioPlayer.isPlaying.value ? assetsAudioPlayer.stop() : null;
    await AudioPlayerSingleton.instance.dispose();
    super.dispose();
  }

  //
  void playNotificationSound() async {
    try {
      await AudioPlayerSingleton.instance.stop();
    } catch (error) {
      print("Error stopping audio player");
    }

    //
    await AudioPlayerSingleton.instance
        .setSource(AssetSource("audio/new_order_alert.mp3"));
    await AudioPlayerSingleton.instance.setReleaseMode(ReleaseMode.loop);
    // repeat sound
    await AudioPlayerSingleton.instance.setVolume(1.0);
    await AudioPlayerSingleton.instance.resume();
  }

  void stopNotificationSound() {
    try {
      AudioPlayerSingleton.instance.stop();
    } catch (error) {
      print("Error stopping audio player");
    }
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Image.asset(
          AppImages.newOrderAlert,
          width: context.percentWidth * 50,
          // height: context.percentWidth * 50,
        ).centered(),
        //title
        "New Order".tr().text.xl2.semiBold.makeCentered(),
        "A new order has been placed".tr().text.makeCentered(),
        10.heightBox,
        //order details
        FutureBuilder<Order>(
            future: OrderRequest().getOrderDetails(id: widget.orderId),
            builder: (context, snapshot) {
              //
              if (snapshot.connectionState == ConnectionState.waiting) {
                return BusyIndicator().centered();
              } else if (snapshot.hasError) {
                return 0.heightBox;
              }
              //
              Order order = snapshot.data!;
              return VStack(
                [
                  HStack([
                    "Order Code".tr().text.semiBold.make().expand(),
                    "#${order.code}".text.make(),
                  ]).py4(),
                  HStack([
                    "Total".tr().text.semiBold.make().expand(),
                    "${AppStrings.currencySymbol} ${order.total}"
                        .currencyFormat()
                        .text
                        .make(),
                  ]).py4(),
                  HStack([
                    "Payment Method".tr().text.semiBold.make().expand(),
                    "${order.paymentMethod?.name}".text.make(),
                  ]).py4(),
                  if (order.deliveryAddress == null)
                    "Pickup Order".tr().text.semiBold.make().centered().py4(),
                  if (order.deliveryAddress != null)
                    VStack([
                      "Delivery Address".tr().text.semiBold.make(),
                      5.heightBox,
                      "${order.deliveryAddress?.address}".text.make(),
                    ]).py4(),

                  //
                  CustomButton(
                    title: "Open Order Details".tr(),
                    onPressed: () {
                      stopNotificationSound();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsPage(
                            order: order,
                          ),
                        ),
                      );
                    },
                  ).wFull(context).py4(),
                  10.heightBox,
                ],
                // spacing: 10,
              ).p(12).box.border(color: Colors.grey).roundedSM.make();
            }),
        15.heightBox,

        CustomTextButton(
          title: "Ok, Close popup".tr(),
          onPressed: () {
            stopNotificationSound();
            Navigator.of(context).pop();
          },
        ).wFull(context),
        10.heightBox,
      ],
      // spacing: 5,
    )
        .scrollVertical()
        .p20()
        .py12()
        .box
        .white
        .topRounded()
        .make()
        .h(context.percentHeight * 85);
  }
}
