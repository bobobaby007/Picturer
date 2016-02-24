//
//  UserListCell.swift
//  Picturer
//
//  Created by Bob Huang on 15/8/6.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class NewsListCell:UITableViewCell {
    var _userImg:PicView?
    var _title:UILabel?
    var _des:UILabel?
    let _gap:CGFloat = 5
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // print("cell:")
        _userImg = PicView(frame: CGRect(x: 12, y: 4, width: 50, height: 50))
        _userImg?.userInteractionEnabled = false
        _userImg?.layer.cornerRadius = 25
        _userImg?._setImage("user_1.jpg")
        
        
        _title = UILabel(frame: CGRect(x: 77, y: 14, width: self.contentView.frame.width - 77 - _gap, height: 17))
        _title?.font = Config._font_social_cell_name
        _title?.textColor = Config._color_social_black_title
        
        
        _des = UILabel(frame: CGRect(x: 77, y: 32, width: self.contentView.frame.width - 77 - _gap, height: 17))
        _des?.font = Config._font_social_likeNum
        _des?.textColor = Config._color_gray_description
        
        
        self.contentView.addSubview(_userImg!)
        self.contentView.addSubview(_des!)
        self.contentView.addSubview(_title!)
        
        
    }
    
    func _setPic(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (__dict) -> Void in
            
        })
    }
    func _setTitle(__str:String){
        _title?.text = __str
    }
    func _setDes(__str:String){
        _des?.text = __str
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
