import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huops/views/pages/profile/images/add_images_page.dart';
import 'package:huops/views/pages/profile/images/panorama_viewer.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../models/images_model/vendor_images.dart';
import '../../../../services/auth.service.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {

  List<dynamic> vendorImages = [];
  String vendorPanorama = "";
  String vendorPanoramaId = "";
  bool _isLoading = false;
  int vendorImagesIndex = 0;


  deleteImage(String imageId)async{
    http.Response response = await http.delete(
      Uri.parse('http://huopsapp.it/api/image/$imageId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Toast.show(
          "Deleted Image Done".tr(),
          context);
    } else {
      Toast.show(
          "Deleted Image Error".tr(),
          context);
    }
  }

  getImages()async{
    try{
      setState(() {
        _isLoading = true;
      });
      String vendor_id = (await AuthServices.getCurrentVendor()).id.toString();
      http.Response response = await http.get(Uri.parse('http://huopsapp.it/api/panorama/images/$vendor_id'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          vendorPanorama = data["panorama"]['panorama'] ;
          vendorPanoramaId = data["panorama"]['id'].toString() ;
          vendorImages = data['images'] ;
        });

        print('############$vendorImages');
        print('############${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
      setState(() {
        _isLoading = false;
      });
    }catch(e){
      setState(() {
        _isLoading = false;
      });
    }

  }
  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
        showAppBar: true,
        title: "Images",
        showLeadingAction: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vendorPanorama.isNotEmpty ? "Tap long press to delete image".tr().text.gray400.make().p12() : SizedBox(),
            _isLoading ? Container(child: CircularProgressIndicator().centered()).expand() : vendorPanorama.isNotEmpty ?  Column(
                children: [
                  GestureDetector(
                    onTap:(){
                      Navigator.push(
                          context,MaterialPageRoute(builder: (context) => Panorama360( panorama: vendorPanorama,),)
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.loose,
                        alignment: Alignment.center,
                        children: [
                          Image.network("${vendorPanorama}",fit: BoxFit.cover,).hFull(context),
                          Image.asset("assets/images/360.png",width: 50,  opacity: const AlwaysStoppedAnimation(.5),),
                        ],
                      ),),
                  ).expand(flex: 2),
                  // SizedBox(height: 5,),
                  SizedBox(
                    // height:vendorImages.length == 0 ? 0 : 150,
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlayCurve: Curves.easeInOut,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            viewportFraction: 1,
                            autoPlay: true,
                            initialPage: 1,
                            // height: 150,
                            disableCenter: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                vendorImagesIndex = index;
                              });
                            },
                          ),
                          items: vendorImages.map(
                                (banner) {
                              return CachedNetworkImage(
                                imageUrl: banner['image'],
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width *.45 ,
                              )
                              .onInkLongPress((){
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    confirmBtnText: "Delete".tr(),
                                    cancelBtnText: "Cancel".tr(),
                                    confirmBtnTextStyle: TextStyle(color: Colors.white),
                                    cancelBtnTextStyle: TextStyle(color: Colors.black),
                                    confirmBtnColor: Colors.red,
                                    onConfirmBtnTap: (){
                                      deleteImage(vendorImages[vendorImagesIndex]['id'].toString());
                                      getImages();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Toast.show(
                                          "Deleted Images Done".tr(),
                                          context);
                                    },
                                    onCancelBtnTap: (){
                                      Navigator.pop(context);
                                    }
                                );
                              })
                                  .onInkTap(() {})
                                  .box
                                  .roundedSM
                                  .clip(Clip.antiAlias)
                                  .make().p12();
                            },
                          ).toList(),
                        ).expand(),
                        //indicators
                        AnimatedSmoothIndicator(
                          activeIndex: vendorImagesIndex,
                          count: vendorImages.length,
                          textDirection: TextDirection.rtl,
                          effect: ExpandingDotsEffect(
                            dotHeight: 6,
                            dotWidth: 10,
                            activeDotColor: context.primaryColor,
                          ),
                        ).centered(),
                      ],
                    ),


                  ).expand(flex: 1),
                ]
            ).h64(context).p12().wFull(context).glassMorphic(opacity: 0.1)
                : Container(child: "There is no image".tr().text.white.lg.make().centered(),).expand(),
          ],
        ),
      fab: FloatingActionButton(
        onPressed: () {
          // Add your FAB onPressed action here
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddImagesPage())).then((value) {
            getImages();
          } );
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: AppColor.primaryColor,
      ),
    );
  }
}


// ListView.separated(
// scrollDirection: Axis.horizontal,
// itemBuilder:(context, index) => GestureDetector(
// onLongPress: (){
// CoolAlert.show(
// context: context,
// type: CoolAlertType.confirm,
// confirmBtnText: "Delete".tr(),
// cancelBtnText: "Cancel".tr(),
// confirmBtnTextStyle: TextStyle(color: Colors.white),
// cancelBtnTextStyle: TextStyle(color: Colors.black),
// confirmBtnColor: Colors.red,
// onConfirmBtnTap: (){
// deleteImage(vendorImages[index]['id'].toString());
// getImages();
// Navigator.pop(context);
// Navigator.pop(context);
// Toast.show(
// "Deleted Images Done".tr(),
// context);
// },
// onCancelBtnTap: (){
// Navigator.pop(context);
// }
// );
// },
// onTap: (){
// SwipeImageGallery(
// context: context,
// itemBuilder: (context, index) {
// return Image.network("${vendorImages[index]['image']}");
// },
// itemCount:vendorImages.length,
// ).show();
// },
// child: ClipRRect(
// borderRadius: BorderRadius.circular(12),
// child: Image.network("${vendorImages[index]['image']}",width: 150,fit: BoxFit.cover,)),
// ),
// separatorBuilder: (context, index) => SizedBox(width: 10,),
// itemCount: vendorImages.length,
// ),

//
// Image.network(
// banner['image'],
// // vendorImages[vendorImagesIndex]['image'],
// fit: BoxFit.fill,
// width: double.infinity,
// )
//     .onInkTap(() {})
//     .box
//     .roundedSM
//     .clip(Clip.antiAlias)
//     .make().p12();