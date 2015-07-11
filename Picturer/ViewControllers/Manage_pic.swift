//
//  Manage_pic.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class Manage_pic: UIViewController{
    
    @IBOutlet weak var _btn_back:UIButton?
    var _imgView:UIImageView?

    var _imgPath:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        if _btn == _btn_back{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }    
    
    func _setPic(__pic:NSDictionary){
        switch __pic.objectForKey("type") as! String{
            case "alasset":
                let _al:ALAssetsLibrary=ALAssetsLibrary()
                _al.assetForURL(NSURL(string: __pic.objectForKey("url") as! String)! , resultBlock: { (asset:ALAsset!) -> Void in
                    
                    //self._setImageByImage(UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!)
                    self._setImageByImage(UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!)
                    
                    }, failureBlock: { (error:NSError!) -> Void in
                        
                })
        default:
            println()
        }
    }
    
    func _setImage(_img:String){
        _imgPath=_img
        _imgView=UIImageView(frame: self.view.frame)
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
       _imgView!.image=UIImage(named: _imgPath!)
        self.view.addSubview(_imgView!)
    }
    func _setImageByImage(_img:UIImage){
        _imgView=UIImageView(frame: self.view.frame)
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        _imgView?.image=_img
        self.view.addSubview(_imgView!)
    }
    
    
    
}