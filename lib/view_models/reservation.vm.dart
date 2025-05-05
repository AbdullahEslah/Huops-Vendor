import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clipboard/clipboard.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/models/reservation.dart';
import 'package:huops/services/app.service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/views/pages/reservation/reservation_details.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constants/app_colors.dart';
import 'base.view_model.dart';

class ReservationViewModel extends MyBaseViewModel {
  Map<String, dynamic>? reservation;

  ReservationViewModel(BuildContext context, {Map<String, dynamic>? reservation}) {
    this.viewContext = context;
    this.reservation = reservation;
  }

  List<String> status = ["All", "Pending", "Accepted", "Rejected", "Cancelled"];
  List<String> changeStatus = [ "Accepted", "Rejected"];
  String selectedStatus = "All";
  String selectedChangeStatus="";
  TextEditingController reasonController = TextEditingController();
  //
  RefreshController refreshController = RefreshController();
  StreamSubscription? refreshReservationStream;

  @override
  void initialise() async {
    print("#########${(await AuthServices.getCurrentVendor()).vendorType!.id.toString()}");
    print("#########${(await AuthServices.getCurrentVendor()).id}");
    // storage bags vendor_type_id = 15
    // hotel vendor_type_id = 14
    selectedChangeStatus= reservation?["reservation_data"]["status"]??"Accepted";
    // TODO: implement initialise
    refreshReservationStream = AppService().refreshReservations.listen((refresh) async {
      if (refresh) {
        if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
          getStorageBagsReservation();
        }else if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
          getHotelReservation();
        }else{
          getTableReservation();
        }

      }
    });
    if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
      await getStorageBagsReservation();
    }else if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
      await getHotelReservation();
    }else{
      await getTableReservation();
    }
    super.initialise();
  }
  makeCall(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);

    } else {
      viewContext.showToast(msg: "Could not launch $url");
      // throw 'Could not launch $url';
    }

  }

  sendMail(String email)async{
    String url = "mailto:$email";
    if (await canLaunch(url)) {
      launch(url);
    }else{
      viewContext.showToast(msg: "Could not launch $url");
      // throw 'Could not launch $url';
    }
  }

  dispose() {
    super.dispose();
    refreshReservationStream?.cancel();
  }

  List<Map<String, dynamic>> reservations = [];

  copyToClipboard(String text) {
    FlutterClipboard.copy(text).then((value) {
      Fluttertoast.showToast(msg: "Copied to Clipboard");
    });
  }

  getTableReservation({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    setBusy(true);
    reservations.clear();

    String vendorId =
        (await AuthServices.getCurrentUser()).vendor_id.toString();
    final response = selectedStatus == "All"
        ? await http.get(
            Uri.parse(
                "${Api.baseUrl + Api.reservations}/$vendorId"),
            headers: {
                "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
              })
        : await http.get(
            Uri.parse(
                "${Api.baseUrl + Api.reservationsStatus}/$vendorId/${selectedStatus}"),
            headers: {
                "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
              });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      jsonResponse['reservations'].forEach((element) {
        reservations.add(element);
      });

      // Sort the reservations based on the "created_at" field in descending order
      reservations.sort((a, b) => DateTime.parse(b["reservation_data"]["created_at"])
          .compareTo(DateTime.parse(a["reservation_data"]["created_at"])));

      log(reservations.toString());
    }

    setBusy(false);
  }

  // storage bags
  getStorageBagsReservation({bool initialLoading = true}) async {
    print("#########${(await AuthServices.getCurrentVendor()).id}");

    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    setBusy(true);
    reservations.clear();

    String vendorId =
    (await AuthServices.getCurrentUser()).vendor_id.toString();
    final response =
    selectedStatus == "All" ?
    await http.get(
        Uri.parse(
            "${Api.baseUrl + Api.storageBagsReservations}/$vendorId"),
        headers: {
          "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
        })
        : await http.get(
        Uri.parse(
            "${Api.baseUrl + Api.storageBagsReservationsStatus}/$vendorId/${selectedStatus}"),
        headers: {
          "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
        });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      jsonResponse['reservations'].forEach((element) {
        reservations.add(element);
      });

      // Sort the reservations based on the "created_at" field in descending order
      reservations.sort((a, b) => DateTime.parse(b["reservation_data"]["created_at"])
          .compareTo(DateTime.parse(a["reservation_data"]["created_at"])));

      log(reservations.toString());
    }

    setBusy(false);
  }

  //hotel reservation
  getHotelReservation({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      refreshController.refreshCompleted();
    }
    setBusy(true);
    reservations.clear();

    String vendorId =
    (await AuthServices.getCurrentUser()).vendor_id.toString();
    print("#######vendorId###$vendorId");
    final response =
    selectedStatus == "All" ?
    await http.get(
        Uri.parse(
            "${Api.baseUrl + Api.hotelReservations}/$vendorId"),
        headers: {
          "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
        })
        : await http.get(
        Uri.parse(
            "${Api.baseUrl + Api.hotelReservationsStatus}/$vendorId/${selectedStatus}"),
        headers: {
          "Authorization": "Bearer ${await AuthServices.getAuthBearerToken()}"
        });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      jsonResponse['reservations'].forEach((element) {
        reservations.add(element);
      });

      // Sort the reservations based on the "created_at" field in descending order
      reservations.sort((a, b) => DateTime.parse(b["reservation_data"]["created_at"])
          .compareTo(DateTime.parse(a["reservation_data"]["created_at"])));

      log(reservations.toString());
    }

    setBusy(false);
  }

  changeReservationStatus({required String statusNumber,required String resId,required Map<String,dynamic> body}) async {

    String token = await AuthServices.getAuthBearerToken();

    final response = await http.post(
        Uri.parse("${Api.baseUrl + Api.reservationChangeStatus}/$resId/$statusNumber"),body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        }
    );

    if (response.statusCode == 200) {

      if(statusNumber=="1"){
        log("accepted");

        return showDialog(
            context: viewContext,
            builder: (context) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
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
                      Text(
                        "Reservation Accepted".tr(),
                        style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
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
                            Text(
                              "Ok".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() {Navigator.pop(context);Navigator.pop(context);}),
                    ],
                  ).glassMorphic(opacity: .1),
                ),
              ).color(Colors.transparent);
            });
      }else{
        log("rejected");
        return showDialog(
            context: viewContext,
            builder: (context) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
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
                      Text(
                        "Reservation Rejected".tr(),
                        style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
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
                            Text(
                              "Ok".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() {Navigator.pop(context);Navigator.pop(context);}),
                    ],
                  ).glassMorphic(opacity: .1),
                ),
              ).color(Colors.transparent);
            });
      }
    }else{
      log("error");
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Error",
        text: "Something went wrong. Please try again",
        onConfirmBtnTap: () {
          Navigator.of(viewContext).pop();
        }
      );
    }
  }

  changeStorageBagsReservationStatus({required String statusNumber,required String resId,required Map<String,dynamic> body}) async {

    String token = await AuthServices.getAuthBearerToken();

    final response = await http.post(
        Uri.parse("${Api.baseUrl + Api.storageBagsReservationChangeStatus}/$resId/$statusNumber"),body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        }
    );

    print("#######${Api.baseUrl + Api.storageBagsReservationChangeStatus}/$resId/$statusNumber");
    if (response.statusCode == 200) {

      if(statusNumber=="1"){
        log("accepted");

        return showDialog(
            context: viewContext,
            builder: (context) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
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
                      Text(
                        "Reservation Accepted".tr(),
                        style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
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
                            Text(
                              "Ok".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                    ],
                  ).glassMorphic(opacity: .1),
                ),
              ).color(Colors.transparent);
            });
      }else{
        log("rejected");

        return showDialog(
            context: viewContext,
            builder: (context) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
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
                      Text(
                        "Reservation Rejected".tr(),
                        style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
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
                            Text(
                              "Ok".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() {Navigator.pop(context);Navigator.pop(context);}),
                    ],
                  ).glassMorphic(opacity: .1),
                ),
              ).color(Colors.transparent);
            });
      }
    }else{
      log("error");
      CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Error",
          text: "Something went wrong. Please try again",
          onConfirmBtnTap: () {
            Navigator.of(viewContext).pop();
            Navigator.of(viewContext).pop();
          }
      );
    }
  }

  changeHotelReservationStatus({required String statusNumber,required String resId,required Map<String,dynamic> body}) async {

    String token = await AuthServices.getAuthBearerToken();

    final response = await http.post(
        Uri.parse("${Api.baseUrl + Api.hotelReservationChangeStatus}/$resId/$statusNumber"),body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        }
    );

    print("#######${Api.baseUrl + Api.hotelReservationChangeStatus}/$resId/$statusNumber");
    if (response.statusCode == 200) {

      if(statusNumber=="1"){
        log("accepted");
        return showDialog(
            context: viewContext,
            builder: (context) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
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
                      Text(
                        "Reservation Accepted".tr(),
                        style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
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
                            Text(
                              "Ok".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                    ],
                  ).glassMorphic(opacity: .1),
                ),
              ).color(Colors.transparent);
            });
      }else{
        log("rejected");
        return showDialog(
            context: viewContext,
            builder: (context) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .25,
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
                      Text(
                        "Reservation Rejected".tr(),
                        style: TextStyle(color: Colors.white,fontSize: 20,inherit: false),
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
                            Text(
                              "Ok".tr(),
                              style: TextStyle(color: Colors.white,fontSize: 18,inherit: false),
                            ),
                          ],
                        ),
                      ).onTap(() {Navigator.pop(context);Navigator.pop(context);}),
                    ],
                  ).glassMorphic(opacity: .1),
                ),
              ).color(Colors.transparent);
            });
      }
    }else{
      log("error");
      CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Error",
          text: "Something went wrong. Please try again",
          onConfirmBtnTap: () {
            Navigator.of(viewContext).pop();
            Navigator.of(viewContext).pop();
          }
      );
    }
  }


  goToReservationDetails({required Map<String, dynamic> reservation}) async {
    await Navigator.of(viewContext)
        .push(MaterialPageRoute(builder: (context) => ReservationDetails(reservation: reservation),));
    // await getTableReservation();
    // notifyListeners();
  }

  void statusChanged(value) async {
    selectedStatus = value;
    if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
      await getStorageBagsReservation();
    }else if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
      await getHotelReservation();
    }else{
      await getTableReservation();
    }

    notifyListeners();
  }
  
  changeStatusMethod(value) async {
    selectedStatus = value;
    if(selectedStatus=="Accepted"){
      if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
        changeStorageBagsReservationStatus(statusNumber: "1",resId:reservation!["reservation_data"]["id"].toString(),body: {});
      }if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
        changeHotelReservationStatus(statusNumber: "1",resId:reservation!["reservation_data"]["id"].toString(),body: {});
      }else{
        changeReservationStatus(statusNumber: "1",resId:reservation!["reservation_data"]["id"].toString(),body: {});
      }
    }else{
      if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
        changeStorageBagsReservationStatus(statusNumber: "2",resId: reservation!["reservation_data"]["id"].toString(),body: {'reason': reasonController.text});
      }if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
        changeHotelReservationStatus(statusNumber: "2",resId: reservation!["reservation_data"]["id"].toString(),body: {'reason': reasonController.text});
      }else{
        changeReservationStatus(statusNumber: "2",resId: reservation!["reservation_data"]["id"].toString(),body: {'reason': reasonController.text});
      }

    }
    if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
      getStorageBagsReservation(initialLoading: false);
    }if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
      getHotelReservation(initialLoading: false);
    }else{
      getTableReservation(initialLoading: false);
    }

    notifyListeners();

  }
}
