import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/views/pages/storage_bags_price/update_storage_bags_price.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../../services/auth.service.dart';


class StorageBagsPricePage extends StatefulWidget {
  const StorageBagsPricePage({super.key});

  @override
  State<StorageBagsPricePage> createState() => _StorageBagsPricePageState();
}

class _StorageBagsPricePageState extends State<StorageBagsPricePage> {
  bool _isLoading = false;
  Map<String,dynamic> storageBagsPrice = {};

  @override
  void initState() {
    getStorageBagsPrice();
    super.initState();
  }

  getStorageBagsPrice()async{
    setState(() {
      _isLoading = true;
    });
    String token = "Bearer ${(await AuthServices.getAuthBearerToken()).toString()}";
    String vendor_id = (await AuthServices.getCurrentVendor()).id.toString();
    http.Response response = await http.get(Uri.parse('http://huopsapp.it/api/list/bag/prices/$vendor_id'),headers: {
      "Authorization": token,
    });
    print('############${response.statusCode}');
    print('############${response.body}');
    print('############${vendor_id}');
    if (response.statusCode == 200) {

      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        storageBagsPrice = data;
      });

    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
        title: "Storage bags price",
        showLeadingAction: true,
        appBarColor: AppColor.primaryColor,
        body: _isLoading ? CircularProgressIndicator().centered() : Column(
          children: [
             Container(
               width: MediaQuery.of(context).size.width * .9,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
              child: Row(
                children: [
                  "Price of Large bag ".tr().text.white.xl.bold.make(),
                  "\$${storageBagsPrice['large']}".text.color(Colors.amber).xl.bold.make(),
                ],
              ),
            ).glassMorphic(opacity: .1),
            15.heightBox,
            Container(
              width: MediaQuery.of(context).size.width * .9,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
              child: Row(
                children: [
                  "Price of medium bag ".tr().text.white.xl.bold.make(),
                  "\$${storageBagsPrice['medium']}".text.xl.color(Colors.amber).bold.make(),
                ],
              ),
            ).glassMorphic(opacity: .1),
            15.heightBox,
            Container(
              width: MediaQuery.of(context).size.width * .9,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
              child: Row(
                children: [
                  "Price of small bag ".tr().text.white.xl.bold.make(),
                  "\$${storageBagsPrice['small']}".text.color(Colors.amber).xl.bold.make(),
                ],
              ),
            ).glassMorphic(opacity: .1),
            30.heightBox,
            InkWell(
              onTap: (){
                context.push((context) => UpdateStorageBagsPricePage(storageBagsPrice: storageBagsPrice)).then((value) {
                  getStorageBagsPrice();
                });
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColor.primaryColor),
                child: _isLoading ? CircularProgressIndicator(color: Colors.white,).centered() : "Update".tr().text.xl.white.make().centered(),
              ),
            ),
          ],
        ).p20(),
    );
  }
}
