import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/widgets.dart';
import 'package:glass/glass.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/bottomsheets/reason_reject_reservation_botoom_sheet.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../services/auth.service.dart';

class ReservationDetails extends StatefulWidget {
  final Map<String, dynamic> reservation;

  const ReservationDetails({super.key, required this.reservation});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  bool isStorageBagsReservation = false;
  bool isHotelReservation = false;
  String reservationEndDate = "";

  getIsStorageBagsReservation() async {
    if ((await AuthServices.getCurrentVendor()).vendorType!.id.toString() ==
        "15") {
      setState(() {
        isStorageBagsReservation = true;
      });
      getReservationEndDate();
    } else {
      setState(() {
        isStorageBagsReservation = false;
      });
    }
  }

  getIsHotelReservation() async {
    print("########123#######${widget.reservation}");

    if ((await AuthServices.getCurrentVendor()).vendorType!.id.toString() ==
        "14") {
      setState(() {
        isHotelReservation = true;
      });
      getReservationEndDate();
    } else {
      setState(() {
        isHotelReservation = false;
      });
    }
  }

  @override
  void initState() {
    getIsStorageBagsReservation();
    getIsHotelReservation();
    super.initState();
  }

  getReservationEndDate() {
    String dateString = widget.reservation["reservation_data"]["date"];
    List<String> dateComponents = dateString.split('-');
    int day = int.parse(dateComponents[2]) +
        int.parse(widget.reservation["reservation_data"]["days"].toString());
    int month = int.parse(dateComponents[1]);
    int year = int.parse(dateComponents[0]);
    // Create a DateTime object using the components
    setState(() {
      reservationEndDate =
          DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));
    });
    print("######asdaeda####$reservationEndDate");
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return ViewModelBuilder<ReservationViewModel>.reactive(
      viewModelBuilder: () =>
          ReservationViewModel(context, reservation: widget.reservation),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePageWithoutNavBar(
          showAppBar: true,
          showLeadingAction: true,
          title: "Reservation Details",
          elevation: 0,
          isLoading: vm.isBusy,
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            child: VStack(crossAlignment: CrossAxisAlignment.center, [
              Container(
                padding: EdgeInsets.all(15),
                color: AppColor.primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Name")
                                .text
                                .xl
                                .semiBold
                                .color(Colors.white)
                                .make(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget.reservation["user_name"])
                                .text
                                .xl
                                .color(AppColor.primaryColor)
                                .make(),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Email")
                                .text
                                .xl
                                .semiBold
                                .color(Colors.white)
                                .make(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget.reservation["user_email"])
                                .text
                                .xl
                                .maxLines(2)
                                .color(AppColor.primaryColor)
                                .make()
                                .expand(),
                            // Spacer(),
                            InkWell(
                              onTap: () {
                                vm.sendMail(widget.reservation["user_email"]);
                              },
                              child: Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Phone")
                                .text
                                .xl
                                .semiBold
                                .color(Colors.white)
                                .make(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(widget.reservation["user_phone"])
                                .text
                                .xl
                                .color(AppColor.primaryColor)
                                .make(),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                vm.makeCall(widget.reservation["user_phone"]);
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white70,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    isStorageBagsReservation
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        "Check-in"
                                                            .tr()
                                                            .text
                                                            .xl
                                                            .white
                                                            .make(),
                                                        5.heightBox,
                                                        widget.reservation[
                                                                "reservation_data"]
                                                                ["date"]
                                                            .toString()
                                                            .substring(0, 10)
                                                            .text
                                                            .xl
                                                            .white
                                                            .make(),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.date_range,
                                                      color: Colors.white,
                                                      size: 25,
                                                    )
                                                  ],
                                                ).expand(),
                                                // SizedBox(width: 10,),
                                                SizedBox(
                                                  height: 40,
                                                  child: VerticalDivider(
                                                    thickness: 1,
                                                    width: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                // SizedBox(width: 10,),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        "Check-out"
                                                            .tr()
                                                            .text
                                                            .xl
                                                            .white
                                                            .make(),
                                                        5.heightBox,
                                                        "${DateTime.parse(widget.reservation["reservation_data"]["date"]).add(Duration(days: widget.reservation["reservation_data"]["days"])).toString().substring(0, 10)}"
                                                            .text
                                                            .xl
                                                            .white
                                                            .make(),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.date_range,
                                                      color: Colors.white,
                                                      size: 25,
                                                    )
                                                  ],
                                                ).expand(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            (widget.reservation["reservation_data"]
                                                            ["description"] ==
                                                        null ||
                                                    widget.reservation[
                                                                "reservation_data"]
                                                            ["description"] ==
                                                        "")
                                                ? SizedBox()
                                                : "Description"
                                                    .tr()
                                                    .text
                                                    .xl
                                                    .semiBold
                                                    .white
                                                    .make(),
                                            (widget.reservation["reservation_data"]
                                                            ["description"] ==
                                                        null ||
                                                    widget.reservation[
                                                                "reservation_data"]
                                                            ["description"] ==
                                                        "")
                                                ? SizedBox()
                                                : Text(
                                                    "${widget.reservation["reservation_data"]["description"]}",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                    .text
                                                    .lg
                                                    .semiBold
                                                    .make()
                                                    .p8()
                                                    .glassMorphic()
                                                    .wFull(context),
                                            15.heightBox,
                                            "Details".text.xl2.white.bold.make(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                widget.reservation[
                                                                "reservation_data"]
                                                            ["image"] ==
                                                        null
                                                    ? SizedBox().expand()
                                                    : Image.network(
                                                        "https://huopsapp.it/" +
                                                            "${widget.reservation["reservation_data"]["image"]}",fit: BoxFit.cover,
                                                      )
                                                        .box
                                                        .roundedSM
                                                        .clip(Clip.antiAlias)
                                                        .make()
                                                        .glassMorphic()
                                                        .expand(),
                                                5.widthBox,
                                                Column(
                                                  children: [
                                                    "Price: ${widget.reservation["reservation_data"]["price"]}"
                                                        .tr()
                                                        .text
                                                        .xl.white
                                                        .make()
                                                        .p8()
                                                        .glassMorphic()
                                                        .wFull(context),
                                                    5.heightBox,
                                                    "Size: ${widget.reservation["reservation_data"]["bag_size"]}"
                                                        .tr()
                                                        .text.white
                                                        .xl
                                                        .make()
                                                        .p8()
                                                        .glassMorphic()
                                                        .wFull(context),
                                                  ],
                                                ).expand(),
                                              ],
                                            ).h(85),
                                          ]),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        widget.reservation["reservation_data"]
                                            ["status"],
                                        style: TextStyle(
                                            color: widget.reservation[
                                                            "reservation_data"]
                                                        ["status"] ==
                                                    "Pending"
                                                ? Colors.grey
                                                : widget.reservation[
                                                                "reservation_data"]
                                                            ["status"] ==
                                                        "Accepted"
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )).asGlass(
                                tintColor: widget.reservation["reservation_data"]
                                            ["status"] ==
                                        "Pending"
                                    ? Colors.grey
                                    : widget.reservation["reservation_data"]
                                                ["status"] ==
                                            "Accepted"
                                        ? Colors.green
                                        : Colors.red,
                                clipBorderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          )

                        : isHotelReservation
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            "Check-in"
                                                                .tr()
                                                                .text
                                                                .xl
                                                                .white
                                                                .make(),
                                                            5.heightBox,
                                                            widget.reservation[
                                                                    "reservation_data"]
                                                                    ["date"]
                                                                .toString()
                                                                .substring(0, 10)
                                                                .text
                                                                .xl
                                                                .white
                                                                .make(),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons.date_range,
                                                          color: Colors.white,
                                                          size: 25,
                                                        )
                                                      ],
                                                    ).expand(),
                                                    // SizedBox(width: 10,),
                                                    SizedBox(
                                                      height: 40,
                                                      child: VerticalDivider(
                                                        thickness: 1,
                                                        width: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    // SizedBox(width: 10,),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            "Check-out"
                                                                .tr()
                                                                .text
                                                                .xl
                                                                .white
                                                                .make(),
                                                            5.heightBox,
                                                            "${DateTime.parse(widget.reservation["reservation_data"]["date"]).add(Duration(days: widget.reservation["reservation_data"]["days"])).toString().substring(0, 10)}"
                                                                .text
                                                                .xl
                                                                .white
                                                                .make(),
                                                          ],
                                                        ),
                                                        Icon(
                                                          Icons.date_range,
                                                          color: Colors.white,
                                                          size: 25,
                                                        )
                                                      ],
                                                    ).expand(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                (widget.reservation["reservation_data"]
                                                                ["details"] ==
                                                            null ||
                                                        widget.reservation[
                                                                    "reservation_data"]
                                                                ["details"] ==
                                                            "")
                                                    ? SizedBox()
                                                    : "Details"
                                                        .tr()
                                                        .text
                                                        .xl
                                                        .semiBold
                                                        .white
                                                        .make(),
                                                (widget.reservation["reservation_data"]
                                                                ["details"] ==
                                                            null ||
                                                        widget.reservation[
                                                                    "reservation_data"]
                                                                ["details"] ==
                                                            "")
                                                    ? SizedBox()
                                                    : Text(
                                                        "${widget.reservation["reservation_data"]["details"]}",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      )
                                                        .text
                                                        .lg
                                                        .semiBold
                                                        .make()
                                                        .p8()
                                                        .glassMorphic()
                                                        .wFull(context),
                                                15.heightBox,
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        "TotalRooms"
                                                            .text
                                                            .xl.white
                                                            .make(),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        "${widget.reservation["reservation_data"]["rooms"]}"
                                                            .tr()
                                                            .text.white
                                                            .xl
                                                            .make(),
                                                      ],
                                                    )
                                                        .p16()
                                                        .glassMorphic()
                                                        .expand(),
                                                    5.widthBox,
                                                    Column(
                                                      children: [
                                                        "${widget.reservation["reservation_data"]["single"]}" ==
                                                                "1"
                                                            ? FittedBox(
                                                                    child: Text(
                                                                "${widget.reservation["reservation_data"]["single"]} Single Room"
                                                                    .tr(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ).p8().glassMorphic())
                                                                .wFull(context)
                                                            : FittedBox(
                                                                    child: Text(
                                                                "${widget.reservation["reservation_data"]["single"]} Single Rooms"
                                                                    .tr(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ).p8().glassMorphic())
                                                                .wFull(context),
                                                        5.heightBox,
                                                        "${widget.reservation["reservation_data"]["double"]}" ==
                                                                "1"
                                                            ? FittedBox(
                                                                    child: Text(
                                                                "${widget.reservation["reservation_data"]["double"]} Double Room"
                                                                    .tr(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ).p8().glassMorphic())
                                                                .wFull(context)
                                                            : FittedBox(
                                                                    child: Text(
                                                                "${widget.reservation["reservation_data"]["double"]} Double Rooms"
                                                                    .tr(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ).p8().glassMorphic())
                                                                .wFull(context),
                                                      ],
                                                    ).expand(),
                                                  ],
                                                ),
                                                20.heightBox,
                                                "Number of Guests: ${widget.reservation["reservation_data"]["count_of_people"]}"
                                                    .tr()
                                                    .text
                                                .white
                                                    .xl
                                                    .make()
                                                    .p8()
                                                    .glassMorphic()
                                                    .wFull(context),
                                              ]),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            widget.reservation["reservation_data"]
                                                ["status"],
                                            style: TextStyle(
                                                color: widget.reservation[
                                                                "reservation_data"]
                                                            ["status"] ==
                                                        "Pending"
                                                    ? Colors.grey
                                                    : widget.reservation[
                                                                    "reservation_data"]
                                                                ["status"] ==
                                                            "Accepted"
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )).asGlass(
                                    tintColor: widget.reservation[
                                                "reservation_data"]["status"] ==
                                            "Pending"
                                        ? Colors.grey
                                        : widget.reservation["reservation_data"]
                                                    ["status"] ==
                                                "Accepted"
                                            ? Colors.green
                                            : Colors.red,
                                    clipBorderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(children: [
                                                      Icon(
                                                        Icons.date_range_rounded,
                                                        size: 50,
                                                        color:
                                                            AppColor.primaryColor,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(widget.reservation[
                                                                  "reservation_data"]
                                                              ["date"])
                                                          .text
                                                          .xl2
                                                          .semiBold
                                                          .color(Colors.white)
                                                          .make(),
                                                    ]),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        size: 50,
                                                        color:
                                                            AppColor.primaryColor,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(widget.reservation[
                                                                  "reservation_data"]
                                                              ["time"])
                                                          .text
                                                          .xl2
                                                          .semiBold
                                                          .color(Colors.white)
                                                          .make(),
                                                    ]),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(children: [
                                                      Icon(
                                                        Icons.table_bar,
                                                        size: 50,
                                                        color:
                                                            AppColor.primaryColor,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(widget.reservation[
                                                                  "reservation_data"]
                                                                  ["tables"]
                                                              .toString())
                                                          .text
                                                          .xl2
                                                          .semiBold
                                                          .color(Colors.white)
                                                          .make(),
                                                    ]),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .person_3_fill,
                                                        size: 50,
                                                        color:
                                                            AppColor.primaryColor,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(widget.reservation[
                                                                  "reservation_data"]
                                                                  [
                                                                  "count_of_people"]
                                                              .toString())
                                                          .text
                                                          .xl2
                                                          .semiBold
                                                          .color(Colors.white)
                                                          .make(),
                                                    ]),
                                                  ],
                                                ),
                                                20.heightBox,
                                              ]),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            widget.reservation["reservation_data"]
                                                ["status"],
                                            style: TextStyle(
                                                color: widget.reservation[
                                                                "reservation_data"]
                                                            ["status"] ==
                                                        "Pending"
                                                    ? Colors.grey
                                                    : widget.reservation[
                                                                    "reservation_data"]
                                                                ["status"] ==
                                                            "Accepted"
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )).asGlass(
                                    tintColor: widget.reservation[
                                                "reservation_data"]["status"] ==
                                            "Pending"
                                        ? Colors.grey
                                        : widget.reservation["reservation_data"]
                                                    ["status"] ==
                                                "Accepted"
                                            ? Colors.green
                                            : Colors.red,
                                    clipBorderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: widget.reservation["reservation_data"]["status"] ==
                              "Cancelled"
                          ? SizedBox()
                          : widget.reservation["reservation_data"]["status"] ==
                                  "Pending"
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: CustomButton(
                                      title: "Accept",
                                      color: Colors.green,
                                      onPressed: () {
                                        vm.changeStatusMethod("Accepted");
                                      },
                                      shapeRadius: 12,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButton(
                                      title: "Reject",
                                      color: Colors.red,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          builder: (ctx) {
                                            return ReasonRejectReservationBottomSheet(
                                                vm);
                                          },
                                        );
                                      },
                                      shapeRadius: 12,
                                    )),
                                  ],
                                )
                              : Form(
                                  key: _formKey,
                                  child: DropdownButtonFormField2(
                                    iconStyleData: IconStyleData(
                                      icon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      iconSize: 24,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      isCollapsed: true,
                                    ),
                                    value: vm.selectedChangeStatus == "Cancelled"
                                        ? "Rejected"
                                        : vm.selectedChangeStatus,
                                    isExpanded: true,
                                    items: vm.changeStatus.map((String val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (vm.changeStatusMethod),
                                  ).glassMorphic(),
                                ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
