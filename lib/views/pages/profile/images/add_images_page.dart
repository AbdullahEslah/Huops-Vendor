import 'dart:convert';
import 'dart:io';

import 'package:double_back_to_close/toast.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huops/utils/utils.dart';
import 'package:huops/views/pages/profile/images/panorama_viewer.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../constants/app_colors.dart';
import '../../../../services/auth.service.dart';

class AddImagesPage extends StatefulWidget {
  const AddImagesPage({super.key});

  @override
  State<AddImagesPage> createState() => _AddImagesPageState();
}

class _AddImagesPageState extends State<AddImagesPage> {
  //  PANORAMA;
  bool _isLoading = false;
  List<File> panoramaImages = [File('')];
  File panoramaImage = File('');
  String panoramaImageUrl = "";

  List<String> normalImagesURL = [];
  List<File> normalImages = [
    File(''),
    File(''),
    File(''),
  ];

  // File bagStorageImage = File('');

  selectImage(parentContext, index, images) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .37,
              width: MediaQuery.of(context).size.width * .8,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: Color(0xff56516f).withOpacity(.9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width * .3,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image,size: 25,color: Colors.white),
                            Text(
                                "Gallery".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() async {
                        Navigator.pop(context);
                        PickedFile? file = (await ImagePicker.platform.pickImage(
                            source: ImageSource.gallery, imageQuality: 25));
                        setState(() {
                          images[index] = File(file!.path);
                          images.length < 3 ? images.add(File("")) : null;
                        });
                      },),
                      10.widthBox,
                      Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width * .3,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt,size: 25,color: Colors.white,),
                            Text(
                              "Camera".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() async {
                        Navigator.pop(context);
                        PickedFile? file = (await ImagePicker.platform.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 25,
                          maxHeight: 675,
                          maxWidth: 960,
                        ));
                        setState(() {
                          images[index] = File(file!.path);
                          images.length < 6 ? images.add(File("")) : null;
                        });
                      })
                    ],
                  ).centered(),
                  // 10.heightBox,
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .7,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColor.primaryColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back,color: Colors.white,),
                        Text(
                          "Back".tr(),
                          style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                        ),
                      ],
                    ),
                  ).onTap(() {Navigator.pop(context);}),
                ],
              ).glassMorphic(opacity: .1),
            ),
          ).color(Colors.transparent);
        });
  }
  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
      title: "Add Images",
      showLeadingAction: true,
      body: Column(
        mainAxisAlignment: panoramaImages[0].path.isEmpty && normalImages[0].path.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          15.heightBox,
          panoramaImages[0].path.isNotEmpty
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.primaryColor),
                  child: "Add Panorama Image".text.white.make(),
                ).onTap(() {
                  selectImage(context, 0, panoramaImages);
                }).centered(),
          15.heightBox,
          normalImages[0].path.isNotEmpty && normalImages[1].path.isNotEmpty && normalImages[2].path.isNotEmpty
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.primaryColor),
                  child: "  Add Normal Image   ".text.white.make(),
                ).onTap(() {
                  selectImage(
                      context,
                      normalImages[0].path.isEmpty
                          ? 0
                          : normalImages[1].path.isEmpty
                              ? 1
                              : 2,
                      normalImages);
                }).centered(),
          15.heightBox,
          Column(
                  children: [
                    panoramaImages[0].path.isEmpty
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Panorama360File(
                                      panorama: panoramaImages[0],
                                    ),
                                  ));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                fit: StackFit.loose,
                                alignment: Alignment.center,
                                children: [
                                  Image.file(
                                    panoramaImages[0],
                                    fit: BoxFit.cover,
                                  ).hFull(context),
                                  Image.asset(
                                    "assets/images/360.png",
                                    width: 50,
                                    opacity: const AlwaysStoppedAnimation(.5),
                                  ),
                                  Positioned(
                                      top: 10,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            panoramaImages[0] = File("");
                                          });
                                        },
                                        child: Container(
                                            width: 30,
                                            height: 30,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white,
                                            ),
                                            child: "X"
                                                .text
                                                .xl
                                                .color(Colors.red)
                                                .extraBold
                                                .make()
                                                .centered()),
                                      )),
                                ],
                              ),
                            ),
                          ).wh24(context).p12().wFull(context),
                    normalImages[0].path.isEmpty
                        ? SizedBox()
                        : SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Stack(
                                children: normalImages[index].path.isEmpty
                                    ? [SizedBox()]
                                    : [
                                        GestureDetector(
                                          onTap: () {
                                            selectImage(context,index,normalImages);

                                          },
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.file(
                                                normalImages[index],
                                                width: 150,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        Positioned(
                                            top: 10,
                                            right: 10,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  normalImages[index] = File("");
                                                });
                                              },
                                              child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: Colors.white,
                                                  ),
                                                  child: "X"
                                                      .text
                                                      .xl
                                                      .color(Colors.red)
                                                      .extraBold
                                                      .make()
                                                      .centered()),
                                            )),
                                      ],
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                width: 10,
                              ),
                              itemCount: normalImages.length,
                            ),
                          ),
                  ],
                ),

          20.heightBox,

          panoramaImages[0].path.isEmpty && normalImages[0].path.isEmpty ? SizedBox() :
          InkWell(
            onTap: () async{
              // uploadImage(panoramaImages[0],);
              // callUploadImageToFirebase().then((value) {
              //   storageImageUrl();
              // });
              if(panoramaImages[0].path.isEmpty){
                Toast.show(
                    "Please enter panorama Image".tr(),
                    context);
                setState(() {
                  _isLoading = false;
                });
              }else{
                uploadImage(panoramaImages[0],true,0).then((value) {
                  normalImages[0].path.isNotEmpty  ? uploadImage(normalImages[0],false,0).then((value) {
                    normalImages[1].path.isNotEmpty  ? uploadImage(normalImages[1],false,1).then((value) {
                      normalImages[2].path.isNotEmpty  ? uploadImage(normalImages[2],false,2).then((value) {
                        uploadImage(normalImages[0],false,5);
                      }) : uploadImage(normalImages[0],false,5);
                    }) : uploadImage(normalImages[0],false,5);
                  }) : uploadImage(normalImages[0],false,5);;
                });
                // uploadImage(panoramaImages[0],true,0);
                // for(int i = 0 ; i <= normalImages.length   ;i++){
                //   if(i == normalImages.length){
                //     Future.delayed(Duration(seconds: 6)).then((value) {
                //       uploadImage(normalImages[0],false,5);
                //     });
                //   }else{
                //     normalImages[i].path.isEmpty ? null : uploadImage(normalImages[i],false,i);
                //   }
                //
                // }

                // normalImages[0].path.isNotEmpty ? uploadImage(normalImages[0],false,0) : null;
                // normalImages[1].path.isNotEmpty ? uploadImage(normalImages[1],false,1) : null;
                // normalImages[2].path.isNotEmpty ? uploadImage(normalImages[2],false,2) : null;
                //storageImageUrl();
                // await Future.delayed(Duration(seconds: 3)).then((value) {
                //   uploadImage(normalImages[0],false,5);
                // });

              }
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: AppColor.primaryColor),
              child: _isLoading ? CircularProgressIndicator(color: Colors.white,).centered() : "Save".tr().text.xl.white.make().centered(),
            ),
          )

        ],
      ),
    );
  }

  // final _dio = Dio();

  storageImageUrl() async {
    setState(() {
      _isLoading = true;
    });
    String user_id = (await AuthServices.getCurrentVendor()).id.toString();
    String token = "Bearer ${(await AuthServices.getAuthBearerToken()).toString()}";
    print("#########${panoramaImageUrl}");
    // print("#########${normalImagesURL[1]}");
    // print("#########${normalImagesURL[2]}");
    // Map<String, dynamic> requestBody = {
    //   "panorama": panoramaImageUrl,
    //   "images[0]": normalImages[0].path.isNotEmpty  ? "${normalImagesURL[0]}" : "",
    //   "images[1]": normalImages[1].path.isNotEmpty  ? "${normalImagesURL[1]}" : "",
    //   "images[2]": normalImages[2].path.isNotEmpty ? "${normalImagesURL[2]}" : "",
    // };
    // String requestBodyJson = jsonEncode(requestBody);
    //
    // http.Response response = await http.post(
    //   Uri.parse('https://huopsapp.it/api/panorama/$user_id'),
    //   body: requestBodyJson,
    //   headers: {
    //     'Authorization': token,
    //   },
    // );

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://huopsapp.it/api/panorama/$user_id'),
    );
    request.fields['panorama'] = panoramaImageUrl;
    normalImagesURL.length >= 1  ? request.fields['images[0]'] =  "${normalImagesURL[0]}" : null;
    normalImagesURL.length >= 2 ? request.fields['images[1]'] = "${normalImagesURL[1]}" : null;
    normalImagesURL.length == 3  ? request.fields['images[2]'] = "${normalImagesURL[2]}" : null;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);


    print("#########${response.statusCode}");
    print("#########${response.body}");

    if(response.statusCode == 200){
      Navigator.pop(context);
      Toast.show(
          "Added Images Done".tr(),
          context);
    }
    else{

    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> uploadImage(File imageFile,bool isPanoramaImage ,int index) async {
    setState(() {
      _isLoading = true;
    });
    if(index == 5){
      storageImageUrl();
    } else {
      File? compressImage = await Utils.compressFile(file: imageFile);

      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('vendor/$imageName.jpeg');
      // final UploadTask uploadTask = storageReference.putData(await imageFile.readAsBytes());
      final UploadTask uploadTask = storageReference.putFile(compressImage!, SettableMetadata(contentType: 'image/jpeg'));
      await uploadTask;
      String imageUrl = await storageReference.getDownloadURL();

      if (isPanoramaImage) {
        setState(() {
          panoramaImageUrl = imageUrl;
        });
      } else {
        setState(() {
          normalImagesURL.add(imageUrl);
        });
      }
    }
    return true;
  }

}
