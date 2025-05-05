
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/app_colors.dart';
import 'package:huops/utils/ui_spacer.dart';
import 'package:huops/view_models/orders.vm.dart';
import 'package:huops/widgets/base.page.dart';
import 'package:huops/widgets/base.page.withoutNavbar.dart';
import 'package:huops/widgets/buttons/custom_button.dart';
import 'package:huops/widgets/custom_list_view.dart';
import 'package:huops/widgets/list_items/order.list_item.dart';
import 'package:huops/widgets/list_items/unpaid_order.list_item.dart';
import 'package:huops/widgets/states/error.state.dart';
import 'package:huops/widgets/states/order.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../models/order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage> {
  //
  @override
  void initState() {
    super.initState();
  }



  String? selectedValue;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      minimum: EdgeInsets.all(0),
      child: ViewModelBuilder<OrdersViewModel>.reactive(
        viewModelBuilder: () => OrdersViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePageWithoutNavBar(
            body: VStack(
              [
                //
                "Orders".tr().text.xl3.semiBold.white.make().px20(),
                //order status
                Form(
                  key: _formKey,
                  child: DropdownButtonFormField2(
                      iconStyleData: IconStyleData(
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: AppColor.primaryColor,
                          ),
                        ),
                        iconSize: 24,
                      ),
                      // style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),

                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isCollapsed: true,
                      ),

                      value: vm.selectedStatus,
                      isExpanded:true,
                      items: vm.statuses
                      .map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                   onChanged: (vm.statusChanged)).glassMorphic(opacity: 0.1).px20().py8(),
                ),

                // UiSpacer.verticalSpace(),
                //
                CustomListView(
                  canRefresh: true,
                  canPullUp: true,
                  refreshController: vm.refreshController,
                  onRefresh: vm.fetchMyOrders,
                  onLoading: () => vm.fetchMyOrders(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.orders,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrders,
                  ),
                  //
                  emptyWidget: EmptyOrder(),
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 5),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.orders[index];
                    if (order.isUnpaid) {
                      return UnPaidOrderListItem(order: order);
                    }
                    return OrderListItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(order),
                    );
                  },
                ).px20().expand(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
