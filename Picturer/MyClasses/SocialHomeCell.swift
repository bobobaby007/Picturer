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

class SocailHomeCell:UICollectionViewCell {
    // @IBOutlet weak var _imgView:UIImageView!
    // @IBOutlet weak var _tag_view:UIImageView!
    
    var _imgView:UIImageView!
    var _tag_view:UIImageView!
    var _tag_circl:UIImageView!
    var _title:UILabel!
    var _tagNum:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let _iconW:CGFloat = bounds.size.width*0.6
       
        
        _imgView=UIImageView(frame: CGRect(x: (bounds.size.width - _iconW) * 0.5, y: (bounds.size.height - _iconW) * 0.5, width: _iconW, height: _iconW))
        _imgView.contentMode=UIViewContentMode.ScaleAspectFill
        _imgView.layer.masksToBounds=true
        _imgView.layer.cornerRadius = _imgView.frame.width/2
        
        let _width=bounds.size.width/6
        _tag_view=UIImageView(frame: CGRect(x: _imgView.frame.origin.x+_imgView.frame.width-_width/2+5, y:_imgView.frame.origin.y-5, width: _width, height: _width))
        _tag_view.image=UIImage(named: "icon_alert")
        
        
        
        let _width_c=bounds.size.width/11
        
        _tag_circl=UIImageView(frame: CGRect(x: _imgView.frame.origin.x+_imgView.frame.width-_width_c/2+3, y:_imgView.frame.origin.y-3, width: _width_c, height: _width_c))
        _tag_circl.image=UIImage(named: "icon_alert")
        
        _tagNum=UILabel()
        _tagNum.frame=CGRect(x:_tag_view.frame.origin.x,y:_tag_view.frame.origin.y+_tag_view.frame.size.height/2-7,width: _tag_view.frame.size.width,height: 14)
        _tagNum.numberOfLines=1
        //_tagNum.lineBreakMode=NSLineBreakMode.ByCharWrapping
        _tagNum.adjustsFontSizeToFitWidth=true
        _tagNum.textAlignment=NSTextAlignment.Center
       // _tagNum.sizeToFit()
        _tagNum.textColor=UIColor.whiteColor()
        
        
        
        _title=UILabel()
        
        _title.textColor=UIColor.whiteColor()
        _title.textAlignment=NSTextAlignment.Center
        _title.frame=CGRect(x:0,y:bounds.size.height-10,width: bounds.size.width,height: 10)
        
        
        addSubview(_imgView)
        addSubview(_tag_view)
        addSubview(_title)
        addSubview(_tagNum)
        addSubview(_tag_circl)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func _setTitle(_str:String){
        _title.text=_str
    }
    func _setAlertNum(_num:Int){
        if _num<0{
            _tagNum.hidden=true
            _tag_view.hidden=true
            
            _tag_circl.hidden=false
            
        }else if _num==0{
            _tagNum.hidden=true
            _tag_view.hidden=true
            _tag_circl.hidden=true
        }else{
            
            
            
            if _num>99{
                _tagNum.font=UIFont.systemFontOfSize(10)
                _tagNum.text="99+"
            }else if _num>9{
                _tagNum.font=UIFont.systemFontOfSize(12)
                _tagNum.text=String(_num)
            }else{
                _tagNum.font=UIFont.systemFontOfSize(16)
                _tagNum.text=String(_num)
            }
            
            _tagNum.hidden=false
            _tag_view.hidden=false
            _tag_circl.hidden=true
        }
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

    
    func _setImage(_img:String)->Void{
        _imgView.image=UIImage(named: _img as String)
    }
    func _setImageByImage(_img:UIImage)->Void{
        
        _imgView.image=_img
        
        
    }
    
    func _setTagHidden(__set:Bool)->Void{
        if _tag_view==nil{
            
        }else{
            _tag_view.hidden=__set
        }
        
    }
    func _setSelected(__set:Bool)->Void{
        
        
        
    }
    
    
}

