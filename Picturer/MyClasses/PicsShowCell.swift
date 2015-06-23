//
//  PicsShowCell.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class PicsShowCell:UICollectionViewCell {
   // @IBOutlet weak var _imgView:UIImageView!
   // @IBOutlet weak var _tag_view:UIImageView!
    
    var _imgView:UIImageView!
    var _tag_view:UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _imgView=UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        _imgView.contentMode=UIViewContentMode.ScaleAspectFill
        _imgView.layer.masksToBounds=true
        
        let _width=bounds.size.width/5
        _tag_view=UIImageView(frame: CGRect(x: bounds.size.width-_width-2, y:2, width: _width, height: _width))
        addSubview(_imgView)
        addSubview(_tag_view)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        if __set{
            _tag_view.image=UIImage(named: "pic_selected.png")
        }else{
            _tag_view.image=UIImage(named: "pic_unSelected.png")
        }
        
       
    }
    
    
}

