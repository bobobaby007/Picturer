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
    var _myFrame:CGRect?
    var _imgView:PicView!
    var _tag_view:UIImageView!
    var _index:Int?
    
    weak var _delegate:PicsShowCellDelegate?
   
    var _uploadingTag:UIView?
    
    var _hasTag:Bool=false{
//        get{
//            //return self._canSelect
//            return true
//        }
        didSet{
           // println(_hasTag)
            //_tag_view.image=UIImage(named: "pic_unSelected.png")
            _tag_view.hidden = !self._hasTag            
            _tag_view.userInteractionEnabled=self._hasTag
        }
        
    }
    var _canSelectInside:Bool=false{
        didSet{
            _tag_view.userInteractionEnabled=self._canSelectInside
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
    
    
    func _setCorner(__set:CGFloat){
        _imgView!._imgView!.layer.cornerRadius=__set
        _imgView!._imgView!.layer.masksToBounds=true
    }
    
    
    override init(frame: CGRect) {
        //println("go")
        super.init(frame: frame)
        _myFrame = frame
        _imgView=PicView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        _imgView?._isThumb = true
        _imgView._scaleType = PicView._ScaleType_Full
        _imgView!._imgView!.layer.masksToBounds=true
        _imgView.userInteractionEnabled = false
        
        let _width=_myFrame!.width/2
        _tag_view=UIImageView(frame: CGRect(x: _myFrame!.width-_width, y:0, width: _width, height: _width))
        
        let _tapRoc=UITapGestureRecognizer(target: self, action: Selector("clickAction:"))
        
        //self.userInteractionEnabled=true
        //_imgView.userInteractionEnabled=true
        
        
        _tag_view.addGestureRecognizer(_tapRoc)
       // _imgView.addGestureRecognizer(_tapRoc)
        //self.addGestureRecognizer(_tapRoc)
        
        addSubview(_imgView)
        addSubview(_tag_view)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
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
    func _isUploading(__is:Bool){
        if __is{
            if _uploadingTag == nil{
                _uploadingTag = UIView(frame: CGRect(x: 0, y: 0, width: _myFrame!.width, height: _myFrame!.height))
                _uploadingTag?.backgroundColor = UIColor(white: 0.5, alpha: 0.6)
                let _ing:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
                _ing.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                _ing.center = CGPoint(x: _myFrame!.width/2,y: _myFrame!.height/2)
                _ing.startAnimating()
                _uploadingTag?.addSubview(_ing)
            }
            self.addSubview(_uploadingTag!)
        }else{
            if _uploadingTag != nil{
                _uploadingTag?.removeFromSuperview()
                _uploadingTag = nil
            }

        }
    }
    func _setPic(__pic:NSDictionary){
        if let _url = __pic.objectForKey("thumbnail") as? String{
            _imgView!._setPic(NSDictionary(objects: [MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{_ in
            })
            return
        }
        _imgView._setPic(__pic) {_ in
            
        }
    }
    func _setCornerRadius(__set:CGFloat){
        _imgView.layer.cornerRadius=__set
        _imgView?.layer.masksToBounds=true
    }    
    
    
}

