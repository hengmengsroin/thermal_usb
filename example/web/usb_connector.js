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
    // window.onDeviceConnected(device);
    window.onDeviceConnected({
      name: "WebUSB Printer",
      vendorId: 0x04d8,
      productId: 0x00df,
    });
  });

  receiptPrinter.addEventListener("disconnect", () => {
    console.log("Disconnected");
    window.onDeviceDisconnected();
  });
  async function connectUSBDevice() {
    try {
      receiptPrinter.connect();
      // navigator.serial.requestPort();
      // const port = await navigator.serial.requestPort();
      // const info = port.getInfo();
      // console.log({ info });
      // await port.open({ baudRate: 9600 });
      // const writer = port.writable.getWriter();

      // const data = new Uint8Array([104, 101, 108, 108, 111]); // hello
      // await writer.write(data);
      // writer.releaseLock();
      // await port.close();
      // console.log("Connected to:", port.getInfo());
    } catch (error) {
      console.error("Error:", error);
      window.onError({
        error,
      });
    }
  }

  function print(data) {
    console.log("Print test");
    console.log({ data });
    /* Print the receipt */
    receiptPrinter.reconnect(lastUsedDevice);
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
