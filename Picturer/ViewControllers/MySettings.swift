//
//  Log_home.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit
class MySettings: UIViewController {
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    let _tableCellH:CGFloat=40
    
    let _buttonH:CGFloat = 45
    
    let _setion_1_titles:NSArray = ["头像","名字","签名","Picturer帐号"]//----设置属性的名称
    let _setion_2_titles:NSArray = ["性别","生日","地区"]
    
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
        
        var _white:UIView = UIView(frame: CGRect(x: 0, y: Config._barH+_gap , width: self.view.frame.width, height: CGFloat(_setion_1_titles.count)*_buttonH))
        _white.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_white)
        for var i:Int = 0;i<_setion_1_titles.count+1; ++i{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: Config._barH+_gap+CGFloat(i)*_buttonH-0.5, width: self.view.frame.width, height: 0.3))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.view.addSubview(_line)
            
            if i<_setion_1_titles.count{
                let _label:UILabel = UILabel(frame: CGRect(x: _gap, y: Config._barH+_gap+CGFloat(i)*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
                _label.textColor = Config._color_black_title
                _label.font = Config._font_cell_title_normal
                _label.text = _setion_1_titles[i] as? String
                self.view.addSubview(_label)
            }
        }
        
        let _setion_2_y:CGFloat = Config._barH+_gap+CGFloat(_setion_2_titles.count)*_buttonH+45
        
        _white = UIView(frame: CGRect(x: 0, y: _setion_2_y , width: self.view.frame.width, height: CGFloat(_setion_1_titles.count)*_buttonH))
        _white.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_white)
        for var i:Int = 0;i<_setion_2_titles.count+1; ++i{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: _setion_2_y+CGFloat(i)*_buttonH-0.5, width: self.view.frame.width, height: 0.3))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.view.addSubview(_line)
            if i<_setion_2_titles.count{
                let _label:UILabel = UILabel(frame: CGRect(x: _gap, y: _setion_2_y+CGFloat(i)*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
                _label.textColor = Config._color_black_title
                _label.font = Config._font_cell_title_normal
                _label.text = _setion_2_titles[i] as? String
                self.view.addSubview(_label)
            }
        }
        
        
        
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
        
        
        _setuped=true
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
            self.navigationController?.popViewControllerAnimated(true)
        
        default:
            print(sender)
        }
    }
}

