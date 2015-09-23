//
//  SearchResult_user_Cell.swift
//  Picturer
//
//  Created by Bob Huang on 15/8/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class SearchResult_user_Cell:UITableViewCell {
    var _setuped:Bool = false
    var _picV:PicView?
    var _nameLabel:UILabel?
    var _desLabel:UILabel?
    var _gap:CGFloat = 15
    var _defaultW:CGFloat = 0
    
    func setup(__w:CGFloat){
        if _setuped{
            return
        }
        _defaultW = __w
        _picV = PicView(frame:CGRect(x: _gap, y: 7.5, width: 40, height: 40))
        _picV!._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV!.maximumZoomScale = 1
        _picV!.minimumZoomScale = 1
        
        _picV!._imgView?.layer.cornerRadius = 20
        _picV!._imgView?.layer.masksToBounds = true
        
        self.addSubview(_picV!)
        
        _nameLabel = UILabel()
        _nameLabel!.font = UIFont.systemFontOfSize(14)
        self.addSubview(_nameLabel!)
        
        _desLabel = UILabel()
        _desLabel!.frame = CGRect(x: 40+2*_gap, y: 30, width: _defaultW-40-2*_gap, height: 15)
        _desLabel!.font = UIFont.systemFontOfSize(13)
        _desLabel!.textColor = UIColor(white: 0.8, alpha: 1)
        self.addSubview(_desLabel!)
        _setuped = true
    }
    func _setUserImg(__pic:NSDictionary){
        _picV?._setPic(__pic, __block: { (dict) -> Void in
            
        })
    }
    func _setName(__str:String){
       _nameLabel?.text = __str
    }
    func _setDes(__str:String){
        if __str == ""{
            _desLabel?.hidden = true
            _nameLabel!.frame = CGRect(x: 40+2*_gap, y: 20, width: _defaultW-40-2*_gap, height: 15)
        }else{
            _desLabel?.hidden = false
            _desLabel?.text = __str
            _nameLabel!.frame = CGRect(x: 40+2*_gap, y: 10, width: _defaultW-40-2*_gap, height: 15)
        }

    
    }
    
}
