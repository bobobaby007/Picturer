//
//  PicView.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/11.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class PicView: UIScrollView,UIScrollViewDelegate{
    var _imgView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.maximumZoomScale = 2.5
        self.minimumZoomScale = 1
        //self.bouncesZoom=false
        self.scrollEnabled=true
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        self.delegate=self
    }
    func _setPic(__pic:NSDictionary){
        switch __pic.objectForKey("type") as! String{
        case "alasset":
            let _al:ALAssetsLibrary=ALAssetsLibrary()
            
            _al.assetForURL(NSURL(string: __pic.objectForKey("url") as! String)! , resultBlock: { (asset:ALAsset!) -> Void in
                if asset != nil {
                    self._setImageByImage(UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!)
                }else{
                    self._setImage("entroLogo")//----用户删除时
                }
                //self._setImageByImage(UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!)
               // self._setImageByImage(UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!)
                
                }, failureBlock: { (error:NSError!) -> Void in
                    
            })
        default:
            println()
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return _imgView
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
       // _imgView?.center=self.center
    }
    func _setImage(_img:String){
        _imgView=UIImageView(frame: self.bounds)
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        _imgView!.image=UIImage(named: _img)
        self.addSubview(_imgView!)
    }
    func _setImageByImage(_img:UIImage){
        _imgView=UIImageView(frame:self.bounds)
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        _imgView?.image=_img
        self.addSubview(_imgView!)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}