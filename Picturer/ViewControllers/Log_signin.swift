//
//  Log_signin.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/12.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

class Log_signin: UIViewController{
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    let _tableCellH:CGFloat=40
    
    let _buttonH:CGFloat = 45
    var _txt_mobile:UITextField?
    var _txt_smscode:UITextField?
    var _txt_nickname:UITextField?
    var _txt_password:UITextField?
    
    var _keyboardPointY:CGFloat = 0
    
    var _btn_go:UIButton?
    var _btn_Contenter:UIView?
    var _btn_getSmscode:UIButton?
    
    var _timer:NSTimer?
    var _currentSecond:Int = 0
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
        
        let _white:UIView = UIView(frame: CGRect(x: 0, y: Config._barH+_gap , width: self.view.frame.width, height: 4*_buttonH))
        _white.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(_white)
        
        for var i:Int = 0;i<5; ++i{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: Config._barH+_gap+CGFloat(i)*_buttonH-0.5, width: self.view.frame.width, height: 0.3))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            self.view.addSubview(_line)
        }
        
        
        
        _txt_mobile = UITextField(frame: CGRect(x: _gap, y: Config._barH+_gap, width: self.view.frame.width-2*_gap, height: _buttonH))
        _txt_mobile?.keyboardType = UIKeyboardType.PhonePad
        _txt_mobile?.textColor = Config._color_black_title
        _txt_mobile?.font = Config._font_cell_title_normal
        _txt_mobile?.placeholder = "手机号码"
        _txt_mobile?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_mobile!)
        
        
        _txt_smscode = UITextField(frame: CGRect(x: _gap, y: Config._barH+_gap+_buttonH, width: self.view.frame.width-_gap-112.5, height: _buttonH))
        _txt_smscode?.keyboardType = UIKeyboardType.NumberPad
        _txt_smscode?.textColor = Config._color_black_title
        _txt_smscode?.font = Config._font_cell_title_normal
        _txt_smscode?.placeholder = "验证码"
        _txt_smscode?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_smscode!)
        
        let _line:UIView = UIView(frame: CGRect(x: self.view.frame.width-_gap-100, y: Config._barH+_gap+_buttonH+7.5, width: 0.3, height: _buttonH-15))
        _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        self.view.addSubview(_line)
        
        _btn_getSmscode = UIButton(frame: CGRect(x: self.view.frame.width-_gap-94, y: Config._barH+_gap+_buttonH+1, width: 100, height: _buttonH-2))
        _btn_getSmscode?.titleLabel?.font = Config._font_cell_title_normal
        _btn_getSmscode?.setTitleColor(Config._color_black_title, forState: UIControlState.Normal)
        
        _btn_getSmscode?.setTitle("获取验证码", forState: UIControlState.Normal)
        _btn_getSmscode?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_btn_getSmscode!)
        
        
        _txt_nickname = UITextField(frame: CGRect(x: _gap, y: Config._barH+_gap+2*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
        _txt_nickname?.textColor = Config._color_black_title
        _txt_nickname?.font = Config._font_cell_title_normal
        _txt_nickname?.placeholder = "昵称"
        _txt_nickname?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_nickname!)
        
        
        _txt_password = UITextField(frame: CGRect(x: _gap, y: Config._barH+_gap+3*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
        _txt_password?.textColor = Config._color_black_title
        _txt_password?.font = Config._font_cell_title_normal
        _txt_password?.secureTextEntry = true
        _txt_password?.placeholder = "设置密码"
        _txt_password?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_password!)
        
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="注册"
        self.view.addSubview(_topBar!)
        
        _btn_Contenter = UIView(frame: CGRect(x: 0, y: self.view.frame.height-_buttonH, width: 0, height: _buttonH))
        _btn_Contenter?.clipsToBounds = true
        
        _btn_go = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: _buttonH))
        _btn_go?.backgroundColor = Config._color_yellow
        _btn_go?.setTitleColor(Config._color_white_title, forState: UIControlState.Normal)
        _btn_go?.titleLabel?.font = Config._font_cell_title
        _btn_go?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_go?.setTitle("注册", forState: UIControlState.Normal)
        _btn_go?.clipsToBounds = true
        
        self.view.addSubview(_btn_Contenter!)
        _btn_Contenter!.addSubview(_btn_go!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHander:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHander:", name: UIKeyboardWillHideNotification, object: nil)
        
        //_txt_mobil?.becomeFirstResponder()
        
        
        _setuped=true
    }
    
    //---字体侦听
    func textHander(txt:UITextField){
        if _checkAllIn(){
            _showButton()
        }else{
            _hideButton()
        }
    }
    
    
    //------检查字是否完全填入
    func _checkAllIn()->Bool{
        
        if _txt_mobile?.text == ""{
            return false
        }
        if _txt_nickname?.text == ""{
            return false
        }
        if _txt_password?.text == ""{
            return false
        }
        if _txt_smscode?.text == ""{
            return false
        }
        
        
        return true
    }
    
    //-----键盘侦听
    func keyboardHander(notification:NSNotification){
        let _name = notification.name
        let _info = notification.userInfo
        let _frame:CGRect = (_info![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        _keyboardPointY = _frame.origin.y
        
        
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
    //-----倒计时
    func timerHander(timer:NSTimer){
       // print(timer)
        _currentSecond += 1
        _btn_getSmscode?.setTitle(String(60-_currentSecond)+"s", forState: UIControlState.Normal)
        if _currentSecond>=60{
            _btn_getSmscode?.titleLabel?.font = Config._font_cell_title_normal
            _btn_getSmscode?.setTitleColor(Config._color_black_title, forState: UIControlState.Normal)
            _btn_getSmscode?.setTitle("获取验证码", forState: UIControlState.Normal)
            _btn_getSmscode?.enabled = true
            _currentSecond = 0
            _timer?.invalidate()
            _timer = nil
        }
    }
    func _checkPhone()->Bool{
        let _str:String = _txt_mobile!.text!
        if _str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)<11{
            return false
        }
        return true
    }
    //----注册
    func _go(){
        MainInterface._signup(_txt_mobile!.text!, __pass: _txt_password!.text!,__nickname: _txt_nickname!.text!) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
               Log_Main._self?._hide()
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let _alerter:UIAlertView = UIAlertView(title: "", message: __dict.objectForKey("reason") as? String, delegate: nil, cancelButtonTitle: "确定")
                    _alerter.show()

                })
                
            }
        }
    }
    //----发送验证码
    func _sendSmscode(){
        _btn_getSmscode?.setTitleColor(Config._color_gray_description, forState: UIControlState.Normal)
        _btn_getSmscode?.enabled = false
        if _timer == nil{
            _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerHander:", userInfo: nil, repeats: true)
            _timer?.fire()
        }
    }
    
    func _refreshView(){
        _btn_Contenter?.frame.origin = CGPoint(x: 0, y: _keyboardPointY-_buttonH)
    }
    func _showButton(){
        UIView.animateWithDuration(0.5) { () -> Void in
            self._btn_Contenter?.frame.size = CGSize(width: self.view.frame.width, height: self._buttonH)
        }
    }
    func _hideButton(){
        UIView.animateWithDuration(0.5) { () -> Void in
            self._btn_Contenter?.frame.size = CGSize(width: 0, height: self._buttonH)
        }
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_getSmscode!:
            if _checkPhone(){
                _sendSmscode()
            }else{
                let _alerter:UIAlertView = UIAlertView(title: "", message: "请输入手机号", delegate: nil, cancelButtonTitle: "确定")
                _alerter.show()
            }
            break
        case _btn_go!:
            _go()
            break
        default:
            print(sender)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
    }
    
}

