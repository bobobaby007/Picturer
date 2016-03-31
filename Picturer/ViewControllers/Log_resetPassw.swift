//
//  Log_signin.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/12.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

class Log_resetPassw: UIViewController{
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    let _tableCellH:CGFloat=40
    
    let _buttonH:CGFloat = 45
    var _txt_mobile:UITextField?
    var _txt_smscode:UITextField?
    var _txt_password:UITextField?
    
    var _keyboardPointY:CGFloat = 0
    
    var _btn_go:UIButton?
    var _btn_Contenter:UIView?
    var _btn_getSmscode:UIButton?
    
    var _timer:NSTimer?
    var _currentSecond:Int = 0
    
    var _barH:CGFloat = 64
    override func viewDidLoad() {
        
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        let _bgView = UIImageView(image: UIImage(named: "bg.jpg"))
        _bgView.contentMode = UIViewContentMode.ScaleToFill
        _bgView.frame = self.view.bounds
        self.view.addSubview(_bgView)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH ))
        //_topBar?.backgroundColor=UIColor(white: 0, alpha: 0.2)
        
        let _blurV = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        //_blurV?.alpha = 0.5
        _blurV.frame = _topBar!.bounds
        _topBar?.addSubview(_blurV)
        _btn_cancel=UIButton(frame: CGRect(x: 10, y: 22, width: 30, height: 30))
        _btn_cancel?.center = CGPoint(x: 30, y: _barH/2+8)
        _btn_cancel?.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: #selector(Log_resetPassw.clickAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //        let _white:UIView = UIView(frame: CGRect(x: 0, y: _barH+_gap , width: self.view.frame.width, height: 4*_buttonH))
        //        _white.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
        //self.view.addSubview(_white)
        
        for var i:Int = 0;i<3; i += 1{
            let _line:UIView = UIView(frame: CGRect(x: _gap, y: _barH+_gap+CGFloat(i+1)*_buttonH-0.5, width: self.view.frame.width-2*_gap, height: 0.3))
            _line.backgroundColor = UIColor(white: 0, alpha: 0.2)
            self.view.addSubview(_line)
        }
        
        
        
        _txt_mobile = UITextField(frame: CGRect(x: _gap, y: _barH+_gap, width: self.view.frame.width-2*_gap, height: _buttonH))
        _txt_mobile?.keyboardType = UIKeyboardType.PhonePad
        _txt_mobile?.textColor = UIColor.whiteColor()
        //_txt_mobile?.font = _font_cell_title_normal
        _txt_mobile?.placeholder = "手机号码"
        _txt_mobile?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_mobile!)
        
        
        _txt_smscode = UITextField(frame: CGRect(x: _gap, y: _barH+_gap+_buttonH, width: self.view.frame.width-_gap-112.5, height: _buttonH))
        _txt_smscode?.keyboardType = UIKeyboardType.NumberPad
        _txt_smscode?.textColor = UIColor.whiteColor()
        //_txt_smscode?.font = _font_cell_title_normal
        _txt_smscode?.placeholder = "验证码"
        _txt_smscode?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_smscode!)
        
        
        
        _btn_getSmscode = UIButton(frame: CGRect(x: self.view.frame.width-_gap-94, y: _barH+_gap+_buttonH+(_buttonH-30)/2, width: 94, height: 30))
        _btn_getSmscode?.titleLabel?.font = UIFont.systemFontOfSize(12)
        //_btn_getSmscode?.setTitleColor(_color_black_title, forState: UIControlState.Normal)
        
        _btn_getSmscode?.setTitle("获取验证码", forState: UIControlState.Normal)
        
        _btn_getSmscode!.layer.borderColor = UIColor.whiteColor().CGColor
        _btn_getSmscode!.layer.borderWidth = 1
        _btn_getSmscode!.layer.cornerRadius = 15
        _btn_getSmscode?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_btn_getSmscode!)
        
        
        _txt_password = UITextField(frame: CGRect(x: _gap, y: _barH+_gap+2*_buttonH, width: self.view.frame.width-2*_gap, height: _buttonH))
        _txt_password?.textColor = UIColor.whiteColor()
        //_txt_password?.font = _font_cell_title_normal
        _txt_password?.secureTextEntry = true
        _txt_password?.placeholder = "输入新密码"
        _txt_password?.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(_txt_password!)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        //        _title_label?.font = _font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="重设密码"
        self.view.addSubview(_topBar!)
        
        _btn_Contenter = UIView(frame: CGRect(x: 0, y: self.view.frame.height-_buttonH, width: 0, height: _buttonH))
        _btn_Contenter?.clipsToBounds = true
        _btn_Contenter?.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        _btn_go = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: _buttonH))
        //        _btn_go?.backgroundColor = _color_yellow
        //        _btn_go?.setTitleColor(_color_white_title, forState: UIControlState.Normal)
        //        _btn_go?.titleLabel?.font = _font_cell_title
        _btn_go?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _btn_go?.setTitle("重设", forState: UIControlState.Normal)
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
            //            _btn_getSmscode?.titleLabel?.font = _font_cell_title_normal
            _btn_getSmscode?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            _btn_getSmscode?.setTitle("获取验证码", forState: UIControlState.Normal)
            _btn_getSmscode?.enabled = true
            _btn_getSmscode?.layer.borderColor = UIColor.whiteColor().CGColor
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
        MainInterface._changePassword(_txt_mobile!.text!,__code: _txt_smscode!.text!, __pass: _txt_password!.text!) { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    let _alerter:UIAlertView = UIAlertView(title: "", message: "修改密码成功，请重新登录", delegate: nil, cancelButtonTitle: "确定")
                    _alerter.show()
                })
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
        _btn_getSmscode?.enabled = false
        
        _btn_getSmscode?.setTitleColor(UIColor(white: 0, alpha: 0.2), forState: UIControlState.Normal)
        _btn_getSmscode?.layer.borderColor = UIColor(white: 0, alpha: 0.2).CGColor
        
        if _timer == nil{
            _timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerHander:", userInfo: nil, repeats: true)
            _timer?.fire()
        }
        MainInterface._getSms(_txt_mobile!.text!,__type: "changepassword") { (__dict) -> Void in
            if __dict.objectForKey("recode") as! Int == 200{
                
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let _alerter:UIAlertView = UIAlertView(title: "", message: __dict.objectForKey("reason") as? String, delegate: nil, cancelButtonTitle: "确定")
                    _alerter.show()
                    
                })
            }
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

