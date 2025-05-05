import 'dart:convert';

import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../../constants/app_colors.dart';
import '../../../services/auth.service.dart';
import '../../../widgets/custom_text_form_field.dart';

class UpdateStorageBagsPricePage extends StatefulWidget {
  const UpdateStorageBagsPricePage({super.key, required this.storageBagsPrice});

  final Map<String,dynamic> storageBagsPrice;

  @override
  State<UpdateStorageBagsPricePage> createState() =>
      _UpdateStorageBagsPricePageState();
}

class _UpdateStorageBagsPricePageState extends State<UpdateStorageBagsPricePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController largeBagTEC = new TextEditingController();
  TextEditingController mediumBagTEC = new TextEditingController();
  TextEditingController smallBagTEC = new TextEditingController();
  String vendorId = "";
  bool _isLoading = false;

  @override
  void initState() {
    initBagsPrice();
    super.initState();
  }

  updateStorageBagPrice() async {
    setState(() {
      _isLoading = true;
    });
    String vendor_id = (await AuthServices.getCurrentVendor()).id.toString();
    String token = "Bearer ${(await AuthServices.getAuthBearerToken()).toString()}";

    final String url = 'http://huopsapp.it/api/list/bag/prices/$vendor_id';

    Map<String,String> headers={
      "Authorization": "Bearer $token",
      "Accept": "application/json",
      "Content-type": "application/json",
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    request.fields['large'] = largeBagTEC.text;
    request.fields['medium'] = mediumBagTEC.text;
    request.fields['small'] = smallBagTEC.text;
    request.headers.addAll(headers);
    request.fields.addAll({});

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("#########${response.statusCode}");
    print("#########${response.body}");
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Toast.show(
          "Update Storage bags price Done".tr(),
          context);
    }else{
      Toast.show(
          "Something went wrong please try again!".tr(),
          context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  initBagsPrice()async{
    String vendor_id = (await AuthServices.getCurrentVendor()).id.toString();
    setState(() {
      largeBagTEC.text = widget.storageBagsPrice['large'];
      mediumBagTEC.text = widget.storageBagsPrice['medium'];
      smallBagTEC.text = widget.storageBagsPrice['small'];
      vendorId = vendor_id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showLeadingAction: true,
        showAppBar: true,
        title: "Update Storage bags price",
        body: Column(
      children: [
        Form(
          child: VStack([
            "Large bag price".tr().text.white.lg.make(),
            CustomTextFormField(
              hintText: "Large bag price".tr(),
              keyboardType: TextInputType.number,
              textEditingController: largeBagTEC,
            ).glassMorphic().py12(),
            15.heightBox,
            "medium bag price".tr().text.white.lg.make(),
            CustomTextFormField(
              hintText: "medium bag medium".tr(),
              keyboardType: TextInputType.number,
              textEditingController: mediumBagTEC,
            ).glassMorphic().py12(),
            15.heightBox,
            "small bag price".tr().text.white.lg.make(),
            CustomTextFormField(
              hintText: "small bag price".tr(),
              keyboardType: TextInputType.number,
              textEditingController: smallBagTEC,
            ).glassMorphic().py12(),
            30.heightBox,
            InkWell(
              onTap: (){
                updateStorageBagPrice();
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColor.primaryColor),
                child: _isLoading ? CircularProgressIndicator(color: Colors.white,).centered() : "Update".tr().text.xl.white.make().centered(),
              ),
            ),
          ]))
      ],
    ).p20(),);
  }
}
