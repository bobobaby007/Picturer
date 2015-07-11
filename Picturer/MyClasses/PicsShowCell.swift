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

protocol PicsShowCellDelegate:NSObjectProtocol{
    func PicDidSelected(pic:PicsShowCell)
}


class PicsShowCell:UICollectionViewCell{
   // @IBOutlet weak var _imgView:UIImageView!
   // @IBOutlet weak var _tag_view:UIImageView!
    
    var _imgView:UIImageView!
    var _tag_view:UIImageView!
    var _index:Int?
    
    var _delegate:PicsShowCellDelegate?
    
    
    var _hasTag:Bool=false{
//        get{
//            //return self._canSelect
//            return true
//        }
        didSet{
            _tag_view.hidden = !self._hasTag
        }
    }
    
   // var _callBack:((sender:PicsShowCell) -> Void)?
    
    var _selected:Bool=false{
        didSet{
            if _selected{
                _tag_view.image=UIImage(named: "pic_selected.png")
            }else{
                _tag_view.image=UIImage(named: "pic_unSelected.png")
            }
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        _imgView=UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        _imgView.contentMode=UIViewContentMode.ScaleAspectFill
        _imgView.layer.masksToBounds=true
        
        let _width=bounds.size.width/4
        _tag_view=UIImageView(frame: CGRect(x: bounds.size.width-_width-4, y:4, width: _width, height: _width))
        
        var _tapRoc=UITapGestureRecognizer(target: self, action: Selector("clickAction:"))
        
        //self.userInteractionEnabled=true
        //_imgView.userInteractionEnabled=true
        _tag_view.userInteractionEnabled=true
        
        _tag_view.addGestureRecognizer(_tapRoc)
       // _imgView.addGestureRecognizer(_tapRoc)
        //self.addGestureRecognizer(_tapRoc)
        
        addSubview(_imgView)
        addSubview(_tag_view)
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func clickAction(sender:UITapGestureRecognizer){
        self._selected = !self._selected
        _delegate?.PicDidSelected(self)
//        switch sender.view{
//        case self._tag_view as UIView:
//            self._selected = !self._selected
//        default:
//            self._selected = !self._selected
//        }
    }
    func _setPic(__pic:NSDictionary){
        switch __pic.objectForKey("type") as! String{
        case "alasset":
            let _al:ALAssetsLibrary=ALAssetsLibrary()
            _al.assetForURL(NSURL(string: __pic.objectForKey("url") as! String)! , resultBlock: { (asset:ALAsset!) -> Void in
                
                self._setImageByImage(UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!)
                //self._setImageByImage(UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())!)
                
                }, failureBlock: { (error:NSError!) -> Void in
                    
            })
        default:
            println()
        }
    }
    func _setCornerRadius(__set:CGFloat){
        _imgView.layer.cornerRadius=__set
        _imgView?.layer.masksToBounds=true
    }
    func _setImage(_img:String)->Void{
        _imgView.image=UIImage(named: _img as String)
    }
    func _setImageByImage(_img:UIImage)->Void{
        _imgView.image=_img
    }
    
    
    
}

