//
//  PicsShowCell.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary



class PicsShowCellOfCamera:UICollectionViewCell{    
    override init(frame: CGRect) {
        //println("go")
        super.init(frame: frame)
        let _camera:CameraPreview = CameraPreview(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(_camera)
        _camera._beginSession()
        let _blurV = UIVisualEffectView(effect:  UIBlurEffect(style: UIBlurEffectStyle.Light))
        _blurV.frame = self.bounds
        //_blurV.alpha = 0.2
        addSubview(_blurV)
        let _imageV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 23))
        _imageV.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        _imageV.image = UIImage(named: "camera")
        
        addSubview(_imageV)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

