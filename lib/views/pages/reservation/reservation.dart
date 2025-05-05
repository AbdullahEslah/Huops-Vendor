import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/models/reservation.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/reservation.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/states/error.state.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:huops/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TableReservation extends StatefulWidget {
  const TableReservation({super.key});

  @override
  _TableReservationState createState() => _TableReservationState();
}

class _TableReservationState extends State<TableReservation>   with AutomaticKeepAliveClientMixin<TableReservation>{

  final _formKey = GlobalKey<FormState>();
  bool isStorageBagsReservation = false;
  bool isHotelReservation = false;


  @override
  void initState() {
    getIsStorageBagsReservation();
    getIsHotelReservation();
    super.initState();
  }

  getIsStorageBagsReservation()async{
    if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "15"){
      setState(() {
        isStorageBagsReservation = true;
      });
    }else{
      setState(() {
        isStorageBagsReservation = false;
      });
    }
  }

  getIsHotelReservation()async{
    if((await AuthServices.getCurrentVendor()).vendorType!.id.toString() == "14"){
      setState(() {
        isHotelReservation = true;
      });
    }else{
      setState(() {
        isHotelReservation = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(

        child: ViewModelBuilder<ReservationViewModel>.reactive(
        viewModelBuilder: () => ReservationViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePageWithoutNavBar(
            body: Container(
              // color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Bookings".tr().text.xl3.white.semiBold.make(),
                    SizedBox(
                      height: 7,
                    ),
                    Form(
                      key: _formKey,
                      child: DropdownButtonFormField2(
                        iconStyleData: IconStyleData(
                          icon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          iconSize: 24,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isCollapsed: true,
                        ),
                        value: vm.selectedStatus,
                        isExpanded: true,
                        items: vm.status.map((String val) {
                          return DropdownMenuItem(
                            value: val,
                            child: Text(
                              val,
                            ),
                          );
                        }).toList(),
                        onChanged: (vm.statusChanged),
                      ).glassMorphic(opacity: 0.1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomListView(
                      canRefresh: true,
                      canPullUp: true,
                      refreshController: vm.refreshController,
                      onRefresh: isStorageBagsReservation ? vm.getStorageBagsReservation
                          : (isHotelReservation ? vm.getHotelReservation : vm.getTableReservation),
                      isLoading: vm.isBusy,
                      onLoading: () => isStorageBagsReservation ? vm.getStorageBagsReservation(initialLoading: false)
                          : isHotelReservation ? vm.getHotelReservation(initialLoading: false) : vm.getTableReservation(initialLoading: false),
                      dataSet: vm.reservations,
                      hasError: vm.hasError,
                      errorWidget: LoadingError(
                        onrefresh: isStorageBagsReservation ? vm.getStorageBagsReservation
                            : isHotelReservation ? vm.getHotelReservation : vm.getTableReservation,
                      ),
                      emptyWidget: EmptyOrder(
                        title: "No Reservations",
                        description:
                            "We don't have any reservations for you right now.",
                      ),
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(space: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => vm.goToReservationDetails( reservation: vm.reservations[index]),

                          child: ReservationCard(
                            vm,
                            vm.reservations[index],
                            isStorageBagsReservation,
                            isHotelReservation,
                          ),
                        );
                      },
                    ).expand(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

Widget ReservationCard(
    ReservationViewModel vm, Map<String, dynamic> reservation,bool isStorageBagsReservation,bool isHotelReservation) {
  print("#########THISISDATA####$reservation");
  return Card(
    color: Colors.transparent,
    elevation: 0,
    child: vm.isBusy
        ? LoadingShimmer()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(
                          CupertinoIcons.profile_circled,
                          color: AppColor.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          reservation["user_name"],
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ]),
                      Row(children: [
                        Icon(
                          Icons.date_range,
                          color: AppColor.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          reservation['reservation_data']["date"],
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ]),
                      Row(children: [
                        Icon(
                          isStorageBagsReservation || isHotelReservation ? Icons.date_range_outlined : Icons.access_time_rounded,
                          color: AppColor.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          isStorageBagsReservation || isHotelReservation ? "${reservation['reservation_data']['days']} days" : reservation['reservation_data']["time"],
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ]),
                      isStorageBagsReservation ? SizedBox() : Row(children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              color: AppColor.primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              reservation['reservation_data']["count_of_people"]
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(width: 20,),
                        isHotelReservation ? SizedBox() : Row(
                          children: [
                            Icon(
                              Icons.table_bar,
                              color: AppColor.primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              reservation['reservation_data']["tables"]
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ]),
                      isHotelReservation ? Row(
                        children: [
                          Icon(
                            Icons.room_preferences_outlined,
                            color: AppColor.primaryColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${reservation['reservation_data']["rooms"]} Rooms"
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ],
                      ) : SizedBox(),
                      isHotelReservation ?
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColor.primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Single: ${reservation['reservation_data']["single"]} "
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              10.widthBox,
                              Text(
                                "Double: ${reservation['reservation_data']["double"]} "
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                            ],
                          ) : SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    reservation["reservation_data"]["status"],
                    style: TextStyle(
                        color: reservation["reservation_data"]["status"] ==
                                "Accepted"
                            ? Colors.green
                            :reservation["reservation_data"]["status"] ==
                            "Pending"? Colors.amber:Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ).glassMorphic(opacity: 0.1),
  );
}
