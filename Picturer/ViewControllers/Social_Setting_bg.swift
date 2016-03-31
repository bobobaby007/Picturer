//
//  Log_home.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit


class Social_Setting_bg: UIViewController,ContentEditer_delegate{
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    
    let _tableCellH:CGFloat=40
    
    let _buttonH:CGFloat = 45
    
    
    weak var _naviDelegate:Navi_Delegate?
    
    
    
    
    
    let _setion_1_titles:NSArray = ["选择背景图片","从手机相册选择"]
    
    
    var _imageInputer:ImageInputer?
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets=false
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
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
        
        for i:Int in 0 ..< _setion_1_titles.count+1{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: Config._barH+_gap+CGFloat(i)*_buttonH-0.5, width: self.view.frame.width, height: 0.3))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.view.addSubview(_line)
            
            if i<_setion_1_titles.count{
                
                let _button:UIButton = UIButton(frame: CGRect(x: 0, y: Config._barH+_gap+CGFloat(i)*_buttonH, width: self.view.frame.width, height: _buttonH))
                _button.tag = i
                _button.backgroundColor = UIColor.whiteColor()
                _button.addTarget(self, action: #selector(Social_Setting_bg._btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(_button)
                
                let _label:UILabel = UILabel(frame: CGRect(x: _gap, y: Config._barH+_gap+CGFloat(i)*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
                _label.textColor = Config._color_black_title
                _label.font = Config._font_cell_title_normal
                _label.text = _setion_1_titles[i] as? String
                _label.userInteractionEnabled = false
                self.view.addSubview(_label)
            }
            if i < _setion_1_titles.count{
                let _arrowV:UIImageView = UIImageView(image: UIImage(named: "list_arrow.png"))
                _arrowV.frame = CGRect(x: self.view.frame.width-24, y: Config._barH+_gap+CGFloat(i)*_buttonH+16, width: 7.5, height: 12.72)
                _arrowV.userInteractionEnabled = false
                self.view.addSubview(_arrowV)
            }
        }
        
        
        
        
        //----
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        
        _btn_cancel?.addTarget(self, action: #selector(Social_Setting_bg.clickAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="更换背景图片"
        self.view.addSubview(_topBar!)
        
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Social_Setting_bg.keyboardHander(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Social_Setting_bg.keyboardHander(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        //_txt_mobil?.becomeFirstResponder()
        
        
        _setuped=true
    }
    func _btnHander(__sender:UIButton){
        switch __sender.tag{
        case 0://---
            
            break
        case 1://---
            
            break
        case 2://---
            
            break
        case 4://---
            
            break
        case 5://----
            
            break
        case 6://----
            break
        default:
            break
        }
        
    }
    //----编辑 代理
    func canceld() {
        
    }
    func saved(dict: NSDictionary) {
        
        
        
    }
    
    //---字体侦听
    func textHander(txt:UITextField){
        
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
            _naviDelegate?._cancel()
            self.navigationController?.popViewControllerAnimated(true)
            
        default:
            print(sender)
        }
    }
}

