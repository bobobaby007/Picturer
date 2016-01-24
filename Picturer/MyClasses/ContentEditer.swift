//
//  Manage_description.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/14.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


protocol ContentEditer_delegate:NSObjectProtocol{
    func canceld()
    func saved(dict:NSDictionary)
}

class ContentEditer: UIViewController,UITextViewDelegate {
    weak var _delegate:ContentEditer_delegate?
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    var _title_label:UILabel?
    var _desInput:UITextView?
    var _desAlert:UILabel?
    
    var _maxNum:Int=20
    var _titleStr:String = ""
    var _content:String = ""
    
    var _tapRec:UITapGestureRecognizer?
    
    var _gap:CGFloat=15
    var _desPlaceHold:String?
    
    var _setuped:Bool=false
    
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
        
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.titleLabel?.font = Config._font_topButton
        
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-50, y: 5, width: 40, height: 62))
        _btn_save?.setTitle("保存", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(Config._color_yellow, forState: UIControlState.Normal)
        _btn_save?.titleLabel?.font = Config._font_topButton
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text=_titleStr
        //_desPlaceHold =
        
        var _lineNum:CGFloat = 1
        if _maxNum>20{
            _lineNum = 2
        }
        
        let _whiteBg:UIView = UIView(frame: CGRect(x: 0, y: _topBar!.frame.height+_gap, width: self.view.frame.width, height: _lineNum*45))
        var _line:UIView = UIView(frame: CGRect(x: 0, y: _topBar!.frame.height+_gap, width: self.view.frame.width, height: 0.5))
        _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
       self.view.addSubview(_whiteBg)
        self.view.addSubview(_line)
        _line = UIView(frame: CGRect(x: 0, y: _topBar!.frame.height+_gap+_lineNum*45, width: self.view.frame.width, height: 0.5))
        _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        self.view.addSubview(_line)
        
        _desInput=UITextView(frame: CGRect(x: 0, y: _topBar!.frame.height+_gap, width: self.view.frame.width, height: _lineNum*45))
        if _desPlaceHold != nil{
            _desInput?.text=_desPlaceHold
        }
        
        _desInput?.backgroundColor=UIColor.clearColor()
        _desInput?.font=Config._font_description_at_bottom
        _desInput?.textContainerInset = UIEdgeInsetsZero
        _desInput?.textContainer.lineFragmentPadding = 0
        _desInput?.text = _content
        //_desInput?.keyboardAppearance=UIKeyboardAppearance.Dark
        //_desInput?.returnKeyType=UIReturnKeyType.Done
        
        _desInput?.delegate=self
        _desInput?.becomeFirstResponder()
        
        _desAlert=UILabel(frame:CGRect(x: _gap, y: _desInput!.frame.origin.y+_desInput!.frame.height, width: self.view.frame.width-2*_gap, height: 20) )
        _desAlert?.text=String(_maxNum)
        _desAlert?.font=UIFont(name: "Helvetica", size: 14)
        
        _desAlert?.textColor=UIColor(white: 0.3, alpha: 1)
        _desAlert?.textAlignment=NSTextAlignment.Right
        
        
        self.view.addSubview(_topBar!)
        self.view.addSubview(_desInput!)
        self.view.addSubview(_desAlert!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        _topBar?.addSubview(_title_label!)
        _tapRec=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        _setuped=true
    }
    
    //----文字输入代理
    func textViewDidBeginEditing(textView: UITextView) {
        //        if _desInput?.text == _desPlaceHold{
        //            _desInput?.text=""
        //        }
        self.view.addGestureRecognizer(_tapRec!)
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let _n:Int=_desInput!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        
        if (_n+text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2)>_maxNum{
            return false
        }
        // println(text)
        return true
    }
    func textViewDidChange(textView: UITextView) {
        
        if _desInput?.text == _desPlaceHold{
            _desAlert?.text=String(_maxNum)
            return
        }
        
        var _n:Int=_desInput!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        if _n>=_maxNum{
            _n=_maxNum
            let _str:NSString=_desInput!.text as NSString
            _desInput!.text=_str.substringToIndex(_maxNum)
        }
        _desAlert?.text=String(_maxNum-_n)
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        
        _desInput?.resignFirstResponder()
        
        if _desInput?.text == ""{
            _desInput?.text=_desPlaceHold
        }
        self.view.removeGestureRecognizer(_tapRec!)
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            _delegate?.canceld()
        case _btn_save!:
            let _dict:NSMutableDictionary=NSMutableDictionary()
            if _desInput?.text != _desPlaceHold{
                _dict.setObject(_desInput!.text, forKey: "description")
            }
            
            
            _delegate?.saved(_dict)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            print(sender)
        }
        
    }
}
