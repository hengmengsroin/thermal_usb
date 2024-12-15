// usb_connector.js
if ("usb" in navigator) {
  console.log("WebUSB API is supported in this browser.");
  const userAgent = navigator.userAgent.toLowerCase();
  let receiptPrinter = new WebSerialReceiptPrinter();

  async function connectUSBDevice() {
    try {
      receiptPrinter.addEventListener("connected", (device) => {
        console.log({ device });
      });

      receiptPrinter.addEventListener("disconnect", () => {
        console.log("Disconnected");
      });

      receiptPrinter.connect();
    } catch (error) {
      console.error("Error:", error);
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
