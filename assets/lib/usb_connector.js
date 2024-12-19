// usb_connector.js
if ("serial" in navigator) {
  console.log("WebUSB API is supported in this browser.");
  // const userAgent = navigator.userAgent.toLowerCase();
  let lastUsedDevice = null;
  let receiptPrinter = new WebSerialReceiptPrinter();
  //  let receiptPrinter = new WebUSBReceiptPrinter();
  // if (lastUsedDevice) receiptPrinter.reconnect(lastUsedDevice);
  receiptPrinter.addEventListener("connected", (device) => {
    console.log({ device });
    lastUsedDevice = device;
    window.onDeviceConnected({
      name: "WebUSB Printer",
      vendorId: device.vendorId ?? 1111,
      productId: device.productId ?? 1111,
      type: device.type,
    });
  });

  receiptPrinter.addEventListener("disconnect", () => {
    console.log("Disconnected");
    window.onDeviceDisconnected();
  });


  async function connectUSBDevice() {
    try {
      await receiptPrinter.connect();
      return true;
    } catch (error) {
      console.error("Error:", error);
      return false;
    }
  }

  function print(data) {
    console.log("Print test");
    console.log({ data });
    /* Print the receipt */
    receiptPrinter.print(data);
  }
  window.connectUSBDevice = connectUSBDevice; // Expose function globally
  window.print = print; // Expose function globally
} else {
  console.log("WebUSB API is not supported in this browser.");
  window.connectUSBDevice = () => {
    console.error("WebUSB API is not supported in this browser.");
  };
  window.print = () => {
    console.error("WebUSB API is not supported in this browser.");
  };
}
