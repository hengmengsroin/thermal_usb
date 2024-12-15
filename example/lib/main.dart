import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:thermal_usb/thermal_usb.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart' as pos;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _thermalUsbPlugin = ThermalUsb();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _thermalUsbPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void connectUSB() {
    _thermalUsbPlugin.pairDevice();
    log("called pairDevice");
  }

  Future<void> printTest() async {
    var ticket = await testTicket();
    _thermalUsbPlugin.print(data: ticket);
    log("called pairDevice");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            spacing: 10,
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(onPressed: connectUSB, child: Text("Connect USB")),
              ElevatedButton(
                  onPressed: () async {
                    await printTest();
                  },
                  child: Text("Print Test"))
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<int>> testTicket() async {
  List<int> bytes = [];
  // Using default profile
  final profile = await pos.CapabilityProfile.load();
  final generator = pos.Generator(pos.PaperSize.mm80, profile);

  bytes += generator.text("Store Name",
      styles: pos.PosStyles(
          align: pos.PosAlign.center,
          bold: true,
          width: pos.PosTextSize.size2));
  bytes += generator.feed(1);
  bytes += generator.text('Invoice'.toUpperCase(),
      styles: pos.PosStyles(align: pos.PosAlign.center, bold: true));

  bytes += generator.row([
    pos.PosColumn(
        text: 'No: 123456789',
        width: 6,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.left)),
    pos.PosColumn(
        text: 'Date: 01/01/2023',
        width: 6,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.right)),
  ]);
  bytes += generator.row([
    pos.PosColumn(
        text: 'Cashier: John Doe',
        width: 6,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.left)),
    pos.PosColumn(
        text: 'Time: 12:01 PM',
        width: 6,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.right)),
  ]);

  bytes += generator.hr();
  bytes += generator.row([
    pos.PosColumn(
        text: 'Product',
        width: 5,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.left)),
    pos.PosColumn(
        text: 'Qty',
        width: 3,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.center)),
    pos.PosColumn(
        text: 'Price',
        width: 2,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.right)),
    pos.PosColumn(
        text: 'Total',
        width: 2,
        styles: pos.PosStyles(
            height: pos.PosTextSize.size1, align: pos.PosAlign.right)),
  ]);
  bytes += generator.hr();

  List<Map<String, dynamic>> items = [
    {'name': 'Item 1', 'qty': 1, 'unit': "Bottle", 'price': 10.0},
    {'name': 'Item 2', 'qty': 2, 'unit': "Blister", 'price': 20.0},
    {'name': 'Item 3', 'qty': 1, 'unit': "Tablet", 'price': 30.0},
    {'name': 'Item 4', 'qty': 3, 'unit': "Bottle", 'price': 40.0},
    {'name': 'Item 5', 'qty': 2, 'unit': "Bottle", 'price': 50.0},
  ];

  for (var item in items) {
    bytes += generator.row([
      pos.PosColumn(
          text: item['name'],
          width: 5,
          styles: pos.PosStyles(align: pos.PosAlign.left)),
      pos.PosColumn(
          text: '${item['qty']} ${item['unit']}',
          width: 3,
          styles: pos.PosStyles(align: pos.PosAlign.center)),
      pos.PosColumn(
          text: item['price'].toStringAsFixed(2),
          width: 2,
          styles: pos.PosStyles(align: pos.PosAlign.right)),
      pos.PosColumn(
          text: (item['qty'] * item['price']).toStringAsFixed(2),
          width: 2,
          styles: pos.PosStyles(align: pos.PosAlign.right)),
    ]);
  }

  bytes += generator.hr();
  double total =
      items.fold(0, (sum, item) => sum + (item['qty'] * item['price']));
  bytes += generator.row([
    pos.PosColumn(
        text: 'Total',
        width: 6,
        styles: pos.PosStyles(align: pos.PosAlign.left, bold: true)),
    pos.PosColumn(text: '', width: 2),
    pos.PosColumn(
        text: total.toStringAsFixed(2),
        width: 4,
        styles: pos.PosStyles(align: pos.PosAlign.right, bold: true)),
  ]);
  bytes += generator.feed(1);
  bytes += generator.text('Thank you for coming',
      styles: pos.PosStyles(align: pos.PosAlign.center));
  bytes += generator.feed(1);
  bytes += generator.cut();
  return bytes;
}
