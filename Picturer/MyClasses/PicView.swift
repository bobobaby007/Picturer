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
        _imgView=UIImageView(frame: self.bounds)
        _imgView?.contentMode=UIViewContentMode.ScaleAspectFit
        self.addSubview(_imgView!)
        self.delegate=self
    }
    func _refreshView(){
        _imgView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    func _setPic(__pic:NSDictionary,__block:(NSDictionary)->Void){
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
                __block(NSDictionary())
                }, failureBlock: { (error:NSError!) -> Void in
                    
            })
            
        case "file":
            self._setImage(__pic.objectForKey("url") as! String)
            __block(NSDictionary())
        case "fromWeb":
            ImageLoader.sharedLoader.imageForUrl(__pic.objectForKey("url") as! String, completionHandler: { (image, url) -> () in
               // _setImage(image)
                //println("")
                if self._imgView != nil{
                    //self._setImageByImage(image!)
                    self._imgView?.image=image
                    __block(NSDictionary())
                    
                }else{
                    println("out")
                }
                
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
        
        _imgView!.image=UIImage(named: _img)
        //self.addSubview(_imgView!)
    }
    func _setImageByImage(_img:UIImage){
        
        _imgView?.image=_img
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}