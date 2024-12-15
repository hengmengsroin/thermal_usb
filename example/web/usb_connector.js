// usb_connector.js
if ("usb" in navigator) {
  console.log("WebUSB API is supported in this browser.");
  // const receiptPrinter = new WebUSBReceiptPrinter();
  const receiptPrinter = new WebSerialReceiptPrinter();
  receiptPrinter.addEventListener("connected", (device) => {
    console.log({ device });
    console.log(
      `Connected to ${device.manufacturerName} ${device.productName} (#${device.serialNumber})`
    );

    printerLanguage = device.language;
    printerCodepageMapping = device.codepageMapping;

    /* Store device for reconnecting */
    lastUsedDevice = device;

    let encoder = new ReceiptPrinterEncoder({
      language: "esc-pos",
      columns: 48,
      feedBeforeCut: 4,
      // codepageMapping: printerCodepageMapping,
    });
    let data = encoder
      .initialize()
      .text("The quick brown fox jumps over the lazy dog")
      .newline()
      .qrcode("https://nielsleenheer.com")
      .cut("full")
      .encode();

    /* Print the receipt */
    receiptPrinter.print(data);
  });

  async function connectUSBDevice(vendorId) {
    try {
      const filters = [{ classCode: 0x07 }];
      if (vendorId) {
        filters.push({ vendorId: vendorId });
      }
      receiptPrinter.connect();
    } catch (error) {
      console.error("Error:", error);
    }
  }

  window.connectUSBDevice = connectUSBDevice; // Expose function globally
} else {
  console.log("WebUSB API is not supported in this browser.");
  window.connectUSBDevice = () => {
    console.error("WebUSB API is not supported in this browser.");
  };
}
