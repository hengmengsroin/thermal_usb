class UsbDevice {
  String type;
  String productId;
  String vendorId;
  bool connected = false;

  UsbDevice({
    required this.type,
    required this.productId,
    required this.vendorId,
    this.connected = false,
  });

  factory UsbDevice.fromMap(Map<String, dynamic> map,
      {bool connected = false}) {
    return UsbDevice(
      type: map['type'],
      productId: map['productId'],
      vendorId: map['vendorId'],
      connected: connected,
    );
  }
}
