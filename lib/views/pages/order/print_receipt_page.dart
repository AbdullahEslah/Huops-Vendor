import 'dart:math';

// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
// import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
// import 'package:printing/printing.dart';

import '../../../models/order.dart';
import '../../../models/order_product.dart';
import '../../../models/order_stop.dart';
import '../../../utils/utils.dart';
import '../../../widgets/base.page.withoutNavbar.dart';
import 'helper_printer.dart';
import 'package:pdf/widgets.dart' as pw;

import 'ios_printing.dart';

class PrintReceiptPage extends StatefulWidget {
  final Order order;
  const PrintReceiptPage({super.key, required this.order});

  @override
  State<PrintReceiptPage> createState() => _PrintReceiptPageState();
}

class _PrintReceiptPageState extends State<PrintReceiptPage> {
  //  for printing receipts
  // ReceiptController? controller;

  //
  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  // List<BluetoothDevice> _devices = [];
  String _deviceMessage = "";
  int? _selectedDeviceIndex;

  //  for creating pages of pdfs
  final doc = pw.Document();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
    super.initState();

    doc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Text(widget.order.subTotal.toString()),
      ); // Center
    }));

    //getPrinters();
  }

  Future<void> initPrinter() async {
    //_bluetoothPrintPlus.startScan(timeout: const Duration(seconds: 30));

    //print();

    // bluetoothPrint.startScan(timeout: Duration(seconds: 4));
    //
    // if (!mounted) return;
    // bluetoothPrint.scanResults.listen((value) {
    //   if (!mounted) return;
    //   setState(() {
    //     _devices = value;
    //   });
    //
    //   if (_devices.isNotEmpty) {
    //     setState(() {
    //       _deviceMessage = "No Devices Yet!";
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWithoutNavBar(
      showAppBar: true,
      showLeadingAction: true,
      elevation: 0,
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // StreamBuilder<List<BluetoothDevice>>(
          //   stream: bluetoothPrint.scanResults,
          //   initialData: [],
          //   builder: (c, snapshot) => Expanded(
          //     child: ListView(
          //       children: snapshot.data!
          //           .map((d) => Container(
          //                 padding: const EdgeInsets.only(
          //                     left: 10, right: 10, bottom: 5),
          //                 child: ListTile(
          //                     leading: Icon(Icons.print),
          //                     title: Text(d.name ?? ""),
          //                     subtitle: Text(d.address ?? ""),
          //                     onTap: () async {
          //                       await bluetoothPrint.connect(d);
          //                       // setState(() {
          //                       //   _selectedDeviceIndex = index;
          //                       // });
          //                     }),
          //               ))
          //           .toList(),
          //     ),
          //   ),
          // ),
          ElevatedButton(
            onPressed: () async {
              final printerService = BluetoothPrinterService();
              String? receiptText;
              receiptText =
                  "Vendor: ${widget.order.vendor?.name ?? ""}\n--------------\norder id: ${widget.order.id}\n--------------\norder address: ${widget.order.deliveryAddress?.address}, ${widget.order.deliveryAddress?.city}\n--------------\ncustomer name: ${widget.order.user.name}\n--------------\n";
              for (final OrderProduct product
                  in widget.order.orderProducts ?? []) {
                receiptText =
                    (receiptText ?? "") + "${product.product?.name}    ";
                receiptText = (receiptText) +
                    "x ${product.product?.selectedQty.toString()}    ";
                receiptText = (receiptText) +
                    "${product.product?.price.toString()}\n--------------\n";
                receiptText = (receiptText) +
                    "Order Sub-total${product.product.toString()}\n--------------\n";
                receiptText = (receiptText) +
                    "Delivery Fee${widget.order.deliveryFee.toString()}\n--------------\n";
                receiptText = (receiptText) +
                    "Order Total${widget.order.total.toString()}\n--------------\n\n";

                await printerService.printReceipt(receiptText);
              }

              /// for example: write tsc command
              ///
              //await Printing.layoutPdf(onLayout: (format) async => doc.save());
              // final bytes =
              //     await rootBundle.load("assets/images/app_icon_noBg.png");
              // final image = bytes.buffer.asUint8List();
              // await CommandTool.tscCommand.cleanCommand();
              // await CommandTool.tscCommand.cls();
              // await CommandTool.tscCommand.size(width: 76, height: 130);
              // await CommandTool.tscCommand.image(image: image, x: 50, y: 60);
              // await CommandTool.tscCommand.print(1);
              // final cmd = await CommandTool.tscCommand.getCommand();
              // if (cmd == null) return;
              // BluetoothPrintPlus.instance.write(cmd);
              // print();
              // final device =
              //     await FlutterBluetoothPrinter.selectDevice(context);
              // if (device != null) {
              //   /// do print
              //   controller?.print(
              //       address: _devices.last.address ?? "");
              // }
            },
            child: Text("Print Receipt"),
          ),
        ],
      ),
    );
  }

  //   ],
  // BasePageWithoutNavBar(
  //   showAppBar: true,
  //   showLeadingAction: true,
  //   elevation: 0,
  //   backgroundColor: Colors.grey.shade100,
  //   body: Column(
  //     children: [
  //       Expanded(
  //         flex: 2,
  //         child: (_devices.isEmpty == true)
  //             ? Center(
  //                 child: _deviceMessage.text
  //                     .color(Utils.textColorByTheme())
  //                     .semiBold
  //                     .xl3
  //                     .make(),
  //               )
  //             : ListView.builder(
  //                 itemCount: _devices.length,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return ListTile(
  //                       leading: Icon(Icons.print),
  //                       title: Text(_devices[index].name ?? ""),
  //                       subtitle: Text(_devices[index].address ?? ""),
  //                       onTap: () async {
  //                         setState(() {
  //                           _selectedDeviceIndex = index;
  //                         });
  //                         if (_devices[index].address != null) {
  //                           try {
  //                             await bluetoothPrint.connect(_devices[index]);
  //                           } catch (e) {
  //                             // print(e);
  //                           }
  //                           //_printReceipt(_devices[index]);
  //                         }
  //                       });
  //                 },
  //               ),
  //       ),
  //       Receipt(
  //         /// You can build your receipt widget that will be printed to the device
  //         /// Note that, this feature is in experimental, you should make sure your widgets will be fit on every device.
  //         builder: (context) => Column(children: [
  //           Center(child: Text("order id: ${widget.order.id.toString()}")),
  //           Text("customer name : ${widget.order.user.name}"),
  //           for (final OrderProduct order
  //               in widget.order.orderProducts ?? []) ...[
  //             Row(
  //               children: [
  //                 Text("item price     : ${order.product?.price}"),
  //                 Text("item name      : ${order.product?.name}"),
  //                 Text("item quantity  : ${order.product?.selectedQty}"),
  //               ],
  //             ),
  //           ],
  //           for (final OrderStop orderAddress
  //               in widget.order.orderStops ?? []) ...[
  //             Row(
  //               children: [
  //                 Text(
  //                     "customer address: ${orderAddress.deliveryAddress?.address}"),
  //                 Text(
  //                     "customer city   : ${orderAddress.deliveryAddress?.city}"),
  //               ],
  //             ),
  //           ],
  //           Text("order sub-total : ${widget.order.subTotal}"),
  //         ]),
  //         onInitialized: (controller) {
  //           setState(() {
  //             this.controller = controller;
  //           });
  //         },
  //       ),
  //       ElevatedButton(
  //           onPressed: () async {
  //             print();
  //             // final device =
  //             //     await FlutterBluetoothPrinter.selectDevice(context);
  //             // if (device != null) {
  //             //   /// do print
  //             //   controller?.print(
  //             //       address: _devices.last.address ?? "");
  //             // }
  //           },
  //           child: Text("Print Receipt"))
  //     ],
  //   )
  //
  //   //
  //   );
  // }

  Future<void> print() async {
    // final device = await FlutterBluetoothPrinter.selectDevice(context);
    // if (device != null) {
    /// do print
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // await controller?.print(
    //     address: _devices[_selectedDeviceIndex ?? 0].address ?? "");
    // });
    // });
  }
}

// Widget build(BuilderContext context){
//
// }

// Future<void> _printReceipt(BluetoothDevice device) async {
//   if (device.address != null) {
//     try {
//       await bluetoothPrint.connect(device);

//Map<String, dynamic> config = Map();
// config['width'] = 40; // 标签宽度，单位mm
// config['height'] = 70; // 标签高度，单位mm
// config['gap'] = 2; // 标签间隔，单位mm

// x、y坐标位置，单位dpi，1mm=8dpi
// List<LineText> list = [];
// list.add(
//   LineText(
//       linefeed: 1,
//       type: LineText.TYPE_TEXT,
//       weight: 2,
//       width: 2,
//       height: 2,
//       content: 'Huops App',
//       align: LineText.ALIGN_CENTER),
// );

//Map<String,dynamic>
// if (widget.order.isPackageDelivery) {
//print stops

// widget.order.orderStops?.forEachIndexed((index, orderStop) {
// list.add(
//   LineText(
//       linefeed: 1,
//       type: LineText.TYPE_TEXT,
//       weight: 0,
//       content: "Delivery Address: ${orderStop.deliveryAddress?.name}",
//       align: LineText.ALIGN_LEFT),
// );
// list.add(
//   LineText(
//       linefeed: 1,
//       type: LineText.TYPE_TEXT,
//       weight: 2,
//       content: "order id: ${orderStop.orderId}",
//       align: LineText.ALIGN_LEFT),
// );
//
// list.add(
//   LineText(
//       linefeed: 1,
//       type: LineText.TYPE_TEXT,
//       weight: 2,
//       content: "order name: ${orderStop.name}",
//       align: LineText.ALIGN_LEFT),
// );
//
// list.add(
//   LineText(
//       linefeed: 1,
//       type: LineText.TYPE_TEXT,
//       weight: 2,
//       content: "order name: ${orderStop.phone}",
//       align: LineText.ALIGN_LEFT),
// );
// if (index == 0) {
//bluetooth.printCustom("Pickup Address".tr(), 1, 0);
// } else {
// bluetooth.printCustom("Stop".tr(), 1, 0);
// }
//bluetooth.printCustom("${orderStop.deliveryAddress?.name}", 2, 0);
// recipient info
//bluetooth.printLeftRight("Name".tr(), "  ${orderStop.name}", 1);
//bluetooth.printLeftRight("Phone".tr(), "  ${orderStop.phone}", 1);
//bluetooth.printLeftRight("Note".tr(), "  ${orderStop.note}", 1);
//bluetooth.printNewLine();
// });

//await bluetoothPrint.printReceipt(config, list);

//
//bluetooth.printNewLine();
//bluetooth.printCustom("Package Details".tr(), 2, 0);
//bluetooth.printLeftRight(
//"Package Type".tr(), "  ${widget.order.packageType?.name}", 1);
//  bluetooth.printLeftRight(
//     "Width".tr() + "   ", "${widget.order.width} cm", 1);
// bluetooth.printLeftRight(
//      "Length".tr() + "   ", "${widget.order.length} cm", 1);
//  bluetooth.printLeftRight(
//      "Height".tr() + "   ", "${widget.order.height} cm", 1);
//  bluetooth.printLeftRight(
//      "Weight".tr() + "   ", "${widget.order.weight} kg", 1);
// }
//   } catch (e) {
//     print(e);
//   }
// }
// }
// }
