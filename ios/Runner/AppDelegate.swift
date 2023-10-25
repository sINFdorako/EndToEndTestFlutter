import UIKit
import Flutter
import ReplayKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var replayKitHandler: ReplayKitHandler!
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller = window?.rootViewController as! FlutterViewController
    
    setupBatteryChannel(with: controller)
    setupReplayKitChannel(with: controller)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupBatteryChannel(with controller: FlutterViewController) {
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery", binaryMessenger: controller.binaryMessenger)
    
    batteryChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      // Handle battery messages.
      if call.method == "getBatteryLevel" {
        self.receiveBatteryLevel(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
  }
  
  private func setupReplayKitChannel(with controller: FlutterViewController) {
    replayKitHandler = ReplayKitHandler.shared
    let replayKitChannel = FlutterMethodChannel(name: "replay_kit", binaryMessenger: controller.binaryMessenger)
    
    replayKitChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      if call.method == "startRecording" {
        self.replayKitHandler.startRecording()
        result(nil)
      } else if call.method == "stopRecording" {
        self.replayKitHandler.stopRecording()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == UIDevice.BatteryState.unknown {
      result(FlutterError(code: "UNAVAILABLE", message: "Battery info unavailable", details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }
}
