//
//  ViewController.swift
//  customCamera
//
//  Created by Bogdan on 2/23/20.
//  Copyright © 2020 Bogdan Zarioiu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var cameraView: UIView!
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    let settings = AVCapturePhotoSettings()
    var previewLayer = AVCaptureVideoPreviewLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //access the AV video devices
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera], mediaType: .video, position: .back)
        
        for device in discoverySession.devices {
            if device.position == AVCaptureDevice.Position.back {
                
                do {
                    let input =  try AVCaptureDeviceInput(device: device)
                    if captureSession.canAddInput(input) {
                        captureSession.addInput(input)
                        settings.livePhotoVideoCodecType = .jpeg
                        
                        if captureSession.canAddOutput(sessionOutput) {
                            captureSession.addOutput(sessionOutput)
                            captureSession.startRunning()
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            
                            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                            
                            cameraView.layer.addSublayer(previewLayer)
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            
                            previewLayer.bounds = cameraView.frame
                        }
                       
                    }
                        
                    
                } catch {
                    print("There was an error while trying to take a picture")
                }
                
            }
        }
        
        
    }
    
    //taking a picture
    @IBAction func picturePressed(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        sessionOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    
    //save picture to camera roll
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()!
        UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
        
  
        
        
        
    }

    
  

}

