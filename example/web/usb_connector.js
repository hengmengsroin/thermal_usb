// usb_connector.js
if ('usb' in navigator) {
  console.log('WebUSB API is supported in this browser.');
  async function connectUSBDevice(vendorId) {
    try {
       const filters = [];
      if (vendorId) {
        filters.push({ vendorId: vendorId });
      }
      
      const device = await navigator.usb.requestDevice({
        filters:filters // Replace with your device's vendorId
      });
      
      console.log({device});
      console.log(`Device selected: ${device.productName}`);
      
      await device.open();
      console.log('Device opened.');

      if (device.configuration === null) {
        await device.selectConfiguration(1);
        console.log('Configuration selected.');
      }

      await device.claimInterface(0);
      console.log('Interface claimed.');

      await device.controlTransferOut({
        requestType: 'vendor',
        recipient: 'device',
        request: 0x01,
        value: 0x0001,
        index: 0x0000
      });
      console.log('Control transfer sent.');
    } catch (error) {
      console.error('Error:', error);
    }
  }

  window.connectUSBDevice = connectUSBDevice; // Expose function globally
} else {
  console.log('WebUSB API is not supported in this browser.');
  window.connectUSBDevice = () => {
    console.error('WebUSB API is not supported in this browser.');
  };
}