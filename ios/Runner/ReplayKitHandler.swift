//
//  ReplayKitHandler.swift
//  Runner
//
//  Created by Dominik Rakowski on 25.10.23.
//

import Foundation
import ReplayKit

class ReplayKitHandler: NSObject, RPScreenRecorderDelegate, RPPreviewViewControllerDelegate {
  static let shared = ReplayKitHandler()
  
  func startRecording() {
    let recorder = RPScreenRecorder.shared()
    recorder.delegate = self
    recorder.startRecording { (error) in
      if let error = error {
        print("Error starting recording: \(error.localizedDescription)")
      } else {
        print("Recording started")
      }
    }
  }
  
  func stopRecording() {
    let recorder = RPScreenRecorder.shared()
    recorder.stopRecording { (previewViewController, error) in
      if let error = error {
        print("Error stopping recording: \(error.localizedDescription)")
      } else {
        print("Recording stopped")
        if let previewViewController = previewViewController {
          previewViewController.previewControllerDelegate = self
          DispatchQueue.main.async {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
              rootViewController.present(previewViewController, animated: true, completion: nil)
            }
          }
        }
      }
    }
  }
    
 func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
    // Dismiss the preview controller
    previewController.dismiss(animated: true, completion: nil)
    
    print("Preview controller dismissed")
    // You can add additional actions here if needed
 }

}
