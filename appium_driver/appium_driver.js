const wdio = require("webdriverio");
const assert = require("assert");
const { byValueKey } = require("appium-flutter-finder");


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

let osSpecificOps = {};

if (process.env.APPIUM_OS === "ios" || !process.env.APPIUM_OS) {
  osSpecificOps = {
    platformName: "iOS",
    "appium:platformVersion": "16.6.1",
    "appium:deviceName": "iPhone SE",
    "appium:udid": "00008030-000D04583E79802E",
    "appium:noReset": true,
    "appium:bundleId": "com.example.driverNativeAppium",
    "appium:automationName": "XCUITest",
    "appium:xcodeOrgId": "com.example.driverNativeAppium",
    "appium:xcodeSigningId": "iPhone Developer",
    "appium:updatedWDABundleId": "com.example.driverNativeAppium.WebDriverAgent"
  };
} else if (process.env.APPIUM_OS === "android") {
  osSpecificOps = {
    platformName: "android",
    "appium:deviceName": "Pixel 2",
    "appium:app": __dirname + "/../apps/app-free-debug.apk",
  };
}

const opts = {
  port: 4723,
  capabilities: {
    ...osSpecificOps,
    "appium:automationName": "Flutter",
    "appium:retryBackoffTime": 500,
  },
};

(async () => {
  const startRecordButton = byValueKey("startRecordingButton");
  const stopRecordButton = byValueKey("stopRecordingButton");
  const batteryButton = byValueKey("batteryButton");

  const driver = await wdio.remote(opts);

  await driver.elementClick(startRecordButton);
  await driver.touchAction({
    action: 'tap',
    element: { elementId: startRecordButton }
  });

  sleep(1000)

  await driver.elementClick(stopRecordButton);
  await driver.touchAction({
    action: 'tap',
    element: { elementId: stopRecordButton }
  });

  sleep(1000)

  await driver.switchContext('NATIVE_APP');

  const doneButton = await driver.$('~Done');
  await doneButton.click();

  await driver.switchContext('FLUTTER');

  await driver.elementClick(batteryButton);
  await driver.touchAction({
    action: 'tap',
    element: { elementId: batteryButton }
  });

  driver.deleteSession();
})();
