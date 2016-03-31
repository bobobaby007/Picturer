//
//  Log_home.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit
class Log_home: UIViewController {
    var _inited:Bool = false
    
    var _btn_signin:UIButton?
    var _btn_login:UIButton?
    
    let _btnH:CGFloat = 60
    let _btnGap:CGFloat = 2
    override func viewDidLoad() {
        _init()
    }
    
    func _init(){
        if _inited{
            return
        }
        self.view.backgroundColor = Config._color_yellow
        _btn_signin = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - 2*_btnH - _btnGap, width: self.view.frame.width, height: _btnH))
        _btn_signin?.backgroundColor = UIColor.whiteColor()
        _btn_signin?.setTitleColor(Config._color_yellow, forState: UIControlState.Normal)
        _btn_signin?.titleLabel?.font = Config._font_loginButton
        _btn_signin?.setTitle("注册", forState: UIControlState.Normal)
        _btn_signin?.addTarget(self, action: #selector(Log_home._buttonHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_login = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - _btnH, width: self.view.frame.width, height: _btnH))
        _btn_login?.backgroundColor = UIColor.whiteColor()
        _btn_login?.setTitleColor(Config._color_yellow, forState: UIControlState.Normal)
        _btn_login?.titleLabel?.font = Config._font_loginButton
        _btn_login?.setTitle("登录", forState: UIControlState.Normal)
        _btn_login?.addTarget(self, action: #selector(Log_home._buttonHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(_btn_signin!)
        self.view.addSubview(_btn_login!)
        
        
        _inited = true
    }
    func _buttonHander(__sender:UIButton){
        switch __sender{
        case _btn_signin!:
            let _v:Log_signin = Log_signin()
            self.navigationController?.pushViewController(_v, animated: true)
            break
        case _btn_login!:
            let _v:Log_login = Log_login()
            self.navigationController?.pushViewController(_v, animated: true)
            break
            
        default :
            break
        }
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        UIApplication.sharedApplication().statusBarHidden=true
        
    }
}
