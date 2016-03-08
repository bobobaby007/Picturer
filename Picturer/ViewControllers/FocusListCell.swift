//
//  UserListCell.swift
//  Picturer
//
//  Created by Bob Huang on 15/8/6.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


protocol FocusListCellDelegate:NSObjectProtocol{
    func _FocusActionAt(__index:Int)
    func _viewUserAt(__index:Int)
}

class FocusListCell:UITableViewCell {
    var _userImg:PicView?
    var _title:UILabel?
    var _des:UILabel?
    let _gap:CGFloat = 5
    var _btn_focus:UIButton?
    
    var _focusType:Int = 0
    weak var _delegate:FocusListCellDelegate?
    var _index:Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // print("cell:")
        _userImg = PicView(frame: CGRect(x: 10, y: 10, width: 35, height: 35))
        _userImg?.userInteractionEnabled = false
        _userImg?.layer.cornerRadius = 35/2
        //_userImg?._setImage("user_1.jpg")
        
        
        _title = UILabel(frame: CGRect(x: 55, y: 11, width: self.contentView.frame.width - 56 - _gap - _gap - 60, height: 17))
        _title?.font = Config._font_social_cell_name
        _title?.textColor = Config._color_social_black_title
        
        _des = UILabel(frame: CGRect(x: 55, y: 29.5, width: self.contentView.frame.width - 56 - _gap - _gap - 60, height: 17))
        _des?.font = Config._font_social_likeNum
        _des?.textColor = Config._color_gray_description
        
        
        _btn_focus = UIButton(frame: CGRect(x: self.contentView.frame.width - 2*_gap - _gap, y: 13.5, width: 60, height: 28))
        _btn_focus?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_focus?.titleLabel?.font = Config._font_social_button
        _btn_focus?.layer.cornerRadius = 5
        _btn_focus?.layer.borderColor = Config._color_social_gray_border.CGColor
        _btn_focus?.addTarget(self, action: "btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView.addSubview(_userImg!)
        self.contentView.addSubview(_des!)
        self.contentView.addSubview(_title!)
        self.contentView.addSubview(_btn_focus!)
        
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
        if __str == ""{
            _title?.frame.origin.y = 20
        }else{
            _title?.frame.origin.y = 11
        }
    }
    
    func btnHander(sender:UIButton){
        switch sender{
        case _btn_focus!:
            if _delegate != nil{
                _delegate?._FocusActionAt(_index)
            }
            break
        default:
            return
        }
    }
    
    func _setFocusType(__set:Int){
        _focusType = __set
        switch _focusType{
        case 0://---未关注
            _btn_focus!.backgroundColor = UIColor.whiteColor()
            _btn_focus?.layer.borderWidth = 1
            _btn_focus?.setTitle("关注", forState: UIControlState.Normal)
            break
        case 1://---互相关注
            _btn_focus!.backgroundColor = Config._color_yellow
            _btn_focus?.layer.borderWidth = 0
            _btn_focus?.setTitle("已关注", forState: UIControlState.Normal)
            break
        default:
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
