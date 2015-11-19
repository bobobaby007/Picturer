//
//  CameraPreview.swift
//  Picturer
//
//  Created by Bob Huang on 15/11/6.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraPreview:UIView{
    let captureSession = AVCaptureSession()
    var captureDevice:AVCaptureDevice?
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(){
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices{
            if device.hasMediaType(AVMediaTypeVideo){
                if device.position == AVCaptureDevicePosition.Back{
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
    }
    
    func _beginSession(){
        setup()
        if captureDevice == nil{
            return
        }
        do{
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        }catch{
            print("00000:",error)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer!)
        
        previewLayer!.frame = self.layer.frame
        captureSession.startRunning()
    }
    
    
    
}

