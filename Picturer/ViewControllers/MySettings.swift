//
//  Log_home.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol MySettings_delegate:NSObjectProtocol{
    func _setting_saved()
    func _setting_back()
}

class MySettings: UIViewController,ContentEditer_delegate,ImageInputerDelegate{
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    weak var _delegate:MySettings_delegate?
    
    let _tableCellH:CGFloat=40
    
    let _buttonH:CGFloat = 60
    
    
    var _currentEditingType:String = ""
    
    static let _EditingType_avatar:String = "avatar"
    static let _EditingType_nickname:String = "nickname"
    static let _EditingType_signature:String = "signature"
    static let _EditingType_sex:String = "sex"
    static let _EditingType_area:String = "area"
    
    
    let _setion_1_titles:NSArray = ["头像","名字","签名","Picturer帐号"]//----设置属性的名称
    let _setion_2_titles:NSArray = ["性别","生日","地区"]
    
    var _userImg:PicView?
    var _userInfo:NSDictionary?
    var _label_nickName:UILabel?
    var _label_sign:UILabel?
    var _label_picturerId:UILabel?
    var _label_sex:UILabel?
    var _label_birthday:UILabel?
    var _label_area:UILabel?
    
    var _imageInputer:ImageInputer?
    
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=Config._color_bg_gray
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: Config._barH ))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        //---
        
        for var i:Int = 0;i<_setion_1_titles.count+1; ++i{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: Config._barH+_gap+CGFloat(i)*_buttonH-0.5, width: self.view.frame.width, height: 0.3))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.view.addSubview(_line)
            
            if i<_setion_1_titles.count{
                
                let _button:UIButton = UIButton(frame: CGRect(x: 0, y: Config._barH+_gap+CGFloat(i)*_buttonH, width: self.view.frame.width, height: _buttonH))
                _button.tag = i
                _button.backgroundColor = UIColor.whiteColor()
                _button.addTarget(self, action: "_btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(_button)
                
                let _label:UILabel = UILabel(frame: CGRect(x: _gap, y: Config._barH+_gap+CGFloat(i)*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
                _label.textColor = Config._color_black_title
                _label.font = Config._font_cell_title_normal
                _label.text = _setion_1_titles[i] as? String
                _label.userInteractionEnabled = false
                self.view.addSubview(_label)
            }
            if i < 3  {
                let _arrowV:UIImageView = UIImageView(image: UIImage(named: "list_arrow.png"))
                _arrowV.frame = CGRect(x: self.view.frame.width-24, y: Config._barH+_gap+CGFloat(i)*_buttonH+23, width: 7.5, height: 12.72)
                _arrowV.userInteractionEnabled = false
                self.view.addSubview(_arrowV)
            }
        }
        
        
        _userImg = PicView(frame: CGRect(x: self.view.frame.width-81, y: Config._barH+_gap+7, width: 45, height: 45))
        _userImg?.layer.cornerRadius = 22.5
        _userImg?._setImage("user_4.jpg")
        _userImg?.userInteractionEnabled = false
        self.view.addSubview(_userImg!)
        
        
        _label_nickName = UILabel(frame: CGRect(x: self.view.frame.width-260-38, y: Config._barH+_gap+1*_buttonH, width: 260, height: _buttonH))
        _label_nickName?.textAlignment = NSTextAlignment.Right
        _label_nickName?.userInteractionEnabled = false
        _label_nickName?.textColor = Config._color_gray_description
        _label_nickName?.font = Config._font_social_button_2
        self.view.addSubview(_label_nickName!)
        
        _label_sign = UILabel(frame: CGRect(x: self.view.frame.width-260-38, y: Config._barH+_gap+2*_buttonH, width: 260, height: _buttonH))
        _label_sign?.textAlignment = NSTextAlignment.Right
        _label_sign?.userInteractionEnabled = false
        _label_sign?.textColor = Config._color_gray_description
        _label_sign?.font = Config._font_social_button_2
        self.view.addSubview(_label_sign!)
        
        _label_picturerId = UILabel(frame: CGRect(x: self.view.frame.width-248-38, y: Config._barH+_gap+3*_buttonH, width: 248, height: _buttonH))
        _label_picturerId?.textAlignment = NSTextAlignment.Right
        _label_picturerId?.userInteractionEnabled = false
        _label_picturerId?.textColor = Config._color_gray_description
        _label_picturerId?.font = Config._font_social_button_2
        self.view.addSubview(_label_picturerId!)
        
        
        //------第二部分
        
        let _setion_2_y:CGFloat = Config._barH+_gap+CGFloat(_setion_1_titles.count)*_buttonH+45
        for var i:Int = 0;i<_setion_2_titles.count+1; ++i{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: _setion_2_y+CGFloat(i)*_buttonH-0.5, width: self.view.frame.width, height: 0.3))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.view.addSubview(_line)
            
            
            
            
            if i<_setion_2_titles.count{
                
                let _button:UIButton = UIButton(frame: CGRect(x: 0, y: _setion_2_y+CGFloat(i)*_buttonH, width: self.view.frame.width, height: _buttonH))
                _button.tag = 4+i
                _button.backgroundColor = UIColor.whiteColor()
                _button.addTarget(self, action: "_btnHander:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(_button)
                
                let _label:UILabel = UILabel(frame: CGRect(x: _gap, y: _setion_2_y+CGFloat(i)*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
                _label.textColor = Config._color_black_title
                _label.font = Config._font_cell_title_normal
                _label.text = _setion_2_titles[i] as? String
                self.view.addSubview(_label)
            }
            
            if i < 3 {
                let _arrowV:UIImageView = UIImageView(image: UIImage(named: "list_arrow.png"))
                _arrowV.frame = CGRect(x: self.view.frame.width-24, y: _setion_2_y+CGFloat(i)*self._buttonH+23, width: 7.5, height: 12.72)
                _arrowV.userInteractionEnabled = false
                self.view.addSubview(_arrowV)
            }
            
        }
        
        _label_sex = UILabel(frame: CGRect(x: self.view.frame.width-248-38, y: _setion_2_y+0*_buttonH, width: 248, height: _buttonH))
        _label_sex?.textAlignment = NSTextAlignment.Right
        _label_sex?.userInteractionEnabled = false
        _label_sex?.textColor = Config._color_gray_description
        _label_sex?.font = Config._font_social_button_2
        self.view.addSubview(_label_sex!)
        
        _label_birthday = UILabel(frame: CGRect(x: self.view.frame.width-248-38, y: _setion_2_y+1*_buttonH, width: 248, height: _buttonH))
        _label_birthday?.textAlignment = NSTextAlignment.Right
        _label_birthday?.userInteractionEnabled = false
        _label_birthday?.textColor = Config._color_gray_description
        _label_birthday?.font = Config._font_social_button_2
        self.view.addSubview(_label_birthday!)
        
        _label_area = UILabel(frame: CGRect(x: self.view.frame.width-248-38, y: _setion_2_y+2*_buttonH, width: 248, height: _buttonH))
        _label_area?.textAlignment = NSTextAlignment.Right
        _label_area?.userInteractionEnabled = false
        _label_area?.textColor = Config._color_gray_description
        _label_area?.font = Config._font_social_button_2
        self.view.addSubview(_label_area!)
        
        
        //----
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="编辑资料"
        self.view.addSubview(_topBar!)
        
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHander:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHander:", name: UIKeyboardWillHideNotification, object: nil)
        
        //_txt_mobil?.becomeFirstResponder()
        
        _setDict(_userInfo!)
        
        _setuped=true
    }
    func _btnHander(__sender:UIButton){
        switch __sender.tag{
        case 0://---头像
            _currentEditingType = MySettings._EditingType_avatar
            _openImageInputer()
            break
        case 1://---名字
            _currentEditingType = MySettings._EditingType_nickname
            
            let _editor:ContentEditer = ContentEditer()
            _editor._titleStr = "名字"
            _editor._content = self._userInfo?.objectForKey("nickname") as! String
             _editor._delegate = self
            self.navigationController?.pushViewController(_editor, animated: true)
            break
        case 2://---签名
            _currentEditingType = MySettings._EditingType_signature
            let _editor:ContentEditer = ContentEditer()
            _editor._titleStr = "签名"
            _editor._content = self._userInfo?.objectForKey("signature") as! String
             _editor._delegate = self
            _editor._maxNum = 20
            _editor._lineNum = 2
            self.navigationController?.pushViewController(_editor, animated: true)
            break
        case 4://---性别
            
            _currentEditingType = MySettings._EditingType_sex
            let _editor:ContentEditer = ContentEditer()
            _editor._titleStr = "性别"
            _editor._selecterArray = ["男","女"]
            _editor._type="selecter"
            _editor._selectedIndex = self._userInfo?.objectForKey("sex") as! Int
            _editor._delegate = self
            self.navigationController?.pushViewController(_editor, animated: true)
            break
        case 5://----生日
            
            break
        case 6://----地区
            _currentEditingType = MySettings._EditingType_area
            break
        default:
            break
        }
        
    }
    
    //----图片代理
    func _openImageInputer(){
        if _imageInputer == nil{
            _imageInputer = ImageInputer()
            _imageInputer?._parentViewController = self
            _imageInputer?._delegate = self
            self.addChildViewController(_imageInputer!)
            self.view.addSubview(_imageInputer!.view)
        }
    }
    
    //-----imageinputer 代理
    func _imageInputer_canceled() {
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
    }
    
    func _imageInputer_saved() {
        let _img:UIImage = _imageInputer!._captureBgImage()
        _userImg?._setImageByImage(_img)
        
        MainInterface._changeUserAvatar(_img) { (__dict) -> Void in
            
        }
        
        _imageInputer?.view.removeFromSuperview()
        _imageInputer?.removeFromParentViewController()
        _imageInputer = nil
    }
    //----编辑 代理
    func canceld() {
        
    }
    func saved(dict: NSDictionary) {
        
        let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _userInfo!)
        switch _currentEditingType{
        case MySettings._EditingType_nickname:
            _dict.setObject(dict.objectForKey("content") as! String, forKey: "nickname")
            break
        case MySettings._EditingType_sex:
            _dict.setObject(dict.objectForKey("content") as! Int, forKey: "sex")
            break
        case MySettings._EditingType_signature:
            _dict.setObject(dict.objectForKey("content") as! String, forKey: "signature")
            break
        default:
            break
        }
        _userInfo = _dict
        self._setDict(_userInfo!)
        
        MainInterface._updateUserInfo(_userInfo!) { (__dict) -> Void in
            if self._delegate != nil{
                self._delegate?._setting_saved()
            }
        }
    }
    
    //---字体侦听
    func textHander(txt:UITextField){
        
    }
    
    func _setDict(__dict:NSDictionary){
        self._userInfo = __dict
        self._title_label?.text=self._userInfo?.objectForKey("nickname") as? String
        _userImg?._loadImage(MainInterface._imageUrl(_userInfo?.objectForKey("avatar") as! String))
        self._label_nickName?.text = self._userInfo?.objectForKey("nickname") as? String
        self._label_sex?.text = MainInterface._sexStr(self._userInfo?.objectForKey("sex") as! Int)
        self._label_sign?.text = self._userInfo?.objectForKey("signature") as? String
        self._label_nickName?.text = self._userInfo?.objectForKey("nickname") as? String
        print("用户信息：",__dict)

    }
    
    
    
    //-----键盘侦听
    func keyboardHander(notification:NSNotification){
        let _name = notification.name
        let _info = notification.userInfo
        let _frame:CGRect = (_info![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        
        
        switch _name{
        case UIKeyboardWillHideNotification:
            
            break
        case UIKeyboardWillShowNotification:
            
            break
        default:
            break
        }
        _refreshView()
        // print(_info)
    }
    func _refreshView(){
        
    }
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            _delegate?._setting_back()
            self.navigationController?.popViewControllerAnimated(true)
            
        default:
            print(sender)
        }
    }
}

